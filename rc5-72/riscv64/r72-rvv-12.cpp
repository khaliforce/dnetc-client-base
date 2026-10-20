/*
 * RC5-72 core wrapper for the RISC-V vector assembly kernel (T-Head RVV 0.7.1).
 * The kernel computes twelve keys per call. This file builds the key table,
 * advances the key counter and checks the result.
 */
const char *r72rvv12_cpp(void) { return "@(#)$Id: r72-rvv-12.cpp $"; }

#include "ccoreio.h"

#if defined(__riscv_xtheadvector)

extern "C" void r72_rvv12_kernel(u32 *res, const u32 *args, u32 *scratch);
extern "C" s32 CDECL rc5_72_unit_func_rvv_12 ( RC5_72UnitWork *, u32 *, void * );

/* Carry into the next key bytes after the low key byte wrapped from 255 to 0. */
static void key_carry(u32 &mid, u32 &lo)
{
  mid = mid + 0x01000000;
  if (!(mid & 0xFF000000u))
  {
    mid = (mid + 0x00010000) & 0x00FFFFFF;
    if (!(mid & 0x00FF0000))
    {
      mid = (mid + 0x00000100) & 0x0000FFFF;
      if (!(mid & 0x0000FF00))
      {
        mid = (mid + 0x00000001) & 0x000000FF;
        if (!mid)
        {
          lo = lo + 0x01000000;
          if (!(lo & 0xFF000000u))
          {
            lo = (lo + 0x00010000) & 0x00FFFFFF;
            if (!(lo & 0x00FF0000))
            {
              lo = (lo + 0x00000100) & 0x0000FFFF;
              if (!(lo & 0x0000FF00))
              {
                lo = (lo + 0x00000001) & 0x000000FF;
              }
            }
          }
        }
      }
    }
  }
}

s32 CDECL rc5_72_unit_func_rvv_12 (RC5_72UnitWork *rc5_72unitwork, u32 *iterations, void * /*memblk*/)
{
  u32 scratch[3 * 26 * 4] __attribute__((aligned(16)));
  u32 res[24] __attribute__((aligned(16)));
  u32 args[40] __attribute__((aligned(16)));
  u32 *k2 = args, *k1 = args + 12, *k0 = args + 24;
  u32 kiter = *iterations/12;
  while (kiter--)
  {
    u32 hi = rc5_72unitwork->L0.hi, mid = rc5_72unitwork->L0.mid, lo = rc5_72unitwork->L0.lo;
    if (hi + 11 <= 255)
    {
      for (int k = 0; k < 12; k++) { k2[k] = hi + k; k1[k] = mid; k0[k] = lo; }
    }
    else
    {
      u32 h = hi, m = mid, l = lo;
      for (int k = 0; k < 12; k++)
      {
        k2[k] = h; k1[k] = m; k0[k] = l;
        h = (h + 1) & 0xFF;
        if (!h) key_carry(m, l);
      }
    }
    args[36] = rc5_72unitwork->plain.lo;
    args[37] = rc5_72unitwork->plain.hi;
    r72_rvv12_kernel(res, args, scratch);

    for (int k = 0; k < 12; k++)
    {
      if (res[k] == rc5_72unitwork->cypher.lo)
      {
        ++rc5_72unitwork->check.count;
        rc5_72unitwork->check.hi  = k2[k];
        rc5_72unitwork->check.mid = k1[k];
        rc5_72unitwork->check.lo  = k0[k];
        if (res[12 + k] == rc5_72unitwork->cypher.hi)
        {
          *iterations -= (kiter + 1)*12 - k;
          return RESULT_FOUND;
        }
      }
    }

    if (hi + 12 <= 255)
    {
      rc5_72unitwork->L0.hi = hi + 12;
    }
    else
    {
      rc5_72unitwork->L0.hi = (hi + 12) & 0xFF;
      key_carry(mid, lo);
      rc5_72unitwork->L0.mid = mid;
      rc5_72unitwork->L0.lo = lo;
    }
  }
  return RESULT_NOTHING;
}
#endif
