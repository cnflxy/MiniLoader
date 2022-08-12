#include "types.h"
#include "dma.h"
#include "cpu.h"
#include "io.h"

// static u8 _old_mask;

/*
mask: bitmap[0...7]
*/

static void mask_channel(u8 channel, bool off)
{
	u16 port_smask = channel < 4 ? DMA_PORT_SMASK_MASTER : DMA_PORT_SMASK_SLAVE;
	// port_write_byte(DMA_PORT_MMASK_MASTER, (mask & _old_mask) & 0xF);
	// port_write_byte(DMA_PORT_MMASK_SLAVE, mask >> 4);
	port_write_byte(port_smask, (off << 2) | (channel & 0x3));
	// _old_mask = mask;
}

void dma_setup(void)
{
	// port_write_byte(DMA_PORT_MASTER_RESET_MASTER, 0xff);
	// port_write_byte(DMA_PORT_MASTER_RESET_SLAVE, 0xff);

	port_write_byte(DMA_PORT_MMASK_MASTER, 0xf);
	port_write_byte(DMA_PORT_MMASK_SLAVE, 0xe);

	// mask_channel(4, false);
	// port_write_byte(, 0);

	// _old_mask = 0xff;

	// port_write_byte(DMA_PORT_MODE_1, 0xc0);
	// port_write_byte(DMA_PORT_MASK_RESET_1, 0);
	// port_write_byte(DMA_PORT_MODE_2, 0xc0);
	// port_write_byte(DMA_PORT_MASK_RESET_2, 0);
}

bool dma_prepare(u8 channel, u32 paddr, u32 len, bool write)
{
	u16 port_ff_clear, port_mode, port_addr, port_count, port_page = 0;
	u16 count;
	u16 buf_offset;
	u8 page;

	if (channel == 0 || channel == 4 || channel > 7 || paddr + len > 16 * 1024 * 1024 || (paddr >> 16) != ((paddr + len) >> 16) || len > 64 * 1024)
	{
		return false;
	}

	page = paddr >> 16;
	buf_offset = paddr;
	if (channel < 4)
	{
		port_ff_clear = DMA_PORT_FF_CLEAR_MASTER;
		port_mode = DMA_PORT_MODE_MASTER;
		port_addr = DMA_PORT_ADDR_0 + (channel << 1);
		port_count = port_addr + 1;

		count = len;
	}
	else
	{
		port_ff_clear = DMA_PORT_FF_CLEAR_SLAVE;
		port_mode = DMA_PORT_MODE_SLAVE;
		port_addr = DMA_PORT_ADDR_4 + ((channel & 0x3) << 2);
		port_count = port_addr + 2;
		
		u16 tmp = page & 0x1;
		tmp <<= 15;
		buf_offset >>= 1;
		buf_offset &= 0x7fff;
		buf_offset |= tmp;
		count = len >> 1;
	}
	count -= 1;

	switch (channel)
	{
	case 1:
		port_page = DMA_PORT_PAGE_1;
		break;
	case 2:
		port_page = DMA_PORT_PAGE_2;
		break;
	case 3:
		port_page = DMA_PORT_PAGE_3;
		break;
	case 5:
		port_page = DMA_PORT_PAGE_5;
		break;
	case 6:
		port_page = DMA_PORT_PAGE_6;
		break;
	case 7:
		port_page = DMA_PORT_PAGE_7;
		break;
	}

	// port_page = port_page_list[channel];

	u8 transfer_mode = write ? 0x58 : 0x54; // Single, AI, Auto-Init

	mask_channel(channel, true);
	port_write_byte(port_ff_clear, 0);
	port_write_byte(port_mode, transfer_mode | (channel & 0x3));

	port_write_byte(port_count, count);
	port_write_byte(port_count, count >> 8);

	port_write_byte(port_page, page);
	port_write_byte(port_addr, buf_offset);
	port_write_byte(port_addr, buf_offset >> 8);	
	
	mask_channel(channel, false);

	return true;
}

// void dma_start(u8 channel, bool write)
// {
	
// 	mask_channel(channel, true);
	
// 	mask_channel(channel, false);
// }

void dma_release(u8 channel)
{
	mask_channel(channel, true);
}

/*
bool dma_floppy(u32 addr, u32 len, bool write)
{
	u8 mode = write? 0x4a: 0x46;
	u16 count = len - 1;

	port_write_byte(DMA_PORT_SINGLE_MASK_1, 0x4 | 2);
	port_write_byte(DMA_PORT_FF_CLEAR_1, 0);
	port_write_byte(DMA_PORT_ADDR_2, addr);
	port_write_byte(DMA_PORT_ADDR_2, addr >> 8);
	port_write_byte(DMA_PORT_FF_CLEAR_1, 0);
	port_write_byte(DMA_PORT_COUNT_2, count);
	port_write_byte(DMA_PORT_COUNT_2, count >> 8);

	port_write_byte(DMA_PORT_MODE_1, mode);

	port_write_byte(DMA_PORT_PAGE_2, addr >> 16);

	port_write_byte(DMA_PORT_SINGLE_MASK_1, 2);

	return 1;
}

bool dma_sb16(u32 addr, u32 len, bool write, u8 channel)
{
	u16 port_mask, port_ff_clear, port_mode;
	u16 port_addr, port_count, port_page;
	u8 mode = write ? 0x48 : 0x44;
	u16 count;

	if (channel < 4) {
		port_mask = DMA_PORT_SINGLE_MASK_1;
		port_ff_clear = DMA_PORT_FF_CLEAR_1;
		port_mode = DMA_PORT_MODE_1;
		port_addr = DMA_PORT_ADDR_0 + (channel << 1);
		port_count = port_addr + 1;
		count = len - 1;
	} else {
		port_mask = DMA_PORT_SINGLE_MASK_2;
		port_ff_clear = DMA_PORT_FF_CLEAR_2;
		port_mode = DMA_PORT_MODE_2;
		port_addr = DMA_PORT_ADDR_4 + ((channel - 4) << 2);
		port_count = port_addr + 2;
		count = (len - 2) / 2;
	}

	switch (channel) {
	case 0:
		port_page = DMA_PORT_PAGE_0;
		break;
	case 1:
		port_page = DMA_PORT_PAGE_1;
		break;
	case 2:
		port_page = DMA_PORT_PAGE_2;
		break;
	case 3:
		port_page = DMA_PORT_PAGE_3;
		break;
	case 4:
		port_page = DMA_PORT_PAGE_4;
		break;
	case 5:
		port_page = DMA_PORT_PAGE_5;
		break;
	case 6:
		port_page = DMA_PORT_PAGE_6;
		break;
	case 7:
		port_page = DMA_PORT_PAGE_7;
		break;
	default:
		return 0;
	}

	port_write_byte(port_mask, 0x4 | channel % 4);
	port_write_byte(port_ff_clear, 0);
	port_write_byte(port_addr, addr);
	port_write_byte(port_addr, addr >> 8);
	port_write_byte(port_ff_clear, 0);
	port_write_byte(port_count, count);
	port_write_byte(port_count, count >> 8);

	port_write_byte(port_mode, mode + channel % 4);

	port_write_byte(port_page, addr >> 16);

	port_write_byte(port_mask, channel % 4);

	return 1;
}
*/
