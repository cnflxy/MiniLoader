#include "memory.h"
#include "bitmap.h"
#include "lib.h"
#include "page.h"
#include "console.h"

// const struct e820_entry *gk_e820_entry_ptr;

static u8 _bitmap_buf[131040]; // 1-Mbyte to 4-Gbyte - 4095 * 1024 * 1024 / 4096 / 8 = 8192
// static u8 _bitmap_buf[8192];
static struct bitmap _mem_bitmap;

void mem_dumpinfo(void)
{
    printf("\nbitmap_buf=0x%x, mem_bitmap=0x%x\n"
           "mem_bitmap.data=0x%x, size=%d, clear_count=%d\n",
           _bitmap_buf, &_mem_bitmap,
           _mem_bitmap.data, bitmap_size(&_mem_bitmap), bitmap_clear_count(&_mem_bitmap));
}

void mem_setup(const struct e820_entry *ards_buf)
{
    u32 last_end = MEM_PHY_MIN;

    bitmap_init(&_mem_bitmap, _bitmap_buf, sizeof(_bitmap_buf));

    for (const struct e820_entry *ptr = ards_buf; ptr->Type; ++ptr)
    {
        if (ptr->Type == 1)
        {
            u32 base, len;
            if (ptr->BaseAddrHi)
            {
                base = MEM_PHY_MAX;
                len = 0;
            }
            else if (ptr->LengthHi)
            {
                base = MEM_PHY_MIN;
                len = MEM_PHY_MAX - MEM_PHY_MIN;
            }
            else
            {
                base = (ptr->BaseAddrLow + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1); // 向上取整
                len = ptr->LengthLow & ~(PAGE_SIZE - 1);                      // 向下取整

                if (base <= MEM_PHY_MIN)
                {
                    if (len > MEM_PHY_MIN - base)
                    {
                        len -= MEM_PHY_MIN - base;
                        base = MEM_PHY_MIN;
                        if (len > MEM_PHY_MAX)
                            len = MEM_PHY_MAX;
                    }
                    else
                        continue;
                }
                else if (base >= MEM_PHY_MAX)
                {
                    base = MEM_PHY_MAX;
                    len = 0;
                }
                else if (len > MEM_PHY_MAX - base)
                {
                    len = MEM_PHY_MAX - base;
                }
            }

            if (last_end == base)
            {
                last_end += len;
            }
            else
            {
                // last_end 至 base 需要屏蔽
                u32 idx = last_end / PAGE_SIZE - 256, count = (base - last_end) / PAGE_SIZE;
                bitmap_set(&_mem_bitmap, idx, count);
                last_end = base + len;
            }

            if (last_end == MEM_PHY_MAX)
                break;
        }
    }

    if (last_end != MEM_PHY_MAX)
    {
        u32 idx = last_end / PAGE_SIZE - 256, count = (MEM_PHY_MAX - last_end) / PAGE_SIZE;
        bitmap_set(&_mem_bitmap, idx, count);
    }
}

// bool valid_mem(u32 paddr, u32 size)
// {
//     if(paddr + size <= paddr) return false;
//     for(const struct e820_entry *ptr = gk_e820_entry_ptr; ptr->Type; ++ptr) {
//         if(ptr->Type != 1) continue;
//         if(ptr->BaseAddrHi) continue;
//         if(paddr < ptr->BaseAddrLow) continue;
//         if(ptr->LengthHi) return true;
//         if(ptr->LengthLow - (paddr - ptr->BaseAddrLow) >= size) return true;
//     }
//     return false;
// }

u32 alloc_phy_mem(u32 count, u32 *allocated, enum phy_mem_type type)
{
    // u32 base = type == dma_phy_mem?MEM_PHY_DMA_MIN:MEM_PHY_NORMAL_MIN;
    // u32 clear_idx = type == dma_phy_mem ? 0 : 1024, set_idx;
    u32 clear_idx = 0, set_idx;

    do
    {
        if (bitmap_clear_count(&_mem_bitmap) < count)
            break;
        clear_idx = bitmap_find_clear(&_mem_bitmap, clear_idx);
        if (clear_idx == (u32)-1)
            break;
        set_idx = bitmap_find_set(&_mem_bitmap, clear_idx + 1);
        if (set_idx == (u32)-1)
            set_idx = bitmap_size(&_mem_bitmap);
        *allocated = MIN(set_idx - clear_idx, count);
        if (type == dma_phy_mem && *allocated != count)
            break;
        bitmap_set(&_mem_bitmap, clear_idx, *allocated);
        return MEM_PHY_MIN + PAGE_SIZE * clear_idx;
    } while (false);

    *allocated = 0;
    return 0;
}

void free_phy_mem(u32 paddr, u32 count)
{
#if 0
    if (paddr < MEM_PHY_MIN || paddr >= MEM_PHY_MAX)
        return;
    if (paddr + PAGE_SIZE * count > MEM_PHY_MAX)
        return;
    if (paddr < MEM_PHY_NORMAL_MIN && paddr + PAGE_SIZE * count > MEM_PHY_NORMAL_MIN)
        return;
#endif
    if (paddr < MEM_PHY_MIN)
    {
        printf("[MM] paddr (0x%x) less than MEM_PHY_MIN (0x%x)\n", paddr, MEM_PHY_MIN);
        return;
    }
    
    u32 idx = (paddr - MEM_PHY_MIN) / PAGE_SIZE;
    bitmap_clear(&_mem_bitmap, idx, count);
}
