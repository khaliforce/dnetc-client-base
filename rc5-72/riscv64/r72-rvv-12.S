/*
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

	th.vle.v	v3, (t0)
	addi		t0, t0, 16
	th.vle.v	v13, (t0)
	addi		t0, t0, 16
	th.vle.v	v23, (t0)
	addi		t0, t0, 16
	th.vle.v	v2, (t0)
	addi		t0, t0, 16
	th.vle.v	v12, (t0)
	addi		t0, t0, 16
	th.vle.v	v22, (t0)
	addi		t0, t0, 16
	th.vle.v	v1, (t0)
	addi		t0, t0, 16
	th.vle.v	v11, (t0)
	addi		t0, t0, 16
	th.vle.v	v21, (t0)
	addi		t0, t0, 16
	lw		t1, 144(a1)
	lw		t2, 148(a1)
	li		t5, (((P_CONST << 3) | (P_CONST >> 29)) & 0xFFFFFFFF)
	th.vmv.v.x	v4, t5
	th.vmv.v.x	v14, t5
	th.vmv.v.x	v24, t5
	th.vse.v	v4, (a2)
	th.vse.v	v14, (a6)
	th.vse.v	v24, (a7)
	addi		a3, a2, 16
	addi		a4, a6, 16
	addi		a5, a7, 16
	th.vadd.vv	v7, v1, v4
	th.vneg.v	v10, v4
	th.vadd.vv	v17, v11, v14
	th.vneg.v	v20, v14
	th.vadd.vv	v27, v21, v24
	th.vneg.v	v30, v24
	th.vsll.vv	v8, v7, v4
	th.vsrl.vv	v9, v7, v10
	th.vsll.vv	v18, v17, v14
	th.vsrl.vv	v19, v17, v20
	th.vsll.vv	v28, v27, v24
	th.vsrl.vv	v29, v27, v30
	th.vor.vv	v1, v8, v9
	th.vor.vv	v11, v18, v19
	th.vor.vv	v21, v28, v29
	li		t5, ((P_CONST + Q_CONST) & 0xFFFFFFFF)
	/* group 0 */
	th.vadd.vx	v5, v4, t5
	th.vadd.vv	v6, v5, v1
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	/* group 1 */
	th.vadd.vx	v15, v14, t5
	th.vadd.vv	v4, v8, v9
	th.vadd.vv	v16, v15, v11
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vsll.vx	v18, v16, t3
	th.vsrl.vx	v19, v16, t4
	th.vadd.vv	v7, v2, v6
	th.vneg.v	v10, v6
	/* group 2 */
	addi		a3, a3, 16
	th.vadd.vv	v14, v18, v19
	th.vsll.vv	v8, v7, v6
	th.vadd.vx	v25, v24, t5
	th.vsrl.vv	v9, v7, v10
	addw		t5, t5, t6
	th.vse.v	v14, (a4)
	th.vadd.vv	v16, v14, v11
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vneg.v	v20, v16
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	/* group 3 */
	th.vadd.vx	v5, v4, t5
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v2
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v22, v26
	th.vneg.v	v30, v26
	/* group 4 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vadd.vv	v16, v15, v12
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 5 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v22
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v13, v16
	th.vneg.v	v20, v16
	/* group 6 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v3
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v23, v26
	th.vneg.v	v30, v26
	/* group 7 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vadd.vv	v16, v15, v13
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 8 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v23
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v11, v16
	th.vneg.v	v20, v16
	/* group 9 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v1
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v21, v26
	th.vneg.v	v30, v26
	/* group 10 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vadd.vv	v16, v15, v11
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 11 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v21
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v12, v16
	th.vneg.v	v20, v16
	/* group 12 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v2
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v22, v26
	th.vneg.v	v30, v26
	/* group 13 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vadd.vv	v16, v15, v12
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 14 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v22
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v13, v16
	th.vneg.v	v20, v16
	/* group 15 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v3
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v23, v26
	th.vneg.v	v30, v26
	/* group 16 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vadd.vv	v16, v15, v13
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 17 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v23
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v11, v16
	th.vneg.v	v20, v16
	/* group 18 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v1
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v21, v26
	th.vneg.v	v30, v26
	/* group 19 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vadd.vv	v16, v15, v11
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 20 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v21
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v12, v16
	th.vneg.v	v20, v16
	/* group 21 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v2
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v22, v26
	th.vneg.v	v30, v26
	/* group 22 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vadd.vv	v16, v15, v12
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 23 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v22
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v13, v16
	th.vneg.v	v20, v16
	/* group 24 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v3
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v23, v26
	th.vneg.v	v30, v26
	/* group 25 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vadd.vv	v16, v15, v13
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 26 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v23
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v11, v16
	th.vneg.v	v20, v16
	/* group 27 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v1
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v21, v26
	th.vneg.v	v30, v26
	/* group 28 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vadd.vv	v16, v15, v11
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 29 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v21
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v12, v16
	th.vneg.v	v20, v16
	/* group 30 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v2
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v22, v26
	th.vneg.v	v30, v26
	/* group 31 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vadd.vv	v16, v15, v12
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 32 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v22
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v13, v16
	th.vneg.v	v20, v16
	/* group 33 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v3
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v23, v26
	th.vneg.v	v30, v26
	/* group 34 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vadd.vv	v16, v15, v13
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 35 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v23
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v11, v16
	th.vneg.v	v20, v16
	/* group 36 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v1
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v21, v26
	th.vneg.v	v30, v26
	/* group 37 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vadd.vv	v16, v15, v11
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 38 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v21
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v12, v16
	th.vneg.v	v20, v16
	/* group 39 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v2
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v22, v26
	th.vneg.v	v30, v26
	/* group 40 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vadd.vv	v16, v15, v12
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 41 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v22
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v13, v16
	th.vneg.v	v20, v16
	/* group 42 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v3
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v23, v26
	th.vneg.v	v30, v26
	/* group 43 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vadd.vv	v16, v15, v13
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 44 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v23
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v11, v16
	th.vneg.v	v20, v16
	/* group 45 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v1
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v21, v26
	th.vneg.v	v30, v26
	/* group 46 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vadd.vv	v16, v15, v11
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 47 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v21
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v12, v16
	th.vneg.v	v20, v16
	/* group 48 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v2
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v22, v26
	th.vneg.v	v30, v26
	/* group 49 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vadd.vv	v16, v15, v12
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 50 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v22
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v13, v16
	th.vneg.v	v20, v16
	/* group 51 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v3
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v23, v26
	th.vneg.v	v30, v26
	/* group 52 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vadd.vv	v16, v15, v13
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 53 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v23
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v11, v16
	th.vneg.v	v20, v16
	/* group 54 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v1
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v21, v26
	th.vneg.v	v30, v26
	/* group 55 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vadd.vv	v16, v15, v11
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 56 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v21
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v12, v16
	th.vneg.v	v20, v16
	/* group 57 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v2
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v22, v26
	th.vneg.v	v30, v26
	/* group 58 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vadd.vv	v16, v15, v12
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 59 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v22
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v13, v16
	th.vneg.v	v20, v16
	/* group 60 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v3
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v23, v26
	th.vneg.v	v30, v26
	/* group 61 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vadd.vv	v16, v15, v13
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 62 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v23
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v11, v16
	th.vneg.v	v20, v16
	/* group 63 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v1
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v21, v26
	th.vneg.v	v30, v26
	/* group 64 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vadd.vv	v16, v15, v11
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 65 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v21
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v12, v16
	th.vneg.v	v20, v16
	/* group 66 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v2
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v22, v26
	th.vneg.v	v30, v26
	/* group 67 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vadd.vv	v16, v15, v12
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 68 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v22
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v13, v16
	th.vneg.v	v20, v16
	/* group 69 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v3
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v23, v26
	th.vneg.v	v30, v26
	/* group 70 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vadd.vv	v16, v15, v13
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 71 */
	th.vadd.vx	v25, v24, t5
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v23
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v11, v16
	th.vneg.v	v20, v16
	/* group 72 */
	addi		a4, a4, 16
	th.vadd.vx	v5, v4, t5
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v6, v5, v1
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vsll.vx	v8, v6, t3
	th.vsrl.vx	v9, v6, t4
	th.vadd.vv	v27, v21, v26
	th.vneg.v	v30, v26
	/* group 73 */
	addi		a5, a5, 16
	th.vadd.vv	v4, v8, v9
	th.vsll.vv	v28, v27, v26
	th.vadd.vx	v15, v14, t5
	th.vsrl.vv	v29, v27, v30
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vadd.vv	v16, v15, v11
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 74 */
	th.vadd.vx	v25, v24, t5
	mv		a3, a2
	th.vsll.vv	v8, v7, v6
	addw		t5, t5, t6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v26, v25, v21
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vsll.vx	v28, v26, t3
	th.vsrl.vx	v29, v26, t4
	th.vadd.vv	v17, v12, v16
	th.vneg.v	v20, v16
	/* group 75 */
	th.vle.v	v5, (a3)
	mv		a4, a6
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vadd.vv	v26, v24, v21
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 76 */
	th.vle.v	v15, (a4)
	mv		a5, a7
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 77 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 78 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 79 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 80 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 81 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 82 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 83 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 84 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 85 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 86 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 87 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 88 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 89 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 90 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 91 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 92 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 93 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 94 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 95 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 96 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 97 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 98 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 99 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 100 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 101 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 102 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 103 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 104 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 105 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 106 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 107 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 108 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 109 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 110 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 111 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 112 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 113 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 114 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 115 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 116 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 117 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 118 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 119 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 120 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 121 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 122 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 123 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 124 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 125 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 126 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 127 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 128 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 129 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 130 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 131 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 132 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 133 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 134 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 135 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 136 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 137 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 138 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 139 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 140 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 141 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 142 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 143 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 144 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 145 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 146 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 147 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 148 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 149 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 150 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 151 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 152 */
	th.vle.v	v25, (a5)
	mv		a3, a2
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 153 */
	th.vle.v	v5, (a3)
	mv		a4, a6
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 154 */
	th.vle.v	v15, (a4)
	mv		a5, a7
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 155 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 156 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 157 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 158 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 159 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 160 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 161 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 162 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 163 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 164 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 165 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 166 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 167 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 168 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 169 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 170 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 171 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 172 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 173 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 174 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 175 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 176 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 177 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 178 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 179 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 180 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 181 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 182 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 183 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 184 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 185 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 186 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 187 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 188 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 189 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 190 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 191 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 192 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 193 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 194 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 195 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 196 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 197 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 198 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 199 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 200 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 201 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 202 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 203 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 204 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 205 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 206 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 207 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 208 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 209 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 210 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 211 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 212 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 213 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 214 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 215 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 216 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 217 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 218 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 219 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 220 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 221 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 222 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v13, v18, v19
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v6, v5, v3
	th.vadd.vv	v27, v23, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 223 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v3
	th.vor.vv	v23, v28, v29
	th.vadd.vv	v16, v15, v13
	th.vadd.vv	v7, v1, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 224 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v1, v8, v9
	th.vadd.vv	v16, v14, v13
	th.vadd.vv	v26, v25, v23
	th.vadd.vv	v17, v11, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 225 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v11, v18, v19
	th.vadd.vv	v26, v24, v23
	th.vadd.vv	v6, v5, v1
	th.vadd.vv	v27, v21, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 226 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v1
	th.vor.vv	v21, v28, v29
	th.vadd.vv	v16, v15, v11
	th.vadd.vv	v7, v2, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 227 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v2, v8, v9
	th.vadd.vv	v16, v14, v11
	th.vadd.vv	v26, v25, v21
	th.vadd.vv	v17, v12, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 228 */
	th.vle.v	v5, (a3)
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vadd.vv	v24, v28, v29
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v5, v5, v4
	th.vse.v	v24, (a5)
	th.vor.vv	v12, v18, v19
	th.vadd.vv	v26, v24, v21
	th.vadd.vv	v6, v5, v2
	th.vadd.vv	v27, v22, v26
	th.vsll.vx	v8, v6, t3
	th.vneg.v	v30, v26
	th.vsrl.vx	v9, v6, t4
	/* group 229 */
	th.vle.v	v15, (a4)
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vadd.vv	v4, v8, v9
	th.vsrl.vv	v29, v27, v30
	th.vadd.vv	v15, v15, v14
	th.vse.v	v4, (a3)
	th.vadd.vv	v6, v4, v2
	th.vor.vv	v22, v28, v29
	th.vadd.vv	v16, v15, v12
	th.vadd.vv	v7, v3, v6
	th.vsll.vx	v18, v16, t3
	th.vneg.v	v10, v6
	th.vsrl.vx	v19, v16, t4
	/* group 230 */
	th.vle.v	v25, (a5)
	addi		a3, a3, 16
	th.vsll.vv	v8, v7, v6
	th.vadd.vv	v14, v18, v19
	th.vsrl.vv	v9, v7, v10
	th.vadd.vv	v25, v25, v24
	th.vse.v	v14, (a4)
	th.vor.vv	v3, v8, v9
	th.vadd.vv	v16, v14, v12
	th.vadd.vv	v26, v25, v22
	th.vadd.vv	v17, v13, v16
	th.vsll.vx	v28, v26, t3
	th.vneg.v	v20, v16
	th.vsrl.vx	v29, v26, t4
	/* group 231 */
	addi		a4, a4, 16
	th.vsll.vv	v18, v17, v16
	th.vsrl.vv	v19, v17, v20
	th.vadd.vv	v24, v28, v29
	th.vor.vv	v13, v18, v19
	th.vse.v	v24, (a5)
	th.vadd.vv	v26, v24, v22
	th.vadd.vv	v27, v23, v26
	th.vneg.v	v30, v26
	/* group 232 */
	addi		a5, a5, 16
	th.vsll.vv	v28, v27, v26
	th.vsrl.vv	v29, v27, v30
	th.vor.vv	v23, v28, v29
	/* encryption */
	mv		a3, a2
	mv		a4, a6
	mv		a5, a7
	th.vle.v	v1, (a3)
	addi		a3, a3, 16
	th.vle.v	v2, (a3)
	addi		a3, a3, 16
	th.vle.v	v11, (a4)
	addi		a4, a4, 16
	th.vle.v	v12, (a4)
	addi		a4, a4, 16
	th.vle.v	v21, (a5)
	addi		a5, a5, 16
	th.vle.v	v22, (a5)
	addi		a5, a5, 16
	th.vadd.vx	v1, v1, t1
	th.vadd.vx	v2, v2, t2
	th.vadd.vx	v11, v11, t1
	th.vadd.vx	v12, v12, t2
	th.vadd.vx	v21, v21, t1
	th.vadd.vx	v22, v22, t2
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v1, v2
	th.vxor.vv	v16, v11, v12
	th.vxor.vv	v26, v21, v22
	th.vneg.v	v10, v2
	th.vneg.v	v20, v12
	th.vneg.v	v30, v22
	th.vsll.vv	v8, v6, v2
	th.vsll.vv	v18, v16, v12
	th.vsll.vv	v28, v26, v22
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v1, v8, v5
	th.vadd.vv	v11, v18, v15
	th.vadd.vv	v21, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vle.v	v5, (a3)
	th.vle.v	v15, (a4)
	th.vle.v	v25, (a5)
	th.vxor.vv	v6, v2, v1
	th.vxor.vv	v16, v12, v11
	th.vxor.vv	v26, v22, v21
	th.vneg.v	v10, v1
	th.vneg.v	v20, v11
	th.vneg.v	v30, v21
	th.vsll.vv	v8, v6, v1
	th.vsll.vv	v18, v16, v11
	th.vsll.vv	v28, v26, v21
	th.vsrl.vv	v9, v6, v10
	th.vsrl.vv	v19, v16, v20
	th.vsrl.vv	v29, v26, v30
	th.vor.vv	v8, v8, v9
	th.vor.vv	v18, v18, v19
	th.vor.vv	v28, v28, v29
	th.vadd.vv	v2, v8, v5
	th.vadd.vv	v12, v18, v15
	th.vadd.vv	v22, v28, v25
	addi		a3, a3, 16
	addi		a4, a4, 16
	addi		a5, a5, 16
	th.vse.v	v1, (a0)
	addi		a0, a0, 16
	th.vse.v	v11, (a0)
	addi		a0, a0, 16
	th.vse.v	v21, (a0)
	addi		a0, a0, 16
	th.vse.v	v2, (a0)
	addi		a0, a0, 16
	th.vse.v	v12, (a0)
	addi		a0, a0, 16
	th.vse.v	v22, (a0)
	addi		a0, a0, 16
	ret
	.size	r72_rvv12_kernel, .-r72_rvv12_kernel
