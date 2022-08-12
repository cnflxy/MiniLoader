#ifndef _LIB_H_
#define _LIB_H_ 1

#include "types.h"

// typedef char *  va_list;

// #define _ADDRESSOF(v)   (&(v))
// #define _SLOTSIZEOF(t)  (sizeof(t))
// #define _APALIGN(t,ap)  (__alignof(t))
// #define _INTSIZEOF(n)   ((sizeof(n) + sizeof(int) - 1) & ~(sizeof(int) - 1))
// #define _va_start(v,l)	((void)((v) = (va_list)_ADDRESSOF(l) + _INTSIZEOF(l)))
// #define _va_arg(v,l)	(*(l *)(((v) += _INTSIZEOF(l)) - _INTSIZEOF(l)))
// #define _va_end(v)      ((void)((v) = (va_list)0))
// #define _va_copy(d,s)   ((void)((d) = (s)))

#define MAX(_a, _b) ((_a) > (_b) ? (_a) : (_b))
#define MIN(_a, _b) ((_a) < (_b) ? (_a) : (_b))

#define BCD2BIN(_bcd) ((((_bcd) >> 4) & 0xF) * 10 + ((_bcd) & 0xF))

void delay_ms(u32 ms);
u8 checksum_add(const void *p, u32 len);

#endif
