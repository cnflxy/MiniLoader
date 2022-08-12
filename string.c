#include "string.h"

void memcpy(volatile void *dst, const volatile void *src, u32 size)
{
#if 1
    __asm__ volatile("cld\n\t"
                     "rep movsb\n"
                     : "+D"(dst)
                     : "S"(src), "c"(size)
                     : "memory");
#else
    __asm__ volatile("movl %2, %%ecx\n\t"
                     "rep movsl\n\t"
                     "movl %3, %%ecx\n\t"
                     "rep movsb\n"
                     : "+D"(dst)
                     : "S"(src), "r"(size / 4), "r"(size % 4)
                     : "memory");
#endif
}

void memset(volatile void *dst, u8 value, u32 size)
{
    __asm__ volatile("cld\n\t"
                     "rep stosb\n"
                     : "+D"(dst)
                     : "a"(value), "c"(size)
                     : "memory");
}

int memcmp(const volatile void *src1, const volatile void *src2, u32 size)
{
    u32 remain = size;
    __asm__ volatile("cld\n\t"
                     "repe cmpsb\n"
                     : "+c"(remain)
                     : "D"(src1), "S"(src2)
                     : "memory");
    return remain ? ((char *)src1)[size - remain] - ((char *)src2)[size - remain] : 0;
}

void itoa(s32 value, char *volatile dst, int base)
{
    u32 num;
    char translate_table[] = {"0123456789abcdef"};
    u8 index_seq[32], index_count = 0;

    if (value < 0 && base == 10)
    {
        num = -value;
        *dst++ = '-';
    }
    else
        num = value;

    do
    {
        index_seq[index_count++] = num % base;
        num /= base;
    } while (num);

    while (index_count--)
    {
        *dst++ = translate_table[index_seq[index_count]];
    }
    *dst = 0;
}

void strcpy(char *volatile dst, const char *volatile src)
{
    while (*src)
        *dst++ = *src++;
}

u32 strlen(const char *volatile s)
{
    u32 len = 0;
    while (*s++)
        ++len;
    return len;
}

void vsprintf(char *buf, const char *fmt, va_list args)
{
    char str_tmp[32 + 1];
    u32 s_len;

    while (*fmt != '\0')
    {
        if (*fmt == '%')
        {
            ++fmt;
            switch (*fmt)
            {
            case 'c':
                *buf++ = (char)va_arg(args, int);
                break;
            case 's':
            {
                char *s_ptr = va_arg(args, char *);
                // strcpy(buf, s_ptr);
                s_len = strlen(s_ptr);
                memcpy(buf, s_ptr, s_len);
                buf += s_len;
            }
            break;
            case 'o':
                itoa(va_arg(args, s32), str_tmp, 8);
                s_len = strlen(str_tmp);
                memcpy(buf, str_tmp, s_len);
                buf += s_len;
                break;
            case 'd':
                itoa(va_arg(args, s32), str_tmp, 10);
                s_len = strlen(str_tmp);
                memcpy(buf, str_tmp, s_len);
                buf += s_len;
                break;
            case 'x':
                itoa(va_arg(args, s32), str_tmp, 16);
                s_len = strlen(str_tmp);
                memcpy(buf, str_tmp, s_len);
                buf += s_len;
                break;
            default:
                *buf++ = '%';
                if (*fmt != '%')
                    *buf++ = *fmt;
                break;
            }
            ++fmt;
            continue;
        }

        *buf++ = *fmt++;
    }
    *buf = 0;
}

void sprintf(char *buf, const char *fmt, ...)
{
    va_list arg;

    va_start(arg, fmt);
    vsprintf(buf, fmt, arg);
    va_end(arg);
}
