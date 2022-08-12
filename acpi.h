#ifndef _ACPI_H_
#define _ACPI_H_ 1

#include "types.h"

/**
 * https://www.docin.com/p-61554705.html - PCI Firmware Specification Revision 3.0
 * https://www.kernel.org/doc/html/latest/arm64/acpi_object_usage.html - ACPI Tables
 **/

typedef struct
{
    char Signature[8]; // "RSD PTR "
    u8 Checksum;
    char OemId[6];
    u8 Revsion; // ACPI 1.0 is zero and only include rsdp
    u32 RsdtAddress;
} rsdp_t; // Root System Description Pointer Structure

typedef struct
{
    rsdp_t Rsdp;
    u32 Length;
    u32 XsdtAddress[2];
    u8 ExtendedChecksum;
    u8 Reserved[3];
} xsdp_t; // Extended System Description Table

typedef struct
{
    char Signature[4];
    u32 Length;
    u8 Revision;
    u8 Checksum;
    char OemId[6];
    char OemTableId[8];
    u32 OemRevision;
    char CreatorId[4];
    u32 CreatorRevision;
} sdth_t; // System Description Table Header

typedef struct
{
    sdth_t Header;
    u32 Entry[];
} rsdt_t; // Root System Description Table

typedef struct
{
    sdth_t Header;
    u64 Entry[];
} xsdt_t; // Extended System Description Table

typedef struct
{
    u8 AddressSpaceId;
    u8 RegisterBitWidth;
    u8 RegisterBitOffset;
    u8 AccessSize;
    u32 Address[2];
} acpi_address_t;

typedef struct
{
    sdth_t Header;
    u32 FacsAddress;
    u32 DsdtAddress;
    u8 IntrModel; // Reserved after ACPI 1.0
    u8 OemPmProfile;
    u16 SciIntr;
    u32 SmiCmdPort;
    u8 AcpiEnableCmd;
    u8 AcpiDisableCmd;
    u8 S4BiosReqCmd;
    u8 PStateCtrlCmd;
    u32 Pm1aEvtBlkPort;
    u32 Pm1bEvtBlkPort;
    u32 Pm1aCtrlBlkPort;
    u32 Pm1bCtrlBlkPort;
    u32 Pm2CtrlBlkPort;
    u32 PmTmrBlkPort;
    u32 Gpe0BlkPort;
    u32 Gpe1BlkPort;
    u8 Pm1EvtLen;
    u8 Pm1CtrlLen;
    u8 Pm2CtrlLen;
    u8 PmTmrLen;
    u8 Gpe0BlkLen;
    u8 Gpe1BlkLen;
    u8 Gpe1BaseOffset;
    u8 CstCtrlCmd;
    u16 PLvl2Lat;
    u16 PLvl3Lat;
    u16 FlushSize;
    u16 FlushStride;
    u8 DutyOffset;
    u8 DutyWidth;
    u8 DayAlrm;
    u8 MonAlrm;
    u8 Century;
    u16 IapcBootArch;
    u8 Reserved0;
    u32 Flags;
    acpi_address_t ResetReg;
    u8 ResetValue;
    u16 ArmBootArch;
    u8 FadtMinorVersion;
    u32 FacsAddress64[2];
    u32 DsdtAddress64[2];
    acpi_address_t Pm1aEvtBlkPort64;
    acpi_address_t Pm1bEvtBlkPort64;
    acpi_address_t Pm1aCtrlBlkPort64;
    acpi_address_t Pm1bCtrlBlkPort64;
    acpi_address_t Pm2CtrlBlkPort64;
    acpi_address_t PmTmrBlkPort64;
    acpi_address_t Gpe0BlkPort64;
    acpi_address_t Gpe1BlkPort64;
} fadt_s; // Fixed ACPI Description Table

typedef struct
{
    char Signature[4]; // "FACS"
    u32 Length;        // 64 bytes or larger
    u32 HwSignature;
    u32 FmWakingVector;
    u32 GlobalLockAddress;
    struct
    {
        u32 S4BiosEn : 1;
        u32 Reserved : 31;
    } Flags;
    u32 FmWakingVector64[2];
    u8 Version;
    u8 Reserved0[3];
    u32 OspmFlags;
    u8 Reserved1[24];
} facs_s;

typedef struct
{
    u32 Pending : 1;
    u32 Owned : 1;
    u32 Reserved : 30;
} facs_globallock_s;

typedef struct
{
    sdth_t Header;
    u32 LapicAddress;
    u32 Flags;
} madt_t; // Multiple APIC Description Table

#define PCAT_COMPAT 0x1

typedef struct
{
    u8 Type;
    u8 Length;
} adth_t; // APIC Description Table Header

#define MAT_LAPIC 0x0       // Processor Local APIC
#define MAT_IOAPIC 0x1      // I/O APIC
#define MAT_ISO 0x2         // Interrupt Source Override
#define MAT_NMI 0x3         // Non-maskable Interrupt (NMI) Source
#define MAT_LAPIC_NMI 0x4   // Local APIC NMI
#define MAT_LAPIC_ADDR 0x5  // Local APIC Address Override
#define MAT_IOSAPIC 0x6     // I/O SAPIC
#define MAT_LSAPIC 0x7      // Local SAPIC
#define MAT_PIS 0x8         // Platform Interrupt Sources
#define MAT_X2LAPIC 0x9     // Processor Local x2APIC
#define MAT_X2LAPIC_NMI 0xA // Local x2APIC NMI
#define MAT_GICC 0xB        // GIC CPU Interface
#define MAT_GICD 0xC        // GIC Distributor
#define MAT_GICMSI 0xD      // GIC MSI Frame
#define MAT_GICR 0xE        // GIC Redistributor
#define MAT_GICITS 0xF      // GIC Interrupt Translation Service
// Reserved

typedef struct
{
    sdth_t Header;
    struct
    {
        u32 RevId : 8;
        u32 NumberOfComparators : 5;
        u32 CounterSize : 1;
        u32 Reserved : 1;
        u32 LegacyReplacementIrqRouting : 1;
        u32 VendorId : 16;
    } EventTimerBlockId;
    acpi_address_t BaseAddress;
    u8 HpetNumber;
    u16 MinClockTickPeriodic;
    u8 PageProtectionOemAttribute;
} hpet_t;

typedef struct
{
    u32 BaseAddress[2];
    u16 PciSegGroupNumber;
    u8 StartBusNumber;
    u8 EndBusNumber;
    u32 Reserved;
} mcfg_entry_t;

typedef struct
{
    sdth_t Header;
    u8 Reserved[8];
    mcfg_entry_t Entry[];
} mcfg_t;

typedef struct
{
    sdth_t Header;
    acpi_address_t EcCtrlAddress;
    acpi_address_t EcDataAddress;
    u32 Uid;
    u8 GpeBit;
    char EcId[];    // null-terminated
} ecdt_t;   // Embedded Controller Boot Resources Table

typedef struct
{
    u8 Type;
    u8 Length;
    u8 Body[];
} pcct_sth_t;   // Platform Communications Channel Table - Subspace Table Header

typedef struct
{
    sdth_t Header;
    u32 Flags;
    u32 Reserved[2];
    u8 SubspaceStructure[];
} pcct_t;   // Platform Communications Channel Table


#endif
