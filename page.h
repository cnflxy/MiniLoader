#ifndef _PAGE_H_
#define _PAGE_H_ 1

#include "idt.h"
#include "memory.h"

// CR3 PDE PTE
#define PAGING_WRITE_BACK     0x00
#define PAGING_WRITE_THROUGH  0x08
#define PAGING_CACHE_DISABLE  0x10

// PDE PTE
#define PAGING_PRESENT        0x01
#define PAGING_READ_ONLY      0x00
#define PAGING_READ_WRITE     0x02
#define PAGING_KERNEL_ONLY    0x00
#define PAGING_KERNEL_USER    0x04
#define PAGING_ACCESSED       0x20

// PDE
#define PAGING_4MB_SIZE   0x80

// PTE
#define PAGING_DIRTY  0x40
#define PAGING_PAT    0x80
#define PAGING_GLOBAL 0x100

#define USER_SPACE_START_VA     0x00400000
#define USER_SPACE_END_VA       0x7FFF0000

#define KERNE_SPACE_START_VA    0x80000000
#define KERNE_SPACE_END_VA      0xFFFFFFFF

#define PAGE_SIZE 0x1000
#define PAGE_MASK 0x0fff

#define PAGING_PDE_PADDR        0x00004000
#define PAGING_PTE_PADDR        0x00100000

#define PAGING_LADDR_MINIMUM    0x00500000
#define PAGING_LADDR_MAXIMUN    0xFFFFFFFF

// #define PAGING_PDE_NUM 64

#define PAGEFAULT_INDEX 14

void paging_dumpinfo(void);

void pagefault_exception_handler(const struct trap_frame *frame, u32 error_code);

// void paging_setup(u32 LoaderBase, u32 LoaderSize);
void paging_setup(void);
void *alloc_page(u32 size, enum phy_mem_type type);
void free_page(const void* laddr);

// must use unmap_mem to release
void* map_mem(u32 paddr, u32 size);
void unmap_mem(const void* laddr);

u32 get_paddr(const void* laddr);
u32 get_page_count(u32 size);

void invlpg(u32 laddr, u32 count);

#endif

