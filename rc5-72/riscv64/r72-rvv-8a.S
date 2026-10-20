/*
 * RC5-72 key schedule and encryption for eight keys at a time.
 * RISC-V with T-Head vector 0.7.1 (Allwinner D1, C906). Needs xtheadvector.
 *
 * void r72_rvv8_kernel(u32 *res, const u32 *args, u32 *scratch);
 *   args:    hi, mid, lo, plain.lo, plain.hi
 *   scratch: 26 * 32 bytes for S, 16 byte aligned
 *   res:     16 words. A of keys 0-7, then B of keys 0-7.
 *
 * One vector register group (LMUL 2) holds one 32 bit word of eight keys.
 */

#define P_CONST 0xB7E15163
#define Q_CONST 0x9E3779B9

/* vector register groups, LMUL 2 (even numbers) */
#define L0   v2
#define L1   v4
#define L2   v6
#define SA   v8
#define UL   v28
#define U    v12
#define X    v14
#define T    v16
#define T1   v18
#define T2   v20
#define NX   v22
#define EA   v24
#define EB   v26

/*
 * scalar registers
 * a0 res, a1 args, a2 scratch base, a3 S pointer
 * t3 = 3, t4 = 29, t5 = running P + i*Q, t6 = Q
 */

	.option arch, +xtheadvector
	.text
	.align 2

/*
 * One key schedule step. U already holds S[i] + S[i-1] (prepared by the
 * previous step). The step also prepares U for the next step, so that the
 * vector load and add are off the dependency chain.
 *
 * MODE 0: next S[i] is a constant (first round)
 *      1: like 0, last step of the first round. Next S[0] comes from memory.
 *      2: next S[i] is loaded from memory (a5)
 *      3: like 2, last step of the second round. Next S[0] is at the base.
 *      4: last step of the third round. No next step.
 */
	.macro STEP Lp, Lj, MODE
	th.vadd.vv	X, U, \Lp
	th.vsll.vx	T1, X, t3
	th.vsrl.vx	T2, X, t4
#ifndef EXP_NOLD
	.if \MODE == 1 || \MODE == 3
	th.vle.v	UL, (a2)
	.endif
	.if \MODE == 2
	th.vle.v	UL, (a5)
	.endif
#endif
	th.vadd.vv	SA, T1, T2
#ifndef EXP_NOST
	th.vse.v	SA, (a3)
#endif
	.if \MODE == 0
	th.vadd.vx	U, SA, t5
	addw		t5, t5, t6
	.endif
	.if \MODE >= 1 && \MODE <= 3
	th.vadd.vv	U, UL, SA
	.endif
	th.vadd.vv	X, SA, \Lp
	th.vadd.vv	T, \Lj, X
#ifndef EXP_NONEG
	th.vneg.v	NX, X
#endif
	th.vsll.vv	T1, T, X
	th.vsrl.vv	T2, T, NX
	th.vor.vv	\Lj, T1, T2
	.if \MODE == 1 || \MODE == 3
	mv		a3, a2
	addi		a5, a2, 32
	.else
	addi		a3, a3, 32
	addi		a5, a5, 32
	.endif
	.endm

/* six steps. The L registers rotate. */
	.macro STEP6 La, Lb, Lc, MODE
	STEP \La, \Lb, \MODE
	STEP \Lb, \Lc, \MODE
	STEP \Lc, \La, \MODE
	STEP \La, \Lb, \MODE
	STEP \Lb, \Lc, \MODE
	STEP \Lc, \La, \MODE
	.endm

/* one encryption half step: X = rotl(X ^ Y, Y) + S[next] */
	.macro ENC X1, Y1
	th.vle.v	T2, (a3)
	th.vxor.vv	T, \X1, \Y1
	th.vneg.v	NX, \Y1
	th.vsll.vv	T1, T, \Y1
	th.vsrl.vv	X, T, NX
	th.vor.vv	T1, T1, X
	th.vadd.vv	\X1, T1, T2
	addi		a3, a3, 32
	.endm

	.globl	r72_rvv8_kernel
	.type	r72_rvv8_kernel, @function
r72_rvv8_kernel:
	li		t0, 8
	th.vsetvli	zero, t0, e32, m2, d1

	lw		t0, 0(a1)		/* hi */
	lw		t1, 4(a1)		/* mid */
	lw		t2, 8(a1)		/* lo */
	li		t3, 3
	li		t4, 29
	li		t6, Q_CONST

	/* L[2] = hi + lane number, L[1] = mid, L[0] = lo */
	lla		a4, r72_rvv8_lanes
	th.vle.v	L2, (a4)
	th.vadd.vx	L2, L2, t0
	th.vmv.v.x	L1, t1
	th.vmv.v.x	L0, t2

	/* S[0] = rotl3(P). L[0] = rotl(L[0] + S[0], S[0]). */
	li		t5, (((P_CONST << 3) | (P_CONST >> 29)) & 0xFFFFFFFF)
	th.vmv.v.x	SA, t5
	th.vse.v	SA, (a2)
	addi		a3, a2, 32
	th.vadd.vv	T, L0, SA
	th.vneg.v	NX, SA
	th.vsll.vv	T1, T, SA
	th.vsrl.vv	T2, T, NX
	th.vor.vv	L0, T1, T2

	/* U for step 1 is S[0] + (P + Q). t5 is then P + 2Q. */
	li		t5, ((P_CONST + Q_CONST) & 0xFFFFFFFF)
	th.vadd.vx	U, SA, t5
	addw		t5, t5, t6

	/* first round, steps 1-25 */
	STEP6	L0, L1, L2, 0
	STEP6	L0, L1, L2, 0
	STEP6	L0, L1, L2, 0
	STEP6	L0, L1, L2, 0
	STEP	L0, L1, 1

	/* second round, steps 26-51 */
	STEP6	L1, L2, L0, 2
	STEP6	L1, L2, L0, 2
	STEP6	L1, L2, L0, 2
	STEP6	L1, L2, L0, 2
	STEP	L1, L2, 2
	STEP	L2, L0, 3

	/* third round, steps 52-77 */
	STEP6	L0, L1, L2, 2
	STEP6	L0, L1, L2, 2
	STEP6	L0, L1, L2, 2
	STEP6	L0, L1, L2, 2
	STEP	L0, L1, 2
	STEP	L1, L2, 4

#ifdef EXP_NOENC
	j		.Lexp_done
#endif
	/* encryption: A = plain.lo + S[0], B = plain.hi + S[1] */
	lw		t0, 12(a1)
	lw		t1, 16(a1)
	th.vle.v	EA, (a2)
	addi		a3, a2, 32
	th.vle.v	EB, (a3)
	th.vadd.vx	EA, EA, t0
	th.vadd.vx	EB, EB, t1
	addi		a3, a3, 32
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA
	ENC	EA, EB
	ENC	EB, EA

.Lexp_done:
	th.vse.v	EA, (a0)
	addi		a0, a0, 32
	th.vse.v	EB, (a0)
	ret
	.size	r72_rvv8_kernel, .-r72_rvv8_kernel

	.section .rodata
	.align 4
r72_rvv8_lanes:
	.word	0, 1, 2, 3, 4, 5, 6, 7
