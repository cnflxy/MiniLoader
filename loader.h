#ifndef _LOADER_H_
#define _LOADER_H_ 1

#include "console.h"
#include "apm.h"
#include "memory.h"
#include "pci.h"

struct boot_configuration {
	u16 SectorsPerTrack;
	u16 NumberHeads;
	u16 CyliderCount;

	u8 DriveNumber;
	u16 BytesPerSector;
	u8 SectorsPerCluster;
	u32 TotalSectors;

	u32 FatStartSector;
	u32 FatSectors;
	u32 RootDirStartSector;
	u32 RootDirSectors;
	u32 DataStartSector;

	u32 LoaderSize;
} __attribute__((packed));

struct loader_parameter {
	struct boot_configuration *boot_info;
	struct console_configuration * console_info;
	struct pci_configuration *pci_info;
	struct apm_configuration *apm_info;
	struct e820_entry *ards_buf;
} __attribute__((packed));

#endif

