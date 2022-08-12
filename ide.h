#ifndef _IDE_H_
#define _IDE_H_ 1

#include "types.h"

/**
 * https://wiki.osdev.org/PCI_IDE_Controller
 * http://www.interfacebus.com/ATA_HardDrive_Interface_Bus_Description.html
 **/

#define IDE_IOBASE0     0x1F0
#define IDE_CTRLBASE0   0x3F6   // should be 0x3F4, but 00h and 01h are reserverd
#define IDE_IOBASE1     0x170
#define IDE_CTRLBASE1   0x376   // same as 0x3F6

// PCI BUS Master IDE Registers
#define IDE_REG_BM_COMMAND      0x0D
#define IDE_REG_BM_STATUS       0x0F
#define IDE_REG_BM_ADDRESS      0x11

/**
 * BUS Master IDE COMMAND Register
 **/
#define IDE_BM_COMMAND_SS   0x1 // Start/Stop Bus Master (SSBM). 1=Start; 0=Stop.
#define IDE_BM_COMMAND_RW   0x8 // Bus Master Read/Write Control (RWCON). 0=Reads; 1=Writes.

/**
 * BUS Master IDE STATUS Register
 **/
#define IDE_BM_STATUS_ACTIVE    0x01    // Bus Master IDE Active (BMIDEA)—RO.
#define IDE_BM_STATUS_ERROR     0x02    // IDE DMA Error—R/WC
#define IDE_BM_STATUS_INTR      0x04    // IDE Interrupt Status—R/WC
#define IDE_BM_STATUS_DMA0      0x20    // Drive 0 DMA Capable (DMA0CAP)—R/W
#define IDE_BM_STATUS_DMA1      0x40    // Drive 1 DMA Capable (DMA1CAP)—R/W

#define IDE_IRQ0    14
#define IDE_IRQ1    15

void ide_setup(void);
int ide_read_write_sectors(u8 channel, u8 device, u32 lba, bool write, u8 count, void *buffer);

#endif
