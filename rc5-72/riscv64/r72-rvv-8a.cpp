/*
 * RC5-72 core wrapper for the RISC-V vector assembly kernel (T-Head RVV 0.7.1).
 * The kernel computes eight keys per call. This file handles the key counter
 * and the result check.
 */
const char *r72rvv8a_cpp(void) { return "@(#)$Id: r72-rvv-8a.cpp $"; }

#include "ccoreio.h"

#if defined(__riscv_xtheadvector)

extern "C" void r72_rvv8_kernel(u32 *res, const u32 *args, u32 *scratch);
extern "C" s32 CDECL rc5_72_unit_func_rvv_8a ( RC5_72UnitWork *, u32 *, void * );

s32 CDECL rc5_72_unit_func_rvv_8a (RC5_72UnitWork *rc5_72unitwork, u32 *iterations, void * /*memblk*/)
{
  u32 scratch[26 * 8] __attribute__((aligned(16)));
  u32 res[16] __attribute__((aligned(16)));
  u32 args[5];
  u32 kiter = *iterations/8;
  while (kiter--)
  {
    args[0] = rc5_72unitwork->L0.hi;
    args[1] = rc5_72unitwork->L0.mid;
    args[2] = rc5_72unitwork->L0.lo;
    args[3] = rc5_72unitwork->plain.lo;
    args[4] = rc5_72unitwork->plain.hi;
    r72_rvv8_kernel(res, args, scratch);

    for (int k = 0; k < 8; k++)
    {
      if (res[k] == rc5_72unitwork->cypher.lo)
      {
        ++rc5_72unitwork->check.count;
        rc5_72unitwork->check.hi  = rc5_72unitwork->L0.hi + k;
        rc5_72unitwork->check.mid = rc5_72unitwork->L0.mid;
        rc5_72unitwork->check.lo  = rc5_72unitwork->L0.lo;
        if (res[8 + k] == rc5_72unitwork->cypher.hi)
        {
          *iterations -= (kiter + 1)*8 - k;
          return RESULT_FOUND;
        }
      }
    }

    #define key rc5_72unitwork->L0
    key.hi = (key.hi + 0x08) & 0x000000FF;
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
