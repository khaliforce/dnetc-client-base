# Generates rc5-72/riscv64/r72-rvv-12.S : RC5-72, 12 keys per call, three interleaved 4-lane streams.
NS=3

import re as _re
_PIPE={'vadd':'A','vneg':'A','vsub':'A','vmv':'A','vsll':'B','vsrl':'B','vor':'B','vxor':'B','vle':'M','vse':'M'}
def meta(txt):
    t=txt.split()
    m=t[0]
    if m.startswith('th.'):
        base=m[3:].split('.')[0]
        pipe=_PIPE[base]
        regs=_re.findall(r'\bv\d+\b',txt)
        if base=='vse': return pipe,[],regs  # store reads its data register
        return pipe,regs[:1],regs[1:]
    return 'S',[],[]
LAT=4.25; OCC={'A':2.1,'B':2.1,'M':2.2}
class Sim:
    def __init__(self):
        self.t=0.0; self.pipe={'A':0.0,'B':0.0,'M':0.0}; self.ready={}
    def at(self,ins):
        txt,pipe,dst,src=ins
        t=self.t
        for r in src: t=max(t,self.ready.get(r,0.0))
        if pipe in self.pipe: t=max(t,self.pipe[pipe])
        return t
    def issue(self,ins):
        txt,pipe,dst,src=ins
        t=self.at(ins)
        if pipe in self.pipe: self.pipe[pipe]=t+OCC[pipe]
        for r in dst: self.ready[r]=t+LAT
        self.t=t+1.0
        return t
def schedule(ins_list,sim,order_only=False):
    """In-order list scheduling inside one group. Keep RAW, WAR and WAW order."""
    n=len(ins_list); done=[False]*n; res=[]
    def deps_ok(i):
        txt,pipe,dst,src=ins_list[i]
        for j in range(i):
            if done[j]: continue
            _,_,d2,s2=ins_list[j]
            if (set(src)&set(d2)) or (set(dst)&set(d2)) or (set(dst)&set(s2)): return False
            # memory ordering: keep stores and loads of the same pointer in order
            if pipe=='M' and ins_list[j][1]=='M' and ptr_of(ins_list[i][0])==ptr_of(ins_list[j][0]): return False
            if pipe=='S' and ins_list[j][1]=='S': return False
        return True
    for _ in range(n):
        best=None
        for i in range(n):
            if done[i] or not deps_ok(i): continue
            t=sim.at(ins_list[i])
            if best is None or t<best[0]-1e-9: best=(t,i)
        i=best[1]; done[i]=True; sim.issue(ins_list[i]); res.append(ins_list[i][0])
    return res
def ptr_of(txt):
    m=_re.search(r'\((a\d)\)',txt); return m.group(1) if m else None
def R(s,k): return 'v%d'%(1+10*s+k)       # L0 L1 L2 SP U X T T1 T2 NX
def L(s,j): return R(s,j)
SP=lambda s:R(s,3); U=lambda s:R(s,4); X=lambda s:R(s,5); T=lambda s:R(s,6)
T1=lambda s:R(s,7); T2=lambda s:R(s,8); NX=lambda s:R(s,9)
PTR=['a3','a4','a5']; BASE=['a2','a6','a7']
out=[]
w=out.append
w('''/*
 * RC5-72 key schedule and encryption for twelve keys at a time.
 * RISC-V with T-Head vector 0.7.1 (Allwinner D1, C906). Needs xtheadvector.
 * Generated; edit the generator, not this file.
 *
 * void r72_rvv12_kernel(u32 *res, const u32 *args, u32 *scratch);
 *   args:    L2[12], L1[12], L0[12], plain.lo, plain.hi
 *   scratch: 3 * 26 * 16 bytes for S, 16 byte aligned
 *   res:     A[12], B[12]
 *
 * Three streams of four keys run in a software pipeline. Each key schedule
 * step has three phases. The streams are one phase apart, so every group of
 * instructions mixes both vector pipes.
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
	mv		t0, a1
''')
# load L tables: L2, L1, L0 for streams 0..2
for j in (2,1,0):
    for s in range(NS):
        w('\tth.vle.v\t%s, (t0)\n\taddi\t\tt0, t0, 16'%L(s,j))
w('''	lw		t1, 144(a1)
	lw		t2, 148(a1)
	li		t5, (((P_CONST << 3) | (P_CONST >> 29)) & 0xFFFFFFFF)''')
# step 0
for s in range(NS):
    w('\tth.vmv.v.x\t%s, t5'%SP(s))
for s in range(NS):
    w('\tth.vse.v\t%s, (%s)'%(SP(s),BASE[s]))
for s in range(NS):
    w('\taddi\t\t%s, %s, 16'%(PTR[s],BASE[s]))
for s in range(NS):
    w('\tth.vadd.vv\t%s, %s, %s'%(T(s),L(s,0),SP(s)))
    w('\tth.vneg.v\t%s, %s'%(NX(s),SP(s)))
for s in range(NS):
    w('\tth.vsll.vv\t%s, %s, %s'%(T1(s),T(s),SP(s)))
    w('\tth.vsrl.vv\t%s, %s, %s'%(T2(s),T(s),NX(s)))
for s in range(NS):
    w('\tth.vor.vv\t%s, %s, %s'%(L(s,0),T1(s),T2(s)))
w('\tli\t\tt5, ((P_CONST + Q_CONST) & 0xFFFFFFFF)')

NSTEP=77
def op(s,ph,j,n):
    i=n%26; jp=(n-1)%3; jj=n%3
    Lp=L(s,jp); Lj=L(s,jj)
    r0 = n<=25
    if ph==0:
        if j==0: return ('th.vadd.vx\t%s, %s, t5'%(U(s),SP(s))) if r0 else ('th.vle.v\t%s, (%s)'%(U(s),PTR[s]))
        if j==1: return None if r0 else 'th.vadd.vv\t%s, %s, %s'%(U(s),U(s),SP(s))
        if j==2: return 'th.vadd.vv\t%s, %s, %s'%(X(s),U(s),Lp)
        if j==3: return 'th.vsll.vx\t%s, %s, t3'%(T1(s),X(s))
        if j==4: return 'th.vsrl.vx\t%s, %s, t4'%(T2(s),X(s))
    if ph==1:
        if j==0: return 'th.vadd.vv\t%s, %s, %s'%(SP(s),T1(s),T2(s))
        if j==1: return 'th.vse.v\t%s, (%s)'%(SP(s),PTR[s])
        if j==2: return 'th.vadd.vv\t%s, %s, %s'%(X(s),SP(s),Lp)
        if j==3: return 'th.vadd.vv\t%s, %s, %s'%(T(s),Lj,X(s))
        if j==4: return 'th.vneg.v\t%s, %s'%(NX(s),X(s))
    if ph==2:
        if j==0: return 'th.vsll.vv\t%s, %s, %s'%(T1(s),T(s),X(s))
        if j==1: return 'th.vsrl.vv\t%s, %s, %s'%(T2(s),T(s),NX(s))
        if j==2: return 'th.vor.vv\t%s, %s, %s'%(Lj,T1(s),T2(s))
        if j==3:
            if n in (25,51): return 'mv\t\t%s, %s'%(PTR[s],BASE[s])
            return 'addi\t\t%s, %s, 16'%(PTR[s],PTR[s])
    return None
sim=Sim()
def mk(txt):
    pipe,dst,src=meta(txt.strip())
    # scalar ops that touch pointers: model pointer as a pseudo register
    if pipe=='S':
        regs=_re.findall(r'\ba\d\b|\bt\d\b',txt)
        dst=regs[:1]; src=regs[1:]
    else:
        src=src+_re.findall(r'\b[ta]\d\b',txt)
    return (txt,pipe,dst,src)
for k in range(3*NSTEP+NS-1):
    w('\t/* group %d */'%k)
    cur=[]
    for s in range(NS):
        t=k-s
        cur.append((s,(t%3),1+t//3) if 0<=t<3*NSTEP else None)
    lst=[]
    for j in range(5):
        for e in cur:
            if e is None: continue
            s,ph,n=e
            o=op(s,ph,j,n)
            if o: lst.append(mk('\t'+o))
    for e in cur:
        if e and e[0]==NS-1 and e[1]==0 and e[2]<=25:
            lst.append(mk('\taddw\t\tt5, t5, t6'))
    for txt in schedule(lst,sim): w(txt)
# encryption
w('\t/* encryption */')
for s in range(NS):
    w('\tmv\t\t%s, %s'%(PTR[s],BASE[s]))
EA=lambda s:L(s,0); EB=lambda s:L(s,1)
for s in range(NS):
    w('\tth.vle.v\t%s, (%s)\n\taddi\t\t%s, %s, 16'%(EA(s),PTR[s],PTR[s],PTR[s]))
    w('\tth.vle.v\t%s, (%s)\n\taddi\t\t%s, %s, 16'%(EB(s),PTR[s],PTR[s],PTR[s]))
for s in range(NS):
    w('\tth.vadd.vx\t%s, %s, t1'%(EA(s),EA(s)))
    w('\tth.vadd.vx\t%s, %s, t2'%(EB(s),EB(s)))
for h in range(24):
    for j in range(8):
        for s in range(NS):
            X1,Y1=(EA(s),EB(s)) if h%2==0 else (EB(s),EA(s))
            if j==0: w('\tth.vle.v\t%s, (%s)'%(U(s),PTR[s]))
            if j==1: w('\tth.vxor.vv\t%s, %s, %s'%(X(s),X1,Y1))
            if j==2: w('\tth.vneg.v\t%s, %s'%(NX(s),Y1))
            if j==3: w('\tth.vsll.vv\t%s, %s, %s'%(T1(s),X(s),Y1))
            if j==4: w('\tth.vsrl.vv\t%s, %s, %s'%(T2(s),X(s),NX(s)))
            if j==5: w('\tth.vor.vv\t%s, %s, %s'%(T1(s),T1(s),T2(s)))
            if j==6: w('\tth.vadd.vv\t%s, %s, %s'%(X1,T1(s),U(s)))
            if j==7: w('\taddi\t\t%s, %s, 16'%(PTR[s],PTR[s]))
for s in range(NS):
    w('\tth.vse.v\t%s, (a0)\n\taddi\t\ta0, a0, 16'%EA(s))
for s in range(NS):
    w('\tth.vse.v\t%s, (a0)\n\taddi\t\ta0, a0, 16'%EB(s))
w('''	ret
	.size	r72_rvv12_kernel, .-r72_rvv12_kernel
''')
open('r72-rvv-12.S','w').write('\n'.join(out))
