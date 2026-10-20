#!/usr/bin/env python3
# Generates r72-rvv-12.S next to this file.
# RC5-72, 12 keys per call: three interleaved 4-lane streams (T-Head RVV 0.7.1).
#
# Each key schedule step has three phases (P1, P2, P3). Stream s runs one phase
# behind stream s-1, so each group of instructions mixes both vector pipes.
# The encryption runs inside the third key schedule round: each encryption
# half step is split over P2, P3 and the next P1 of the same stream, and reads
# S[i] from the register that holds it. A list scheduler orders each group.
import os
import re

NS = 3
NSTEP = 77                      # steps 1-77; step 0 is in the prologue


# key schedule registers per stream: L0 L1 L2 SP U X NX
def KR(s, k): return 'v%d' % (1 + 7 * s + k)
def L(s, j): return KR(s, j)
def SP(s): return KR(s, 3)
def U(s): return KR(s, 4)
def X(s): return KR(s, 5)
def NX(s): return KR(s, 6)


# encryption registers per stream: A B E
def EA(s): return 'v%d' % (22 + 3 * s)
def EB(s): return 'v%d' % (23 + 3 * s)
def E1(s): return 'v%d' % (24 + 3 * s)


PTR = ['a3', 'a4', 'a5']
BASE = ['a2', 'a6', 'a7']

# ---------------------------------------------------------------- scheduler
PIPE = {'vadd': 'A', 'vneg': 'A', 'vmv': 'A',
        'vsll': 'B', 'vsrl': 'B', 'vor': 'B', 'vxor': 'B',
        'vle': 'M', 'vse': 'M'}
LAT = float(os.environ.get('R72_LAT', '4.25'))     # measured result latency
OCC = {'A': 2.1, 'B': 2.1,                         # measured pipe occupancy
       'M': float(os.environ.get('R72_MOCC', '2.2'))}


def meta(txt):
    m = txt.split()[0]
    vregs = re.findall(r'\bv\d+\b', txt)
    sregs = re.findall(r'\b[ta]\d\b', txt)
    if m.startswith('th.'):
        base = m[3:].split('.')[0]
        pipe = PIPE[base]
        if base == 'vse':
            return (txt, pipe, [], vregs + sregs)
        return (txt, pipe, vregs[:1], vregs[1:] + sregs)
    return (txt, 'S', sregs[:1], sregs[1:])


def ptr_of(txt):
    m = re.search(r'\((a\d)\)', txt)
    return m.group(1) if m else None


class Sim:
    def __init__(self):
        self.t = 0.0
        self.pipe = {'A': 0.0, 'B': 0.0, 'M': 0.0}
        self.ready = {}

    def at(self, ins):
        _, pipe, _, src = ins
        t = self.t
        for r in src:
            t = max(t, self.ready.get(r, 0.0))
        if pipe in self.pipe:
            t = max(t, self.pipe[pipe])
        return t

    def issue(self, ins):
        _, pipe, dst, _ = ins
        t = self.at(ins)
        if pipe in self.pipe:
            self.pipe[pipe] = t + OCC[pipe]
        for r in dst:
            self.ready[r] = t + (LAT if pipe != 'S' else 1.0)
        self.t = t + 1.0


def schedule(lst, sim):
    """Pick the op that can issue first. Keep RAW, WAR, WAW and memory order."""
    n = len(lst)
    done = [False] * n
    out = []

    def ok(i):
        _, pipe, dst, src = lst[i]
        for j in range(i):
            if done[j]:
                continue
            _, p2, d2, s2 = lst[j]
            if set(src) & set(d2) or set(dst) & set(d2) or set(dst) & set(s2):
                return False
            if pipe == 'M' and p2 == 'M' and ptr_of(lst[i][0]) == ptr_of(lst[j][0]):
                return False
        return True

    for _ in range(n):
        best = None
        for i in range(n):
            if done[i] or not ok(i):
                continue
            t = sim.at(lst[i])
            if best is None or t < best[0] - 1e-9:
                best = (t, i)
        i = best[1]
        done[i] = True
        sim.issue(lst[i])
        out.append('\t' + lst[i][0])
    return out


# ---------------------------------------------------------------- code
def ks_ops(s, ph, n):
    """Key schedule step n, phase ph, stream s."""
    Lp, Lj = L(s, (n - 1) % 3), L(s, n % 3)
    r = []
    if ph == 0:
        if n <= 25:     # first round: old S[i] is the constant in t5
            r.append('th.vadd.vx\t%s, %s, t5' % (U(s), SP(s)))
        else:
            r.append('th.vle.v\t%s, (%s)' % (U(s), PTR[s]))
            r.append('th.vadd.vv\t%s, %s, %s' % (U(s), U(s), SP(s)))
        r.append('th.vadd.vv\t%s, %s, %s' % (X(s), U(s), Lp))
        r.append('th.vsll.vx\t%s, %s, t3' % (NX(s), X(s)))
        r.append('th.vsrl.vx\t%s, %s, t4' % (U(s), X(s)))
    elif ph == 1:
        r.append('th.vadd.vv\t%s, %s, %s' % (SP(s), NX(s), U(s)))   # S[i] = rotl3
        if n <= 51:     # the third round keeps S[i] in SP for the encryption
            r.append('th.vse.v\t%s, (%s)' % (SP(s), PTR[s]))
        r.append('th.vadd.vv\t%s, %s, %s' % (X(s), SP(s), Lp))
        r.append('th.vadd.vv\t%s, %s, %s' % (U(s), Lj, X(s)))
        r.append('th.vneg.v\t%s, %s' % (NX(s), X(s)))
    else:
        r.append('th.vsrl.vv\t%s, %s, %s' % (NX(s), U(s), NX(s)))
        r.append('th.vsll.vv\t%s, %s, %s' % (U(s), U(s), X(s)))
        r.append('th.vor.vv\t%s, %s, %s' % (Lj, U(s), NX(s)))
        if n in (25, 51):
            r.append('mv\t\t%s, %s' % (PTR[s], BASE[s]))
        elif n < NSTEP:
            r.append('addi\t\t%s, %s, 16' % (PTR[s], PTR[s]))
    return r


def enc_ops(s, h, part):
    """Encryption half step h (uses S[h+2] in SP), part 0, 1 or 2."""
    X1, Y1 = (EA(s), EB(s)) if h % 2 == 0 else (EB(s), EA(s))
    if part == 0:
        return ['th.vxor.vv\t%s, %s, %s' % (E1(s), X1, Y1),
                'th.vneg.v\t%s, %s' % (X1, Y1)]
    if part == 1:
        return ['th.vsrl.vv\t%s, %s, %s' % (X1, E1(s), X1),
                'th.vsll.vv\t%s, %s, %s' % (E1(s), E1(s), Y1)]
    return ['th.vor.vv\t%s, %s, %s' % (X1, E1(s), X1),
            'th.vadd.vv\t%s, %s, %s' % (X1, X1, SP(s))]


out = []
w = out.append
w('''/*
 * RC5-72 key schedule and encryption for twelve keys at a time.
 * RISC-V with T-Head vector 0.7.1 (Allwinner D1, C906). Needs xtheadvector.
 * Generated by gen-r72-rvv-12.py. Edit the generator, not this file.
 *
 * void r72_rvv12_kernel(u32 *res, const u32 *args, u32 *scratch);
 *   args:    L2[12], L1[12], L0[12], plain.lo, plain.hi
 *   scratch: 3 * 26 * 16 bytes for S, 16 byte aligned
 *   res:     A[12], B[12]
 */
#define P_CONST 0xB7E15163
#define Q_CONST 0x9E3779B9

	.option arch, +xtheadvector
	.text
	.align 2
	.globl	r72_rvv12_kernel
	.type	r72_rvv12_kernel, @function
r72_rvv12_kernel:
	li		t0, 4
	th.vsetvli	zero, t0, e32, m1, d1
	li		t3, 3
	li		t4, 29
	li		t6, Q_CONST
	addi		a6, a2, 416
	addi		a7, a6, 416
	mv		t0, a1''')
for j in (2, 1, 0):
    for s in range(NS):
        w('\tth.vle.v\t%s, (t0)\n\taddi\t\tt0, t0, 16' % L(s, j))
w('''	lw		t1, 144(a1)
	lw		t2, 148(a1)
	li		t5, (((P_CONST << 3) | (P_CONST >> 29)) & 0xFFFFFFFF)''')
# step 0: S[0] = rotl3(P), L[0] = rotl(L[0] + S[0], S[0])
for s in range(NS):
    w('\tth.vmv.v.x\t%s, t5' % SP(s))
for s in range(NS):
    w('\tth.vse.v\t%s, (%s)' % (SP(s), BASE[s]))
    w('\taddi\t\t%s, %s, 16' % (PTR[s], BASE[s]))
for s in range(NS):
    w('\tth.vadd.vv\t%s, %s, %s' % (U(s), L(s, 0), SP(s)))
    w('\tth.vneg.v\t%s, %s' % (NX(s), SP(s)))
for s in range(NS):
    w('\tth.vsll.vv\t%s, %s, %s' % (X(s), U(s), SP(s)))
    w('\tth.vsrl.vv\t%s, %s, %s' % (NX(s), U(s), NX(s)))
for s in range(NS):
    w('\tth.vor.vv\t%s, %s, %s' % (L(s, 0), X(s), NX(s)))
w('\tli\t\tt5, ((P_CONST + Q_CONST) & 0xFFFFFFFF)')

sim = Sim()
for k in range(3 * NSTEP + NS - 1):
    w('\t/* group %d */' % k)
    lst = []
    for s in range(NS):
        t = k - s
        if not 0 <= t < 3 * NSTEP:
            continue
        ph, n = t % 3, 1 + t // 3
        ops = ks_ops(s, ph, n)
        if ph == 1 and 54 <= n <= NSTEP:
            ops += enc_ops(s, n - 54, 0)
        if ph == 2:
            if n == 52:         # A = plain.lo + S[0]
                ops.append('th.vadd.vx\t%s, %s, t1' % (EA(s), SP(s)))
            elif n == 53:       # B = plain.hi + S[1]
                ops.append('th.vadd.vx\t%s, %s, t2' % (EB(s), SP(s)))
            elif 54 <= n <= NSTEP:
                ops += enc_ops(s, n - 54, 1)
        if ph == 0 and 55 <= n <= NSTEP:
            ops += enc_ops(s, n - 55, 2)
        lst += [meta(o) for o in ops]
        if s == NS - 1 and ph == 0 and n <= 25:
            lst.append(meta('addw\t\tt5, t5, t6'))
    out += schedule(lst, sim)

w('\t/* last encryption part */')
lst = []
for s in range(NS):
    lst += [meta(o) for o in enc_ops(s, 23, 2)]
out += schedule(lst, sim)
for s in range(NS):
    w('\tth.vse.v\t%s, (a0)\n\taddi\t\ta0, a0, 16' % EA(s))
for s in range(NS):
    w('\tth.vse.v\t%s, (a0)\n\taddi\t\ta0, a0, 16' % EB(s))
w('''	ret
	.size	r72_rvv12_kernel, .-r72_rvv12_kernel
''')

path = os.environ.get('R72_OUT') or \
    os.path.join(os.path.dirname(os.path.abspath(__file__)), 'r72-rvv-12.S')
with open(path, 'w') as f:
    f.write('\n'.join(out))
