#ifndef _STRING_H_
#define _STRING_H_ 1

#include "types.h"
#include <stdarg.h>

void memcpy(volatile void *dst, const volatile void *src, u32 size);
void memset(volatile void *dst, u8 value, u32 size);
int memcmp(const volatile void *src1, const volatile void *src2, u32 size);
void itoa(s32 value, char * volatile dst, int base);
void strcpy(char * volatile dst, const char * volatile src);
u32 strlen(const char * volatile s);
void vsprintf(char *buf, const char *fmt, va_list args);
void sprintf(char *buf, const char *fmt, ...);

#endif
