#ifndef _MEMORY_H_
#define _MEMORY_H_ 1

#include "types.h"

struct e820_entry
{
	u32 BaseAddrLow;
	u32 BaseAddrHi;
	u32 LengthLow;
	u32 LengthHi;
	u32 Type;
}; // Address Range Descriptor Structure

#define MEM_PHY_MIN 0x00100000 // 1-Mbyte
#define MEM_PHY_MAX 0xFFFFFFFF // 4-Gbyte
// #define MEM_PHY_DMA_MIN		0x00100000
// #define MEM_PHY_NORMAL_MIN	0x00100000
#define MEM_IDX_BASE 256 // MEM_PHY_MIN / PAGE_SIZE

enum phy_mem_type
{
	dma_phy_mem,
	normal_phy_mem
};

void mem_dumpinfo(void);

void mem_setup(const struct e820_entry *ards_buf);
// bool valid_mem(u32 paddr, u32 size);
u32 alloc_phy_mem(u32 count, u32 *allocated, enum phy_mem_type type);
void free_phy_mem(u32 paddr, u32 count);

#endif
