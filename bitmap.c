#include "bitmap.h"
#include "string.h"

#define BITS_WITDH  32
#define BITS_MASK   0x1f
#define BITS_SHIFT  5

static u32 get_set_count(u8 *byte, u32 size)
{
    u32 count = 0;
    for (u32 i = 0; i < size; ++i)
    {
        u8 data = byte[i];
        while (data)
        {
            ++count;
            data &= data - 1;
        }
    }
    return count;
}

void bitmap_init(struct bitmap *map, void *buf, u32 buf_size)
{
    map->data = buf;
    map->size = buf_size * 8;
    map->first_clear = 0;
    map->clear_count = map->size;
    memset(buf, 0, buf_size);
}

void bitmap_set(struct bitmap *map, u32 idx, u32 count)
{
    if (idx >= map->size)
        return;
    if (idx < map->first_clear)
    {
        if (count <= map->first_clear - idx)
            return;
        count -= map->first_clear - idx;
        idx = map->first_clear;
    }
    if (count > map->size)
        count = map->size;
    if (idx + count > map->size)
        count = map->size - idx;
    if (!count)
        return;

    if (idx == map->first_clear)
    {
        map->first_clear += count;
    }

    u32 offset = idx >> BITS_SHIFT;
    idx &= BITS_MASK;

    if (idx)
    {
        u8 shift = 0;
        if (count < 8 - idx)
        {
            shift = 8 - idx - count;
            count = 0;
        }
        else
            count -= 8 - idx;
        if (map->data[offset] != 0xff)
        {
            u8 old = get_set_count(&map->data[offset], 1);
            map->data[offset] |= 0xff >> shift & 0xff << idx;
            map->clear_count -= get_set_count(&map->data[offset++], 1) - old;
        }
    }

    if (count & 0xfffffff8)
    { // count >= 8
        u32 size = count >> BITS_SHIFT;
        u32 need_set = (size << BITS_SHIFT) - get_set_count(&map->data[offset], size);
        if (need_set)
        {
            map->clear_count -= need_set;
            memset(&map->data[offset], 0xff, size);
        }
        offset += size;
        count &= 7;
    }

    if (count)
    {
        if (map->data[offset] != 0xff)
        {
            u8 old = get_set_count(&map->data[offset], 1);
            map->data[offset] |= ~(0xff << count);
            map->clear_count -= get_set_count(&map->data[offset], 1) - old;
        }
    }
}

void bitmap_clear(struct bitmap *map, u32 idx, u32 count)
{
    if (idx >= map->size)
        return;
    if (idx == map->first_clear)
    {
        idx = map->first_clear + 1;
        --count;
    }
    if (count > map->size)
        count = map->size;
    if (idx + count > map->size)
        count = map->size - idx;
    if (!count)
        return;

    if (idx < map->first_clear)
        map->first_clear = idx;

    u32 offset = idx >> BITS_SHIFT;
    idx &= 7;

    if (idx)
    {
        u8 shift = 0;
        if (count < 8 - idx)
        {
            shift = 8 - idx - count;
            count = 0;
        }
        else
            count -= 8 - idx;
        if (map->data[offset] != 0)
        {
            u8 old = get_set_count(&map->data[offset], 1);
            map->data[offset] &= ~(0xff >> shift & 0xff << idx);
            map->clear_count += old - get_set_count(&map->data[offset++], 1);
        }
    }

    if (count & 0xfffffff8)
    { // count >= 8
        u32 size = count >> BITS_SHIFT;
        u32 need_clear = get_set_count(&map->data[offset], size);
        if (need_clear)
        {
            map->clear_count += need_clear;
            memset(&map->data[offset], 0, size);
        }
        offset += size;
        count &= 7;
    }

    if (count)
    {
        if (map->data[offset] != 0)
        {
            u8 old = get_set_count(&map->data[offset], 1);
            map->data[offset] &= 0xff << count;
            map->clear_count += old - get_set_count(&map->data[offset++], 1);
        }
    }
}

bool bitmap_test(const struct bitmap *map, u32 idx)
{
    if (idx < map->first_clear || idx >= map->size)
        return true;
    else if (idx == map->first_clear)
        return false;
    u32 offset = idx >> BITS_SHIFT;
    idx &= 7;
    return map->data[offset] & (1 << idx);
}

u32 bitmap_size(const struct bitmap *map)
{
    return map->size;
}

u32 bitmap_clear_count(const struct bitmap *map)
{
    return map->clear_count;
}

u32 bitmap_find_clear(const struct bitmap *map, u32 idx)
{
    if (idx >= map->size || map->clear_count == 0)
        return -1;
    if (idx <= map->first_clear)
        return map->first_clear;

    u32 offset = idx >> BITS_SHIFT;
    u32 i = idx & 7;

    // while(idx < map->size && map->data[offset] == 0xff) {
    //     ++offset;
    //     idx += 8;
    // }
    for (; idx < map->size && (map->data[offset] & (1 << i)); ++idx)
    {
        if (++i == 8)
        {
            ++offset;
            i = 0;
        }
    }

    if (idx == map->size)
        return -1;
    return idx;
}

u32 bitmap_find_set(const struct bitmap *map, u32 idx)
{
    if (idx < map->first_clear)
        return idx;
    else if (idx >= map->size)
        return -1;

    u32 offset = idx >> BITS_SHIFT;
    u32 i = idx & 7;

    for (; idx < map->size && (map->data[offset] & (1 << i)) == 0; ++idx)
    {
        if (++i == 8)
        {
            ++offset;
            i = 0;
        }
    }

    if (idx == map->size)
        return -1;
    return idx;
}
