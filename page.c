#include "page.h"
#include "cpu.h"
#include "console.h"
// #include "bitmap.h"
#include "string.h"

// 32-Bit Paging (10-10-12 Paging Mode)
/*
0x1000 - 0x1FFF: 1024 32-Bit PDEs - each PDE controls access to a 4-Mbyte region of the linear-address space
0x2000 - 0x2FFF: PDE[0] - 1024 32-Bit PTEs - First 4-Mbyte region of the linear-address space
0x3000 - 0x3FFF: PDE[1] - 1024 32-Bit PTEs - Second 4-Mbyte region of the linear-address space
0x4000 - 0x4FFF: PDE[2]
0x5000 - 0x5FFF: PDE[3]
0x6000 - 0x6FFF: PDE[4]
0x7000 - 0x7FFF: PDE[5]
0x8000 - 0x8FFF: PDE[6]
0x9000 - 0x9FFF: PDE[7]
0xA000 - 0xAFFF: PDE[8]
0xB000 - 0xBFFF: PDE[9]
0xC000 - 0xCFFF: PDE[10]
0xD000 - 0xDFFF: PDE[11]
0xE000 - 0xEFFF: PDE[12]
0xF000 - 0xFFFF: PDE[13] - 52-Mbyte to 56-Mbyte
*/

// static volatile u32 *_PDE = (u32 *)PAGING_PDE_PADDR; // 1024 32-Bit PDEs - each PDE controls access to a 4-Mbyte region of the linear-address space
// static volatile u32 *_PDE[1024]; // 1024 32-Bit PDEs - each PDE controls access to a 4-Mbyte region of the linear-address space
/*
    _PDE[0] - 1024 32-Bit PTEs - First 4-Mbyte region of the linear-address space
*/
static volatile u32 *_PDE;
// static volatile u32 *_PTE;
// static u32 _FirstFreePDE;
static volatile u32 _FirstFreePTE;

// static u8 _bitmap_buf[PAGING_PDE_NUM * 1024 - 256];
// static struct bitmap _PTE_bitmap;
// static u32 _MappedSize[PAGING_PDE_NUM * 1024 - 256];
// static u16 _MappedSize[PAGING_PDE_NUM * 1024 - 256];
static struct _paging_alloc_pte_range
{
    u32 start;
    u32 count;
} _MappedPTE[1024];
static u32 _MappedPTE_FirstFreeIdx = 0;
static u32 _MappedPTE_Used = 0;

static const char *const reason_P[] = {
    "0: The fault was caused by a non-present page.\n",
    "1: The fault was caused by a page-level protection violation.\n"};

static const char *const reason_WR[] = {
    "0: The access causing the fault was a read.\n",
    "1: The access causing the fault was a write.\n"};

static const char *const reason_US[] = {
    "0: A supervisor-mode access caused the fault.\n",
    "1: A user-mode access caused the fault.\n"};

static const char *const reason_RSVD[] = {
    "0: The fault was not caused by reserved bit violation.\n",
    "1: The fault was caused by a reserved bit set to 1 in some paging-structure entry.\n"};

static const char *const reason_ID[] = {
    "0: The fault was not caused by an instruction fetch.\n",
    "1: The fault was caused by an instruction fetch.\n"};

static const char *const reason_PK[] = {
    "0: The fault was not caused by protection keys.\n",
    "1: There was a protection-key violation.\n"};

static const char *const reason_SGX[] = {
    "0: The fault is not related to SGX.\n",
    "1: The fault resulted from violation of SGX-specific access-control requirements.\n"};

static void map_page(u32 pte_idx, u32 paddr, u32 count)
{
    u32 pde_idx = pte_idx >> 10;
    u32 *ptr_PTE = (u32 *)(_PDE[pde_idx] & ~PAGE_MASK);

    pte_idx &= 0x3ff;
    _PDE[pde_idx] = (_PDE[pde_idx] & ~PAGE_MASK) | PAGING_READ_WRITE | PAGING_PRESENT;

    while (count--)
    {
        if (!ptr_PTE)
        {
            printf("[MM] PDE[0x%x]==NULL at PTE[0x%x]\n", pde_idx, pte_idx & 0x3ff);
            return;
        }

        ptr_PTE[pte_idx++] = paddr | PAGING_READ_WRITE | PAGING_PRESENT;
        paddr += PAGE_SIZE;
        if (pte_idx == 1024)
        {
            pte_idx = 0;
            pde_idx++;
            ptr_PTE = (u32 *)(_PDE[pde_idx] & ~PAGE_MASK);
            _PDE[pde_idx] = (_PDE[pde_idx] & ~PAGE_MASK) | PAGING_READ_WRITE | PAGING_PRESENT;
        }
    }
}

static void unmap_page(u32 pte_idx, u32 count)
{
    u32 pde_idx = pte_idx >> 10;
    u32 *ptr_PTE = (u32 *)(_PDE[pde_idx] & ~PAGE_MASK);

    pte_idx &= 0x3ff;
    _PDE[pde_idx] = (_PDE[pde_idx] & ~PAGE_MASK) | PAGING_READ_WRITE | PAGING_PRESENT;

    while (count)
    {
        if (!ptr_PTE)
        {
            printf("[MM] PDE[0x%x]==NULL at PTE[0x%x]\n", pde_idx, pte_idx & 0x3ff);
            return;
        }

        ptr_PTE[pte_idx++] = paddr | PAGING_READ_WRITE | PAGING_PRESENT;
        paddr += PAGE_SIZE;
        if (pte_idx == 1024)
        {
            pte_idx = 0;
            pde_idx++;
            ptr_PTE = (u32 *)(_PDE[pde_idx] & ~PAGE_MASK);
            _PDE[pde_idx] = (_PDE[pde_idx] & ~PAGE_MASK) | PAGING_READ_WRITE | PAGING_PRESENT;
        }
    }

    memset(&_PTE[pte_idx], 0, count * 4);
    invlpg(pte_idx << 12, count);
}

static u32 alloc_pte(u32 count)
{
#if 0
    if (count > 0xffff)
    return -1;
#endif

    if (_MappedPTE_Used == 1024)
    {
        print_str("_MappedPTE_Used == 1024!!!\n");
        return -1;
    }

    for (u32 pte_idx = _FirstFreePTE; pte_idx < 1024 * 1024 - count;)
    {
        u32 i = 0;
        while (i < count && (_PTE[pte_idx + i] & PAGING_PRESENT) != PAGING_PRESENT)
            ++i;
        if (i == count)
        {
            if (_FirstFreePTE == pte_idx)
                _FirstFreePTE += count;
            _MappedPTE[_MappedPTE_FirstFreeIdx].start = pte_idx;
            _MappedPTE[_MappedPTE_FirstFreeIdx].count = count;
            // ++_MappedPTE_FirstFreeIdx;
            while (_MappedPTE[++_MappedPTE_FirstFreeIdx].count)
                ;
            // ++_MappedPTE_Size;
            ++_MappedPTE_Used;
            return pte_idx;
        }
        pte_idx += i;
        while (pte_idx < 1024 * 1024 - count && (_PTE[++pte_idx] & PAGING_PRESENT) == PAGING_PRESENT)
            ;
    }

    return -1;

#if 0
    for (u32 pte_idx = _FirstFreePDE * 1024 + _FirstFreePTE; pte_idx < PAGING_PDE_NUM * 1024 - count;)
    {
        if (_MappedSize[pte_idx - 256])
        {
            pte_idx += _MappedSize[pte_idx - 256];
        }
        else
        {
            bool ok = true;
            for (u32 j = 1; j < count; ++j)
            {
                if (_MappedSize[pte_idx - 256 + j])
                {
                    pte_idx += j + _MappedSize[pte_idx - 256 + j];
                    ok = false;
                    break;
                }
            }

            if (ok)
            {
                if (pte_idx == _FirstFreePTE)
                {
                    _FirstFreePTE += count;
                }
                _MappedSize[pte_idx - 256] = count;
                return pte_idx;
            }
        }
    }

    return -1;
#endif
}

static u32 free_pte(u32 pte_idx)
{
#if 0
    if (pte_idx < 256 || pte_idx >= PAGING_PDE_NUM * 1024)
    {
        return;
    }
    
    if (_MappedSize[pte_idx - 256] == 0)
        return;
#endif

    u32 i = 0, n = _MappedPTE_Used;
    while (n && i < 1024)
    {
        if (_MappedPTE[i].count)
        {
            --n;
            if (_MappedPTE[i].start == pte_idx)
            {
                break;
            }
        }
        ++i;
    }
    if (n == 0 && _MappedPTE[i].count == 0)
    {
        printf("can't find the pte_idx(%d) mapped!(%d)\n", pte_idx, i);
        return 0;
    }

    u32 ret = _MappedPTE[i].count;
    _MappedPTE[i].start = 0;
    _MappedPTE[i].count = 0;
    if (i < _MappedPTE_FirstFreeIdx)
        _MappedPTE_FirstFreeIdx = i;

    if (pte_idx < _FirstFreePTE)
        _FirstFreePTE = pte_idx;

    --_MappedPTE_Used;

    return ret;

#if 0
    memset(&_PTE[pte_idx], 0, _MappedSize[pte_idx - 256] * 4);
    invlpg(pte_idx << 12, _MappedSize[pte_idx - 256]);
    _MappedSize[pte_idx - 256] = 0;
    if (_FirstFreePTE > pte_idx)
        _FirstFreePTE = pte_idx;
#endif
}

void paging_setup(void)
{
    // bitmap_init(&_PTE_bitmap, _bitmap_buf, sizeof(_bitmap_buf));

    // _PDE = (u32*)alloc_phy_mem(1);

    // _FirstFreePDE = 0;
    // _FirstFreePTE = 256;

    // u32 paddr = alloc_phy_mem(1);
    // _PDE[0][0] = (u32 *)paddr;

    u32 allocated, paddr = 0;

    _PDE = (u32 *)alloc_phy_mem(1, &allocated, normal_phy_mem);

    _PDE[0] = alloc_phy_mem(1, &allocated, normal_phy_mem) | PAGING_READ_WRITE | PAGING_PRESENT;
    memset(_PDE + 1, 0, 4096 - 4);

    u32 *ptr_PTE = (u32 *)PAGING_PTE_PADDR;
    for (u32 i = 0; i < 256; ++i)
    { // Map 0-0x100000 to 0-0x100000 (first 1-Mbyte region)
        ptr_PTE[i] = paddr | PAGING_READ_WRITE | PAGING_PRESENT;
        paddr += PAGE_SIZE;
    }
    memset(ptr_PTE + 256, 0, 4096 - 1024);
    _FirstFreePTE = 256;

    u32 *ptr_PDE = (u32 *)PAGING_PDE_PADDR;
    for (u32 i = 0; i < 1024; ++i)
    {
        ptr_PDE[i] = paddr | PAGING_CACHE_DISABLE | PAGING_READ_WRITE | PAGING_PRESENT;
        paddr += PAGE_SIZE;
    }
    // _PDE[0] = paddr | PAGING_CACHE_DISABLE | PAGING_READ_WRITE | PAGING_PRESENT;
    // memset(_PDE + 1, 0, (1024 - 1) * 4);

    u32 *ptr_PTE = (u32 *)PAGING_PTE_PADDR;
    paddr = 0;
    for (u32 i = 0; i < _FirstFreePTE; ++i)
    { // Map 0-0x400000 to 0-0x400000 (first 1-Mbyte region)
        ptr_PTE[i] = paddr | PAGING_READ_WRITE | PAGING_PRESENT;
        paddr += PAGE_SIZE;
    }
    memset(ptr_PTE + _FirstFreePTE, 0, (1024 * 1024 - _FirstFreePTE) * 4);

    // _PDE[0] = map_mem(_PDE[0] & 0xFFFFF000, PAGE_SIZE) | PAGING_CACHE_DISABLE | PAGING_READ_WRITE | PAGING_PRESENT;

    u32 cr3 = PAGING_PDE_PADDR | PAGING_CACHE_DISABLE;
    // if((cr3 & ~(PAGE_SIZE - 1)) != cr3) {
    //     // console_set_color(COLOR_WHITE, COLOR_RED);
    // //     print_str("\n\nImpossible to initialize paging!!!");
    //     // disable();
    //     halt();
    // }

    write_cr3(cr3);
    write_cr0(read_cr0() | CR0_PG | CR0_WP); // Paging here!!!
}

void paging_dumpinfo(void)
{
    printf("\nPDE=0x%x, PTE=0x%x, FirstFreePTE=%d\n"
           "MappedPTE=0x%x, FirstFreeIdx=%d, Used=%d\n",
           PAGING_PDE_PADDR, PAGING_PTE_PADDR, _FirstFreePTE,
           _MappedPTE, _MappedPTE_FirstFreeIdx, _MappedPTE_Used);
}

void pagefault_exception_handler(const struct trap_frame *frame, u32 error_code)
{
    // console_clear_screen();
    console_set_color(COLOR_NORMAL_BG, COLOR_LIGHT_RED);
    printf("page fault exception\nerror_code: 0x%x\nreason info\nat: 0x%x\n", error_code, frame->cr2);
    printf("%s%s%s%s%s%s%s",
           reason_P[(error_code >> 0) & 1],
           reason_WR[(error_code >> 1) & 1],
           reason_US[(error_code >> 2) & 1],
           reason_RSVD[(error_code >> 3) & 1],
           reason_ID[(error_code >> 4) & 1],
           reason_PK[(error_code >> 5) & 1],
           reason_SGX[(error_code >> 15) & 1]);
}

void *alloc_page(u32 size, enum phy_mem_type type)
{
    u32 count = get_page_count(size);

    if (count == 0)
        return 0;
    u32 pte_idx = alloc_pte(count);
    if (pte_idx == (u32)-1)
    {
        print_str("alloc_kernel_pte failed!\n");
        return 0;
    }

    u32 paddr, allocated, idx = pte_idx;
    do
    {
        paddr = alloc_phy_mem(count, &allocated, type);
        if (paddr == 0)
        {
            free_page((void *)(pte_idx << 12));
            // free_pte(pte_idx);
            print_str("alloc_phy_mem failed!\n");
            return 0;
        }
        map_page(idx, paddr, allocated);
        idx += allocated;
        count -= allocated;
    } while (count);
    return (void *)(pte_idx << 12);
}

void free_page(const void *laddr)
{
    // laddr = laddr & ~(PAGE_SIZE - 1); // 向下取整
    // if (laddr >= PAGING_LADDR_MAXIMUN)
    // return;
    // if (laddr < PAGING_LADDR_MINIMUM)
    // return;

    u32 pte_idx = (u32)laddr >> 12;
    u32 count = free_pte(pte_idx);
    if (!count)
        return;

    u32 pre_paddr, cur_paddr = get_paddr(laddr);
    if (!cur_paddr)
        return;
    u32 free_page = 1;
    pre_paddr = cur_paddr;
    while (true)
    {
        if (free_page < count)
        {
            u32 tmp_paddr = cur_paddr;
            laddr = (u8 *)laddr + PAGE_SIZE;
            cur_paddr = get_paddr(laddr);
            if (cur_paddr && cur_paddr == tmp_paddr + PAGE_SIZE)
            {
                ++free_page;
                continue;
            }
        }

        unmap_page(pte_idx, free_page);
        free_phy_mem(pre_paddr, free_page);
        if (!cur_paddr)
            break;
        count -= free_page;
        if (!count)
            break;

        pre_paddr = cur_paddr;
        pte_idx += free_page;
        free_page = 1;
    }
}

void *map_mem(u32 paddr, u32 size)
{
    if (size == 0)
        return 0;
    u32 offset = paddr & (PAGE_SIZE - 1);
    paddr = paddr & ~(PAGE_SIZE - 1);                          // 向下取整
    size = (size + offset + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1); // 向上取整
    if (paddr + size <= paddr)
        return 0;
#if 0
#if 1
    if (paddr < PAGING_PTE_PADDR)
    {
        if (paddr + size > PAGING_PTE_PADDR)
            return 0;
        return paddr | offset;
    }
#else
    if (paddr < PAGING_PTE_PADDR && paddr + size > PAGING_PTE_PADDR && PAGING_PTE_PADDR - paddr <= offset)
        return 0;
#endif
#endif

    u32 count = get_page_count(size);
    u32 pte_idx = alloc_pte(count);
    if (pte_idx == (u32)-1)
        return 0;
    map_page(pte_idx, paddr, count);
    return (void *)((pte_idx << 12) | offset);
}

void unmap_mem(const void *laddr)
{
    // laddr = laddr & ~(PAGE_SIZE - 1); // 向下取整
    // if (laddr >= PAGING_LADDR_MAXIMUN)
    // return;
    if ((u32)laddr < PAGING_LADDR_MINIMUM)
        return;
    u32 pte_idx = (u32)laddr >> 12;
    u32 count = free_pte(pte_idx);
    unmap_page(pte_idx, count);
}

u32 get_paddr(const void *laddr)
{
    // laddr = laddr & ~(PAGE_SIZE - 1); // 向下取整
    if ((u32)laddr < PAGING_LADDR_MINIMUM)
        return 0;
    u32 pte_idx = (u32)laddr >> 12;
    if ((_PTE[pte_idx] & PAGING_PRESENT) != PAGING_PRESENT)
        return 0;
    u32 offset = (u32)laddr & (PAGE_SIZE - 1);
    u32 paddr = _PTE[pte_idx] & ~(PAGE_SIZE - 1);
    return paddr | offset;
}

u32 get_page_count(u32 size)
{
    return (size + PAGE_SIZE - 1) / PAGE_SIZE;
}

void invlpg(u32 laddr, u32 count)
{
    while (count--)
    {
        __asm__ volatile("invlpg (%0)"
                         :
                         : "r"(laddr)
                         :);
        laddr += PAGE_SIZE;
    }
}
