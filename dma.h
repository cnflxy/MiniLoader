#ifndef _DMA_H_
#define _DMA_H_ 1

/*
Intel 8237A DMA chips

https://wiki.osdev.org/DMA
http://bos.asmhackers.net/docs/dma/docs/
*/

// channel 0-3 is 8-bits DMA, 4-7 is 16-bits DMA
#define DMA_PORT_ADDR_0		0x00	// unusable
#define DMA_PORT_ADDR_1		0x02	// write
#define DMA_PORT_ADDR_2		0x04	// write
#define DMA_PORT_ADDR_3		0x06	// write
#define DMA_PORT_ADDR_4		0xC0	// unusable - used for cascading the other DMA controller
#define DMA_PORT_ADDR_5		0xC4	// write
#define DMA_PORT_ADDR_6		0xC8	// write
#define DMA_PORT_ADDR_7		0xCC	// write

// #define DMA_PORT_COUNT_0	0x01	// unusable
#define DMA_PORT_COUNT_1	0x03	// write
#define DMA_PORT_COUNT_2	0x05	// write
#define DMA_PORT_COUNT_3	0x07	// write
// #define DMA_PORT_COUNT_4	0xC2	// unusable
#define DMA_PORT_COUNT_5	0xC6	// write
#define DMA_PORT_COUNT_6	0xCA	// write
#define DMA_PORT_COUNT_7	0xCE	// write

// #define DMA_PORT_PAGE_0		0x87	// unusable
#define DMA_PORT_PAGE_1		0x83	// write
#define DMA_PORT_PAGE_2		0x81	// write
#define DMA_PORT_PAGE_3		0x82	// write
// #define DMA_PORT_PAGE_4		0x8F	// unusable
#define DMA_PORT_PAGE_5		0x8B	// write
#define DMA_PORT_PAGE_6		0x89	// write
#define DMA_PORT_PAGE_7		0x8A	// write

#define DMA_PORT_STATUS_MASTER	        0x08	// read
#define DMA_PORT_CMD_MASTER		        0x08	// write
// #define DMA_PORT_REQUEST_MASTER	        0x09	// write
#define DMA_PORT_SMASK_MASTER	        0x0A	// write
#define DMA_PORT_MODE_MASTER		    0x0B	// write
#define DMA_PORT_FF_CLEAR_MASTER	    0x0C	// write - send any value to activate
// #define DMA_PORT_INTERM_MASTER	        0x0D	// read
#define DMA_PORT_MASTER_RESET_MASTER    0x0D	// write - send any value to activate
#define DMA_PORT_MASK_RESET_MASTER	    0x0E	// write - send any value to activate
#define DMA_PORT_MMASK_MASTER	        0x0F	// read(undocumented)-write

#define DMA_PORT_STATUS_SLAVE	    0xD0	// read
#define DMA_PORT_CMD_SLAVE		    0xD0	// write
// #define DMA_PORT_REQUEST_SLAVE	    0xD2	// write
#define DMA_PORT_SMASK_SLAVE	    0xD4	// write
#define DMA_PORT_MODE_SLAVE		    0xD6	// write
#define DMA_PORT_FF_CLEAR_SLAVE	    0xD8	// write - send any value to activate
// #define DMA_PORT_INTERM_SLAVE	    0xDA	// read
#define DMA_PORT_MASTER_RESET_SLAVE 0xDA	// write - send any value to activate
#define DMA_PORT_MASK_RESET_SLAVE	0xDC	// write - send any value to activate
#define DMA_PORT_MMASK_SLAVE	    0xDE	// read(undocumented)-write


void dma_setup(void);
bool dma_prepare(u8 channel, u32 paddr, u32 len, bool write);
// void dma_start(u8 channel, bool write);
void dma_release(u8 channel);
// bool dma_floppy(u32 addr, u32 len, bool write);
// bool dma_sb16(u32 addr, u32 len, bool write, u8 channel);

void Dma_setup(void);
bool dmaPrepare(u8 channel, u32 paddr, u32 len, bool write);
// void dma_start(u8 channel, bool write);
void DmaRelease(u8 channel);

#endif
