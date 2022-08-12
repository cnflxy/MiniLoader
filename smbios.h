#ifndef _SMBIOS_H_
#define _SMBIOS_H_ 1

#include "types.h"

#pragma pack(1)
typedef struct
{
    char Signature1[4];  // "_SM_"
    u8 Checksum1;
    u8 Length;
    u8 MajorVersion;
    u8 MinorVersion;
    u16 MaxStructureSize;
    u8 EpsRevision;
    u8 FormattedArea[5];
    char Signature2[5]; // "_DMI_"
    u8 Checksum2;
    u16 StructureLength;
    u32 StructureAddress;
    u16 NumberOfStructure;
    u8 SmbiosBcdRevison;
} smbios_eps_t; // SMBIOS Entry Point Structure
#pragma pack()

typedef struct
{
    u8 Type;
    u8 Length;
    u16 Handle;
} smbios_sth_t;  // Structure Table Header



#endif
