/*
 * RC5-72 core for RISC-V with T-Head vector (RVV 0.7.1, e.g. Allwinner D1).
 * Four keys per call step, one key per 32-bit lane. Written with intrinsics.
 */
const char *r72rvv4_cpp(void) { return "@(#)$Id: r72-rvv-4.cpp $"; }

#include "ccoreio.h"

#if defined(__riscv_xtheadvector)
#include <riscv_vector.h>

#define P 0xB7E15163
#define Q 0x9E3779B9

extern "C" s32 CDECL rc5_72_unit_func_rvv_4 ( RC5_72UnitWork *, u32 *, void * );

#define VL 4
#define ROTL(x,a)  __riscv_vor_vv_u32m1(__riscv_vsll_vv_u32m1((x),(a),VL), \
                     __riscv_vsrl_vv_u32m1((x),__riscv_vrsub_vx_u32m1((a),0,VL),VL),VL)
#define ROTL3(x)   __riscv_vor_vv_u32m1(__riscv_vsll_vx_u32m1((x),3,VL), \
                     __riscv_vsrl_vx_u32m1((x),29,VL),VL)
#define ADD(a,b)   __riscv_vadd_vv_u32m1((a),(b),VL)
#define XOR(a,b)   __riscv_vxor_vv_u32m1((a),(b),VL)
#define SPLAT(x)   __riscv_vmv_v_x_u32m1((x),VL)
#define vle(p)     __riscv_vle32_v_u32m1((p),VL)
#define vse(p,v)   __riscv_vse32_v_u32m1((p),(v),VL)

s32 CDECL rc5_72_unit_func_rvv_4 (RC5_72UnitWork *rc5_72unitwork, u32 *iterations, void * /*memblk*/)
{
  static const u32 lane[4] = { 0, 1, 2, 3 };
  vuint32m1_t L0, L1, L2, A, B, X, Sold, Snew, Sprev;
  u32 Sm[26][4] __attribute__((aligned(16)));
  u32 res[8];
  u32 kiter = *iterations/4;
  while (kiter--)
  {
    L2 = ADD(SPLAT(rc5_72unitwork->L0.hi), __riscv_vle32_v_u32m1(lane,VL));
    L1 = SPLAT(rc5_72unitwork->L0.mid);
    L0 = SPLAT(rc5_72unitwork->L0.lo);

    Snew = ROTL3(SPLAT(P));
    vse(Sm[0],Snew);
    X = ADD(L0,Snew); L0 = ROTL(X,Snew); Sprev = Snew;
    Sold = SPLAT(P + 1*Q);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[1],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = SPLAT(P + 2*Q);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[2],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = SPLAT(P + 3*Q);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[3],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = SPLAT(P + 4*Q);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[4],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = SPLAT(P + 5*Q);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[5],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = SPLAT(P + 6*Q);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[6],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = SPLAT(P + 7*Q);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[7],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = SPLAT(P + 8*Q);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[8],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = SPLAT(P + 9*Q);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[9],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = SPLAT(P + 10*Q);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[10],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = SPLAT(P + 11*Q);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[11],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = SPLAT(P + 12*Q);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[12],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = SPLAT(P + 13*Q);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[13],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = SPLAT(P + 14*Q);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[14],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = SPLAT(P + 15*Q);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[15],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = SPLAT(P + 16*Q);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[16],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = SPLAT(P + 17*Q);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[17],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = SPLAT(P + 18*Q);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[18],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = SPLAT(P + 19*Q);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[19],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = SPLAT(P + 20*Q);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[20],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = SPLAT(P + 21*Q);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[21],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = SPLAT(P + 22*Q);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[22],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = SPLAT(P + 23*Q);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[23],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = SPLAT(P + 24*Q);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[24],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = SPLAT(P + 25*Q);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[25],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[0]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[0],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[1]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[1],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[2]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[2],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[3]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[3],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[4]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[4],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[5]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[5],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[6]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[6],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[7]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[7],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[8]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[8],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[9]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[9],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[10]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[10],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[11]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[11],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[12]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[12],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[13]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[13],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[14]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[14],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[15]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[15],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[16]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[16],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[17]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[17],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[18]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[18],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[19]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[19],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[20]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[20],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[21]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[21],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[22]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[22],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[23]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[23],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[24]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[24],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[25]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[25],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[0]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[0],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[1]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[1],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[2]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[2],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[3]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[3],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[4]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[4],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[5]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[5],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[6]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[6],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[7]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[7],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[8]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[8],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[9]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[9],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[10]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[10],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[11]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[11],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[12]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[12],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[13]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[13],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[14]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[14],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[15]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[15],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[16]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[16],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[17]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[17],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[18]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[18],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[19]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[19],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[20]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[20],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[21]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[21],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[22]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[22],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;
    Sold = vle(Sm[23]);
    X = ADD(Sold,ADD(Sprev,L2)); Snew = ROTL3(X);
    vse(Sm[23],Snew);
    X = ADD(Snew,L2); L0 = ROTL(ADD(L0,X),X); Sprev = Snew;
    Sold = vle(Sm[24]);
    X = ADD(Sold,ADD(Sprev,L0)); Snew = ROTL3(X);
    vse(Sm[24],Snew);
    X = ADD(Snew,L0); L1 = ROTL(ADD(L1,X),X); Sprev = Snew;
    Sold = vle(Sm[25]);
    X = ADD(Sold,ADD(Sprev,L1)); Snew = ROTL3(X);
    vse(Sm[25],Snew);
    X = ADD(Snew,L1); L2 = ROTL(ADD(L2,X),X); Sprev = Snew;

    A = __riscv_vadd_vx_u32m1(vle(Sm[0]),rc5_72unitwork->plain.lo,VL);
    B = __riscv_vadd_vx_u32m1(vle(Sm[1]),rc5_72unitwork->plain.hi,VL);

    A = ADD(ROTL(XOR(A,B),B),vle(Sm[2]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[3]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[4]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[5]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[6]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[7]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[8]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[9]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[10]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[11]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[12]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[13]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[14]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[15]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[16]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[17]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[18]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[19]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[20]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[21]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[22]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[23]));
    A = ADD(ROTL(XOR(A,B),B),vle(Sm[24]));
    B = ADD(ROTL(XOR(B,A),A),vle(Sm[25]));

    __riscv_vse32_v_u32m1(res,A,VL);
    __riscv_vse32_v_u32m1(res+4,B,VL);
    for (int k = 0; k < 4; k++)
    {
      if (res[k] == rc5_72unitwork->cypher.lo)
      {
        ++rc5_72unitwork->check.count;
        rc5_72unitwork->check.hi  = rc5_72unitwork->L0.hi + k;
        rc5_72unitwork->check.mid = rc5_72unitwork->L0.mid;
        rc5_72unitwork->check.lo  = rc5_72unitwork->L0.lo;
        if (res[4+k] == rc5_72unitwork->cypher.hi)
        {
          *iterations -= (kiter + 1)*4 - k;
          return RESULT_FOUND;
        }
      }
    }

    #define key rc5_72unitwork->L0
    key.hi = (key.hi + 0x04) & 0x000000FF;
    if (!key.hi)
    {
      key.mid = key.mid + 0x01000000;
      if (!(key.mid & 0xFF000000u))
      {
        key.mid = (key.mid + 0x00010000) & 0x00FFFFFF;
        if (!(key.mid & 0x00FF0000))
        {
          key.mid = (key.mid + 0x00000100) & 0x0000FFFF;
          if (!(key.mid & 0x0000FF00))
          {
            key.mid = (key.mid + 0x00000001) & 0x000000FF;
            if (!key.mid)
            {
              key.lo = key.lo + 0x01000000;
              if (!(key.lo & 0xFF000000u))
              {
                key.lo = (key.lo + 0x00010000) & 0x00FFFFFF;
                if (!(key.lo & 0x00FF0000))
                {
                  key.lo = (key.lo + 0x00000100) & 0x0000FFFF;
                  if (!(key.lo & 0x0000FF00))
                  {
                    key.lo = (key.lo + 0x00000001) & 0x000000FF;
                  }
                }
              }
            }
          }
        }
      }
    }
    #undef key
  }
  return RESULT_NOTHING;
}
#endif
