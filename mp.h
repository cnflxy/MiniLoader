#ifndef _MP_H_
#define _MP_H_ 1

#include "types.h"

typedef struct
{
    char Signature[4]; // "_MP_"
    u32 MpCfgAddress;
    u8 Length;
    u8 Revision;
    u8 Checksum;
    u8 MpCfgType;
    u8 Feature;
    u8 Reserved[3];
} mpfp_s; // MP Floating Pointer Structure

typedef struct
{
    char Signature[4]; // "PCMP"
    u16 Length;
    u8 Revision;
    u8 Checksum;
    char OemId[8];
    char ProductId[12];
    u32 OemTableAddress;
    u16 OemTableSize;
    u16 EntryCount;
    u32 LapicAddress;
    u16 ExtTableSize;
    u8 ExtTableChecksum;
    u8 Reserved;
} mpct_header_s; // MP Configuration Table Header

typedef struct
{
    u8 Type;
    u8 Body[];
} mpct_entry_s; // MP Configuration Table Entry

#define MPC_TYPE_LAPIC  0x0 // Processor (LAPIC) - One entry per processor
#define MPC_TYPE_BUS    0x1 // Bus - One entry per bus
#define MPC_TYPE_IOAPIC 0x2 // I/O APIC - One entry per I/O APIC
#define MPC_TYPE_IOIA   0x3 // I/O Interrupt Assignment - One entry per bus interrupt source
#define MPC_TYPE_LIA    0x4 // Local Interrupt Assignment - One entry per system interrupt source

typedef struct
{
    u8 Type;
    u8 LapicId;
    u8 LapicVer;
    u8 Flags;
    u32 CpuSignature;
    u32 CpuFeatures;
    u32 Reserved[2];
} mpct_lapic_s;

typedef struct
{
    u8 Type;
    u8 BusId;
    char BusType[6];
} mpct_bus_s;

typedef struct
{
    u8 Type;
    u8 IoapicId;
    u8 IoapicVer;
    u8 Flags;
    u32 IoapicAddress;
} mpct_ioapic_s;

typedef struct
{
    u8 Type;
    u8 IntrType;
    u16 Flags;
    u8 BusId;
    u8 BusIrq;
    u8 IoapicId;
    u8 IoapicIntIn;
} mpct_ioia_s;

typedef struct
{
    u8 Type;
    u8 IntrType;
    u16 Flags;
    u8 BusId;
    u8 BusIrq;
    u8 LapicId;
    u8 LapicIntIn;
} mpct_lia_s;

typedef struct
{
    u8 Type;
    u8 Length;
    u8 Body[];
} mpct_entry_ext_s;

#define MPCT_TYPE_EXT_SASM 128  // System Address Space Mapping
#define MPCT_TYPE_EXT_BHD 129   // BUS Hierarchy Descriptor
#define MPCT_TYPE_EXT_CBASM 130 // Compatibility BUS Address Space Modifier

typedef struct
{
    u8 Type;
    u8 Length; // 20
    u8 BusId;
    u8 AddressType;
    u32 Address[2];
    u32 AddressLength[2];
} mpct_ext_sasm_s;

typedef struct
{
    u8 Type;
    u8 Length; // 8
    u8 BusId;
    u8 BusInfo;
    u8 ParentBus;
} mpct_ext_bhd_s;

typedef struct
{
    u8 Type;
    u8 Length; // 8
    u8 BusId;
    u8 Modifier;
    u32 PreRangeList;
} mpct_ext_cbasm_s;

#endif
