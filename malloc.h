#ifndef _MALLOC_H_
#define _MALLOC_H_ 1

#include "types.h"

struct malloc_t {
    u32 size;
};

void alloc_setup(void);
void *malloc(u32 size);
void free(void *ptr);

#endif
