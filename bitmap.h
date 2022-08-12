#ifndef _BITMAP_H_
#define _BITMAP_H_ 1

#include "types.h"

struct bitmap {
    u32 *data;
    u32 size;
    u32 first_clear;
    u32 clear_count;
};

void bitmap_init(struct bitmap *map, void *buf, u32 buf_size);
void bitmap_set(struct bitmap *map, u32 idx, u32 count);
void bitmap_clear(struct bitmap *map, u32 idx, u32 count);
bool bitmap_test(const struct bitmap *map, u32 idx);
u32 bitmap_size(const struct bitmap *map);
u32 bitmap_clear_count(const struct bitmap *map);
u32 bitmap_find_clear(const struct bitmap *map, u32 idx);
u32 bitmap_find_set(const struct bitmap *map, u32 idx);

#endif
