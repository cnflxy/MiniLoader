#include "loader.h"
#include "cmos.h"
#include "console.h"
#include "cpu.h"
#include "dma.h"
#include "floppy.h"
#include "idt.h"
#include "io.h"
#include "page.h"
#include "pci.h"
#include "pic.h"
#include "pit.h"
#include "lib.h"
#include "memory.h"
#include "bxdebug.h"
#include "8042.h"
#include "sb16.h"
#include "ide.h"
#include "string.h"
#include "wave.h"
#include "es1370.h"
#include "acpi.h"
#include "mp.h"
#include "smbios.h"

static void init(const struct loader_parameter *param)
{
	paging_setup();
	idt_setup();
	mem_setup(param->ards_buf);
	console_setup(param->console_info);
	pic_setup();
	pit_setup();
	cmos_setup();
	dma_setup();
	apm_setup(param->apm_info);
	pci_setup(param->pci_info);
	enable();
	ps2_setup();
	floppy_setup();
	ide_setup();
	getchar();
	sb16_setup();
	getchar();
	es1370_setup();
	getchar();
}

static xsdp_t *AcpiSearch(u32 addr, u32 len)
{
	xsdp_t *p;
	for (u8 *s = (u8 *)addr, *e = (u8 *)(addr + len); s < e; s += 16, p = NULL)
	{
		p = (xsdp_t *)s;
		if (memcmp(p->Rsdp.Signature, "RSD PTR ", 8))
			continue;
		if ((u32)e - (u32)s < sizeof(rsdp_t))
			continue;
		if (checksum_add(p, sizeof(rsdp_t)))
			continue;
		if (p->Rsdp.Revsion != 0 && p->Rsdp.Revsion != 2)
		{
			printf("unknown revision: %d\n", p->Rsdp.Revsion);
			continue;
		}
		if (p->Rsdp.Revsion == 2)
		{
			if ((u32)e - (u32)s < sizeof(xsdp_t))
				continue;
			if (p->Length != sizeof(xsdp_t))
				continue;
			if (checksum_add(p, sizeof(xsdp_t)))
				continue;
		}
		break;
	}

	return p;
}

static void PrintSdth(const sdth_t *Header)
{
	char buf[9];

	printf("Address        =0x%x\n", get_paddr(Header));
	memcpy(buf, Header->Signature, 4);
	buf[4] = 0;
	printf("Signature      =%s\n", buf);
	printf("Length         =%d\n", Header->Length);
	printf("Revision       =%d\n", Header->Revision);
	memcpy(buf, Header->OemId, 6);
	buf[6] = 0;
	printf("OemId          =%s\n", buf);
	memcpy(buf, Header->OemTableId, 8);
	buf[8] = 0;
	printf("OemTableId     =%s\n", buf);
	printf("OemRevision    =%d\n", Header->OemRevision);
	memcpy(buf, Header->CreatorId, 4);
	buf[4] = 0;
	printf("CreatorId      =%s\n", buf);
	printf("CreatorRevision=%d\n", Header->CreatorRevision);
	getchar();
}

static void WalkSdt(const xsdp_t *xsdp_ptr)
{
	bool use_xsdt = false;
	u32 SdtAddress = xsdp_ptr->Rsdp.RsdtAddress;
	if (xsdp_ptr->Rsdp.Revsion == 2 && xsdp_ptr->XsdtAddress)
	{
		use_xsdt = true;
		SdtAddress = xsdp_ptr->XsdtAddress[0];
	}

	sdth_t *header;
	rsdt_t *rsdt_ptr;
	xsdt_t *xsdt_ptr;

	header = map_mem(SdtAddress, sizeof(sdth_t));
	rsdt_ptr = (rsdt_t *)(xsdt_ptr = map_mem(SdtAddress, header->Length));
	unmap_mem(header);

	do
	{
		if (checksum_add(xsdt_ptr, xsdt_ptr->Header.Length))
		{
			printf("invalid SDT checksum!\n");
			break;
		}

		PrintSdth(&rsdt_ptr->Header);

		u32 XsdtEntryN;
		if (use_xsdt)
		{
			XsdtEntryN = (xsdt_ptr->Header.Length - sizeof(sdth_t)) / 8;
		}
		else
		{
			XsdtEntryN = (rsdt_ptr->Header.Length - sizeof(sdth_t)) / 4;
		}

		for (u32 i = 0; i < XsdtEntryN; ++i)
		{
			u32 EntryAddress;
			if (use_xsdt)
			{
				EntryAddress = (u32)xsdt_ptr->Entry[i];
			}
			else
			{
				EntryAddress = rsdt_ptr->Entry[i];
			}

			header = map_mem(EntryAddress, sizeof(sdth_t));
			void *full_map = map_mem(EntryAddress, header->Length);

			do
			{
				if (checksum_add(full_map, header->Length))
				{
					printf("invalid checksum! (at Entry[%d]=0x%x)\n", i, EntryAddress);
					break;
				}

				PrintSdth(header);
				if (!memcmp(header->Signature, "APIC", 4))
				{
					madt_t *madt_ptr = full_map;
					printf("LapicAddress=0x%x\n", madt_ptr->LapicAddress);
					printf("Flags       =0x%x", madt_ptr->Flags);
					if (madt_ptr->Flags & PCAT_COMPAT)
						printf(", PCAT_COMPAT");
					print_char('\n');

					for (u8 *s = (u8 *)(madt_ptr + 1), *e = (u8 *)madt_ptr + madt_ptr->Header.Length; s < e;)
					{
						adth_t *adth_ptr = (adth_t *)s;
						const char *type_name[] = {
							"Processor Local APIC",
							"I/O APIC",
							"Interrupt Source Override",
							"Non-maskable Interrupt (NMI) Source",
							"Local APIC NMI",
							"Local APIC Address Override",
							"I/O SAPIC",
							"Local SAPIC",
							"Platform Interrupt Sources",
							"Processor Local x2APIC",
							"Local x2APIC NMI",
							"GIC CPU Interface",
							"GIC Distributor",
							"GIC MSI Frame",
							"GIC Redistributor",
							"GIC Interrupt Translation Service"};
						if (adth_ptr->Type > MAT_GICITS)
						{
							printf("Type  =Reserved, 0x%x\n", adth_ptr->Type);
							printf("Length=%d\n", adth_ptr->Length);
						}
						else
						{
							printf("Type  =%s, 0x%x\n", type_name[adth_ptr->Type], adth_ptr->Type);
							printf("Length=%d\n", adth_ptr->Length);
							u8 *tmp = (u8 *)(adth_ptr + 1);
							switch (adth_ptr->Type)
							{
							case MAT_LAPIC:
								printf("Processor UID=%d\n", tmp[0]);
								printf("LAPIC ID     =%d\n", tmp[1]);
								printf("Flags        =0x%x\n", *(u32 *)(tmp + 2));
								break;
							case MAT_IOAPIC:
								printf("IOAPIC ID     =%d\n", tmp[0]);
								printf("IOAPIC Address=0x%x\n", *(u32 *)(tmp + 2));
								printf("GSI Base      =%d\n", *((u32 *)(tmp + 2) + 1));
								break;
							case MAT_ISO:
								printf("Bus   =%d\n", tmp[0]);
								printf("Source=%d\n", tmp[1]);
								printf("GSI   =%d\n", *(u32 *)(tmp + 2));
								printf("Flags =0x%x\n", *(u16 *)((u32 *)(tmp + 2) + 1));
								break;
							case MAT_NMI:
								break;
							case MAT_LAPIC_NMI:
								printf("Processor UID=%d\n", tmp[0]);
								printf("Flags        =0x%x\n", *(u16 *)(tmp + 1));
								printf("LAPIC LINTn  =%d\n", tmp[3]);
								break;
							case MAT_LAPIC_ADDR:
								printf("LAPIC Address=0x%x\n", *(u32 *)(tmp + 2));
								break;
							case MAT_IOSAPIC:
							case MAT_LSAPIC:
							case MAT_PIS:
								break;
							case MAT_X2LAPIC:
								printf("x2LAPIC ID   =%d\n", *(u32 *)(tmp + 2));
								printf("Flags        =0x%x\n", *((u32 *)(tmp + 2) + 1));
								printf("Processor UID=%d\n", *((u32 *)(tmp + 2) + 2));
								break;
							case MAT_X2LAPIC_NMI:
							case MAT_GICC:
							case MAT_GICD:
							case MAT_GICMSI:
							case MAT_GICR:
							case MAT_GICITS:
								break;
							}
							getchar();
						}
						s += adth_ptr->Length;
					}
				}
				else if (!memcmp(header->Signature, "HPET", 4))
				{
					// 0x8086a201
					hpet_t *hpet_ptr = full_map;
					printf("EventTimerBlockId.VendorId        =0x%x\n", hpet_ptr->EventTimerBlockId.VendorId);
					printf("EventTimerBlockId.Legacy          =%d\n", hpet_ptr->EventTimerBlockId.LegacyReplacementIrqRouting);
					printf("EventTimerBlockId.CounterSize     =%d\n", hpet_ptr->EventTimerBlockId.CounterSize);
					printf("EventTimerBlockId.NumOfComparators=%d\n", hpet_ptr->EventTimerBlockId.NumberOfComparators);
					printf("EventTimerBlockId.RevId           =%d\n", hpet_ptr->EventTimerBlockId.RevId);
					printf("BaseAddress                       =0x%x_%x, %d, %d:%d\n",
						   hpet_ptr->BaseAddress.Address[1], hpet_ptr->BaseAddress.Address[0],
						   hpet_ptr->BaseAddress.AddressSpaceId,
						   hpet_ptr->BaseAddress.RegisterBitWidth, hpet_ptr->BaseAddress.RegisterBitOffset);
					printf("HPET Number                       =%d\n", hpet_ptr->HpetNumber);
					printf("Min Periodic tick                 =%d\n", hpet_ptr->MinClockTickPeriodic);
					printf("Protection And Attribute          =0x%x\n", hpet_ptr->PageProtectionOemAttribute);
					getchar();
				}
				else if (!memcmp(header->Signature, "MCFG", 4))
				{
					mcfg_t *mcfg_ptr = full_map;
					u32 mcfg_entry_n = (mcfg_ptr->Header.Length - sizeof(mcfg_t)) / sizeof(mcfg_entry_t);
					for (u32 i = 0; i < mcfg_entry_n; ++i)
					{
						printf("BaseAddress=0x%x_%x\n",
							   mcfg_ptr->Entry[i].BaseAddress[1], mcfg_ptr->Entry[i].BaseAddress[0]);
						printf("PciSegGroup=%d\n", mcfg_ptr->Entry[i].PciSegGroupNumber);
						printf("StartBus   =%d\n", mcfg_ptr->Entry[i].StartBusNumber);
						printf("EndBus     =%d\n", mcfg_ptr->Entry[i].EndBusNumber);
						getchar();
					}
				}
				else if (!memcmp(header->Signature, "ECDT", 4))
				{
					ecdt_t *ecdt_ptr = full_map;
					printf("EcCtrlAddress=0x%x_%x, %d, %d:%d\n",
						   ecdt_ptr->EcCtrlAddress.Address[1], ecdt_ptr->EcCtrlAddress.Address[0],
						   ecdt_ptr->EcCtrlAddress.AddressSpaceId,
						   ecdt_ptr->EcCtrlAddress.RegisterBitWidth, ecdt_ptr->EcCtrlAddress.RegisterBitOffset);
					printf("EcDataAddress=0x%x_%x, %d, %d:%d\n",
						   ecdt_ptr->EcDataAddress.Address[1], ecdt_ptr->EcDataAddress.Address[0],
						   ecdt_ptr->EcDataAddress.AddressSpaceId,
						   ecdt_ptr->EcDataAddress.RegisterBitWidth, ecdt_ptr->EcDataAddress.RegisterBitOffset);
					printf("UID          =0x%x\n", ecdt_ptr->Uid);
					printf("GPE_BIT      =0x%x\n", ecdt_ptr->GpeBit);
					printf("EC_ID        =%s\n", ecdt_ptr->EcId);
					getchar();
				}
				else if (!memcmp(header->Signature, "PCCT", 4))
				{
					pcct_t *pcct_ptr = full_map;
					printf("PCC GlobalFlags=0x%x\n", pcct_ptr->Flags);
					for (u8 *s = pcct_ptr->SubspaceStructure, *e = (u8 *)full_map + header->Length; s < e;)
					{
						pcct_sth_t *SubspaceStructHeader = (pcct_sth_t *)s;
						printf("Subspace Type=%d\n", SubspaceStructHeader->Type);
						printf("Length       =%d\n", SubspaceStructHeader->Length);
						s += SubspaceStructHeader->Length;
					}
				}
			} while (false);

			unmap_mem(header);
			unmap_mem(full_map);
		}
	} while (false);

	unmap_mem(xsdt_ptr);
}

static mpfp_s *MpfpSearch(u32 addr, u32 len)
{
	mpfp_s *p;
	for (u8 *s = (u8 *)addr, *e = (u8 *)(addr + len); s < e; s += 16, p = NULL)
	{
		p = (mpfp_s *)s;
		if (memcmp(p->Signature, "_MP_", 4))
			continue;
		if ((u32)e - (u32)s < sizeof(mpfp_s))
			continue;
		if (p->Length != 1)
			continue;
		if (p->Revision != 1 && p->Revision != 4)
		{
			printf("invalid Revision=%d\n", p->Revision);
			continue;
		}
		if (checksum_add(p, p->Length * 16))
			continue;
		break;
	}

	return p;
}

static void WalkMpct(const mpfp_s *mpfp_ptr)
{
	mpct_header_s *mpct_header = map_mem(mpfp_ptr->MpCfgAddress, sizeof(mpct_header_s));
	do
	{
		if (memcmp(mpct_header->Signature, "PCMP", 4))
		{
			printf("invalid MPCT_Header signature!\n");
			break;
		}
		if (sizeof(mpct_header_s) > mpct_header->Length)
		{
			printf("incorrect MPCT_Header length=%d\n", mpct_header->Length);
			break;
		}
		if (checksum_add(mpct_header, mpct_header->Length))
		{
			printf("invalid MPCT_Header checksum!\n");
			break;
		}
		if (mpct_header->ExtTableSize)
		{
			void *full_map = map_mem(mpfp_ptr->MpCfgAddress, mpct_header->Length + mpct_header->ExtTableSize);
			unmap_mem(mpct_header);
			mpct_header = full_map;
		}

		printf("Revision     =%d\n", mpct_header->Revision);
		char buf[13];
		memcpy(buf, mpct_header->OemId, 8);
		buf[8] = 0;
		printf("OemId        =%s\n", buf);
		memcpy(buf, mpct_header->ProductId, 12);
		buf[12] = 0;
		printf("ProductId    =%s\n", buf);
		printf("OemTableAddr =0x%x\n", mpct_header->OemTableAddress);
		printf("OemTableSize =%d\n", mpct_header->OemTableSize);
		printf("EntryCount   =%d\n", mpct_header->EntryCount);
		printf("LAPIC Address=0x%x\n", mpct_header->LapicAddress);
		printf("ExtTableSize =%d\n", mpct_header->ExtTableSize);
		printf("ExtChecksum  =0x%x\n", mpct_header->ExtTableChecksum);

		if (mpct_header->ExtTableSize)
		{
			u8 sum = checksum_add((u8 *)mpct_header + mpct_header->Length, mpct_header->ExtTableSize);
			printf("ext_checksum =0x%x\n", sum);
			if ((sum + mpct_header->ExtTableChecksum) & 0xff)
			{
				printf("invalid MPCT_Header_ExtTable checksum!\n");
				break;
			}
		}
		getchar();

		for (u8 *s = (u8 *)(mpct_header + 1), *e = (u8 *)mpct_header + mpct_header->Length; s < e;)
		{
			mpct_entry_s *entry = (mpct_entry_s *)s;
			u32 EntrySize;
			if (entry->Type == MPC_TYPE_LAPIC)
				EntrySize = sizeof(mpct_lapic_s);
			else if (entry->Type <= MPC_TYPE_LIA)
				EntrySize = 8;
			else
			{
				printf("invalid entry Type=%d\n", entry->Type);
				break;
			}

			if ((u32)e - (u32)s < EntrySize)
			{
				printf("incorrect MPCT_Header length=%d\n", mpct_header->Length);
				break;
			}

			switch (entry->Type)
			{
			case MPC_TYPE_LAPIC:
			{
				mpct_lapic_s *lapic_ptr = (mpct_lapic_s *)s;
				printf("LAPIC Id     =%d\n", lapic_ptr->LapicId);
				printf("LAPIC Ver    =%d\n", lapic_ptr->LapicVer);
				printf("Flags        =0x%x,", lapic_ptr->Flags);
				if (!(lapic_ptr->Flags & 0x1))
					print_str(" Unusable");
				if (lapic_ptr->Flags & 0x2)
					print_str(" BP");
				else
					print_str(" AP");
				printf("\nCPU Signature=0x%x\n", lapic_ptr->CpuSignature);
				printf("CPU Features =0x%x\n", lapic_ptr->CpuFeatures);
			}
			break;
			case MPC_TYPE_BUS:
			{
				mpct_bus_s *bus_ptr = (mpct_bus_s *)s;
				printf("BUS Id  =%d\n", bus_ptr->BusId);
				memcpy(buf, bus_ptr->BusType, 6);
				buf[6] = 0;
				printf("BUS type=%d\n", buf);
			}
			break;
			case MPC_TYPE_IOAPIC:
			{
				mpct_ioapic_s *ioapic_ptr = (mpct_ioapic_s *)s;
				printf("IOAPIC Id     =%d\n", ioapic_ptr->IoapicId);
				printf("IOAPIC Ver    =%d\n", ioapic_ptr->IoapicVer);
				printf("Flags         =0x%x", ioapic_ptr->Flags);
				if (!(ioapic_ptr->Flags & 0x1))
					print_str(", Unusable");
				printf("\nIOAPIC Address=0x%x\n", ioapic_ptr->IoapicAddress);
			}
			break;
			case MPC_TYPE_IOIA:
			{
				mpct_ioia_s *ioia_ptr = (mpct_ioia_s *)s;
				printf("Interrupt Type  =%d\n", ioia_ptr->IntrType);
				printf("Flags           =0x%x\n", ioia_ptr->Flags);
				printf("Source BUS Id   =%d\n", ioia_ptr->BusId);
				printf("Source BUS Irq  =%d\n", ioia_ptr->BusIrq);
				printf("Dst IOAPIC Id   =%d\n", ioia_ptr->IoapicId);
				printf("Dst IOAPIC INTIN=%d\n", ioia_ptr->IoapicIntIn);
			}
			break;
			case MPC_TYPE_LIA:
			{
				mpct_lia_s *lia_ptr = (mpct_lia_s *)s;
				printf("Interrupt Type =%d\n", lia_ptr->IntrType);
				printf("Flags          =0x%x\n", lia_ptr->Flags);
				printf("Source BUS Id  =%d\n", lia_ptr->BusId);
				printf("Source BUS Irq =%d\n", lia_ptr->BusIrq);
				printf("Dst LAPIC Id   =%d\n", lia_ptr->LapicId);
				printf("Dst LAPIC INTIN=%d\n", lia_ptr->LapicIntIn);
			}
			break;
			}

			s += EntrySize;
			getchar();
		}

		if (mpct_header->ExtTableSize)
		{
			for (u8 *s = (u8 *)mpct_header + mpct_header->Length, *e = s + mpct_header->ExtTableSize; s < e;)
			{
				mpct_entry_ext_s *entry = (mpct_entry_ext_s *)s;
				u32 EntrySize;
				if (entry->Type == MPCT_TYPE_EXT_SASM)
					EntrySize = sizeof(mpct_ext_sasm_s);
				else if (entry->Type == MPCT_TYPE_EXT_BHD || entry->Type == MPCT_TYPE_EXT_CBASM)
					EntrySize = 8;
				else
				{
					printf("invalid entry Type=%d\n", entry->Type);
					break;
				}

				if (entry->Length != EntrySize)
				{
					printf("incorrect MPCT_Ext_Entry(Type=%d) length=%d\n", entry->Type, entry->Length);
					break;
				}

				if ((u32)e - (u32)s < EntrySize)
				{
					printf("incorrect MPCT_Ext_Header length=%d\n", mpct_header->ExtTableSize);
					break;
				}

				switch (entry->Type)
				{
				case MPCT_TYPE_EXT_SASM:
				{
					mpct_ext_sasm_s *sasm_ptr = (mpct_ext_sasm_s *)s;
					printf("BUS Id       =%d\n", sasm_ptr->BusId);
					printf("AddressType  =%d\n", sasm_ptr->AddressType);
					printf("Address      =0x%x_%x\n", sasm_ptr->Address[1], sasm_ptr->Address[0]);
					printf("AddressLength=0x%x_%x\n", sasm_ptr->AddressLength[1], sasm_ptr->AddressLength[0]);
				}
				break;
				case MPCT_TYPE_EXT_BHD:
				{
					mpct_ext_bhd_s *bhd_ptr = (mpct_ext_bhd_s *)s;
					printf("BUS Id    =%d\n", bhd_ptr->BusId);
					printf("BUS Info  =%d\n", bhd_ptr->BusInfo);
					printf("Parent BUS=%d\n", bhd_ptr->ParentBus);
				}
				break;
				case MPCT_TYPE_EXT_CBASM:
				{
					mpct_ext_cbasm_s *cbasm_ptr = (mpct_ext_cbasm_s *)s;
					printf("BUS Id      =%d\n", cbasm_ptr->BusId);
					printf("Modifier    =%d\n", cbasm_ptr->Modifier);
					printf("PreRangeList=%d\n", cbasm_ptr->PreRangeList);
				}
				break;
				}

				s += EntrySize;
				getchar();
			}
		}
	} while (false);

	unmap_mem(mpct_header);
}

static smbios_eps_t *SmbiosSearch(void)
{
	smbios_eps_t *p = NULL;
	for (u8 *s = (u8 *)0xF0000, *e = (u8 *)(0xF0000 + 0x10000); s < e; s += 16, p = NULL)
	{
		if ((u32)e - (u32)s < sizeof(smbios_eps_t))
			break;
		p = (smbios_eps_t *)s;
		if (memcmp(p->Signature1, "_SM_", 4))
			continue;
		if (memcmp(p->Signature2, "_DMI_", 5))
			continue;
		if (p->MajorVersion < 2 || (p->MajorVersion == 2 && p->MinorVersion <= 1))
		{
			printf("Unsupported SMBIOS Version %d.%d!\n", p->MajorVersion, p->MinorVersion);
			continue;
		}
		if (p->Length != sizeof(smbios_eps_t))
			continue;
		if (checksum_add(p, sizeof(smbios_eps_t)))
			continue;
		if (checksum_add(s + 0x10, 0xf))
			continue;
		break;
	}

	return p;
}

static void WalkSmbios(const smbios_eps_t *SmbiosEpsPtr)
{
	u8 *p = map_mem(SmbiosEpsPtr->StructureAddress, SmbiosEpsPtr->StructureLength), *s = p, *e = s + SmbiosEpsPtr->StructureLength;
	while (s < e)
	{
		if ((u32)e - (u32)s < sizeof(smbios_sth_t))
			break;
		smbios_sth_t *header = (smbios_sth_t *)s;
		if ((u32)e - (u32)s < header->Length)
			break;
		printf("Type  =%d\n", header->Type);
		printf("Length=%d\n", header->Length);
		printf("Handle=0x%x\n", header->Handle);
		if (header->Type == 127) // EndOfTable
			break;
		s += header->Length;
		while (*(u16 *)s)
			++s;
		s += 2;
		getchar();
	}
	unmap_mem(p);
}

#if 1
static void print_pci_conf_info(const struct pci_dev_info *dev_info)
{
	printf("%x:%x.%x type_%x&ven_%x&dev_%x",
		   dev_info->bus, dev_info->dev, dev_info->func,
		   dev_info->type, dev_info->ven_id, dev_info->dev_id);
	u32 class_rev = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 2);
	u32 class = class_rev >> 8; // class: class-subclass-progif
	printf("&rev_%x&class_%x_%x_%x", class_rev & 0xff, class >> 16, (class >> 8) & 0xff, class & 0xff);
	if (dev_info->type != PCI_DEV_TYPE_PCI2PCI_BRIDGE) // PCI-to-PCI Bridge
	{
		print_str("&subsys_");
		if (dev_info->type == PCI_DEV_TYPE_DEVICE) // General Device
		{
			u32 subsys_ven = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 11);
			printf("%x_%x", subsys_ven & 0xffff, subsys_ven >> 16);
		}
		else if (dev_info->type == PCI_DEV_TYPE_CARDBUS_BRIDGE) // PCI-to-CardBus bridge
		{
			print_hex(pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 0x10), 4);
		}
	}
	print_char('\n');
}
#endif

extern void LdrMain(const struct loader_parameter *param)
{
	init(param);

#if 1
	mem_dumpinfo();
	getchar();
	paging_dumpinfo();
	getchar();
	console_dumpinfo();
	getchar();
	floppy_dumpinfo();
	getchar();

	u32 colums, rows;
	console_get_print_size(&colums, &rows);

	for (u32 i = 0; i < colums - 1; ++i)
		print_char('*');
	print_char('#');
	for (u8 i = 0; i < colums - 1; ++i)
		print_char('#');
	print_char('*');
	getchar();

	struct rtc_time time;
	if (cmos_rtc_time(&time))
	{
		// print_str("\nshell>time\n");
		printf("current RTC time: %d/%d/%d %d:%d:%d\n", time.year, time.month, time.day, time.hours, time.minutes, time.seconds);
		getchar();
	}

	u32 eax, cpuid_basic_max;
	char cpu_brand[49];
	cpuid(0, &cpuid_basic_max, (u32 *)cpu_brand, (u32 *)(cpu_brand + 8), (u32 *)(cpu_brand + 4));
	cpu_brand[12] = 0;
	printf("cpuid_basic_max: 0x%x\n", cpuid_basic_max);
	cpuid(0x80000000, &eax, (u32 *)(cpu_brand + 13), (u32 *)(cpu_brand + 13), (u32 *)(cpu_brand + 13));
	printf("cpuid_ext_max: 0x%x\ncpu_vendor: %s\n", eax, cpu_brand);
	if (eax >= 0x80000004)
	{
		char *ptr = cpu_brand;
		for (u32 index = 0x80000002; index <= 0x80000004; ++index)
		{
			cpuid(index, (u32 *)ptr, (u32 *)(ptr + 4), (u32 *)(ptr + 8), (u32 *)(ptr + 12));
			ptr += 16;
		}
		*ptr = 0;
		printf("cpu_brand: %s\n", cpu_brand);
	}
	if (cpuid_basic_max >= 0x1)
	{
		u32 eax, ebx, ecx, edx;
		cpuid(0x1, &eax, &ebx, &ecx, &edx);
		printf("version=0x%x: family=%x, model=%x, stepping=%x, type=%x\n",
			   eax,
			   (eax >> 8) & 0xf, (eax >> 4) & 0xf, eax & 0xf,
			   (eax >> 12) & 0x3);
		printf("CPUID[01H].EBX=0x%x, ECX=0x%x, EDX=0x%x\n", ebx, ecx, edx);
		if (ecx & (1 << 21))
			print_str("x2APIC ");
		if (ecx & (1 << 24))
			print_str("TSC-Deadline ");
		if (ecx & (1 << 30))
			print_str("RDRAND ");
		if (edx & (1 << 0))
			print_str("FPU ");
		if (edx & (1 << 4))
			print_str("TSC ");
		if (edx & (1 << 5))
			print_str("MSR ");
		if (edx & (1 << 9))
			print_str("APIC ");
		print_char('\n');
	}
	getchar();

#if 0
	void *laddr[3];
	laddr[0] = alloc_page(1 * PAGE_SIZE, normal_phy_mem);
	laddr[1] = alloc_page(2 * PAGE_SIZE, normal_phy_mem);
	laddr[2] = alloc_page(3 * PAGE_SIZE, normal_phy_mem);
	printf("%x - %x\n", laddr[0], get_paddr(laddr[0]));
	printf("%x - %x\n", laddr[1], get_paddr(laddr[1]));
	printf("%x - %x\n", laddr[2], get_paddr(laddr[2]));
	// bxdebug_break();
	free_page(laddr[1]);
	printf("%x - %x\n", laddr[1], get_paddr(laddr[1]));
	// bxdebug_break();
	laddr[1] = alloc_page(1 * PAGE_SIZE, normal_phy_mem);
	printf("%x - %x\n", laddr[1], get_paddr(laddr[1]));
	// bxdebug_break();
	free_page(laddr[1]);
	printf("%x - %x\n", laddr[1], get_paddr(laddr[1]));
	// bxdebug_break();
	laddr[1] = alloc_page(2 * PAGE_SIZE, normal_phy_mem);
	printf("%x - %x\n", laddr[1], get_paddr(laddr[1]));
	// bxdebug_break();
	free_page(laddr[1]);
	printf("%x - %x\n", laddr[1], get_paddr(laddr[1]));
	// bxdebug_break();
	laddr[1] = alloc_page(3 * PAGE_SIZE, normal_phy_mem);
	printf("%x - %x\n", laddr[1], get_paddr(laddr[1]));
	// bxdebug_break();
	free_page(laddr[1]);
	printf("%x - %x\n", laddr[1], get_paddr(laddr[1]));
	// bxdebug_break();

	free_page(laddr[0]);
	free_page(laddr[2]);
	printf("%x - %x\n", laddr[0], get_paddr(laddr[0]));
	printf("%x - %x\n", laddr[2], get_paddr(laddr[2]));
	// getchar();
	// delay_ms(3000);
#endif

	const struct boot_configuration *boot_info = param->boot_info;
	console_set_color(COLOR_NORMAL_BG, COLOR_LIGHT_RED);
	print_str("boot drive: ");
	console_set_color(COLOR_NORMAL_BG, COLOR_LIGHT_GREEN);
	printf("0x%x\n", boot_info->DriveNumber);
	console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
	printf("CyliderCount: %d\n", boot_info->CyliderCount);
	printf("NumberHeads: %d\n", boot_info->NumberHeads);
	printf("SectorsPerTrack: %d\n", boot_info->SectorsPerTrack);
	printf("BytesPerSector: %d\n", boot_info->BytesPerSector);
	printf("SectorsPerCluster: %d\n", boot_info->SectorsPerCluster);
	printf("TotalSectors: %d\n", boot_info->TotalSectors);
	printf("FatStartSector: %d\n", boot_info->FatStartSector);
	printf("FatSectors: %d\n", boot_info->FatSectors);
	printf("RootDirStartSector: %d\n", boot_info->RootDirStartSector);
	printf("RootDirSectors: %d\n", boot_info->RootDirSectors);
	printf("DataStartSector: %d\n", boot_info->DataStartSector);
	printf("LoaderSize: %d\n", boot_info->LoaderSize);
	getchar();
	// delay_ms(3000);

	const struct console_configuration *console_info = param->console_info;
	printf("GUI: %s\n", console_info->GUI ? "YES" : "NO");
	printf("vbe_version: %d.%d\n", BCD2BIN(console_info->version >> 8), BCD2BIN(console_info->version));
	printf("oem_version: %d.%d\n", BCD2BIN(console_info->oem_version >> 8), BCD2BIN(console_info->oem_version));
	printf("width: %d\n", console_info->width);
	printf("height: %d\n", console_info->height);
	printf("show_mem_base: 0x%x\n", console_info->show_mem_base);
	printf("video_mode_list: 0x%x\n", console_info->video_mode_list);
	printf("total_memory_size: 0x%x\n", console_info->GUI ? console_info->total_memory_size * 64 * 1024 : console_info->total_memory_size);
	printf("bpp: %d\n", console_info->bpp);
	printf("Bpl: %d\n", console_info->Bpl);
	printf("colums: %d\n", colums);
	printf("rows: %d\n", rows);
	for (const u16 *mode = (u16 *)console_info->video_mode_list; *mode != 0xFFFF; ++mode)
	{
		printf("%x ", *mode);
	}
	print_char('\n');
	getchar();
	// delay_ms(3000);

	// print_str("\n\n");
	const struct pci_configuration *pci_info = param->pci_info;
	print_str("PCI_BIOS version: ");
	if (pci_info->present)
	{
		printf("%d.%d\n", BCD2BIN(pci_info->version >> 8), BCD2BIN(pci_info->version));
		print_str("hw_mechanism:");
		if (pci_info->hw_mechanism & 0x1)
			print_str(" mech1");
		if (pci_info->hw_mechanism & 0x2)
			print_str(" mech2");
		if (pci_info->hw_mechanism & 0x10)
			print_str(" cycle1");
		if (pci_info->hw_mechanism & 0x20)
			print_str(" cycle2");
		printf("\nlast_bus: 0x%x\n", pci_info->last_bus);
	}
	else
	{
		print_str("None\n");
	}
	getchar();
	// delay_ms(3000);

	// print_char('\n');
	const struct apm_configuration *apm_info = param->apm_info;
	print_str("APM_BIOS version: ");
	if (apm_info->ok)
	{
		printf("%d.%d\n", BCD2BIN(apm_info->version >> 8), BCD2BIN(apm_info->version));
		printf("original_flags: 0x%x\n", apm_info->original_flags);
		printf("cs32_base: 0x%x\n", apm_info->cs32_base);
		printf("cs32_size: 0x%x\n", apm_info->cs32_size);
		printf("cs16_base: 0x%x\n", apm_info->cs16_base);
		printf("cs16_size: 0x%x\n", apm_info->cs16_size);
		printf("ds_base: 0x%x\n", apm_info->ds_base);
		printf("ds_size: 0x%x\n", apm_info->ds_size);
		printf("entry_point: 0x%x\n", apm_info->entry_point);
	}
	else
	{
		print_str("None\n");
	}
	getchar();
	// delay_ms(3000);

#endif

#if 1
	// print_char('\n');
	const struct e820_entry *ards_buf = param->ards_buf;
	const char *e820_type_str[] = {"Unknown", "RAM", "Reserved", "ACPI_Reclaimable", "ACPI_NVS", "Unusable", "Disabled", "Persistent"};
	for (unsigned i = 0; ards_buf[i].Type != 0; ++i)
	{
		print_str("0x");
		if (ards_buf[i].BaseAddrHi)
			print_hex(ards_buf[i].BaseAddrHi, 8);
		print_hex(ards_buf[i].BaseAddrLow, 8);
		print_str(" 0x");
		if (ards_buf[i].LengthHi)
			print_hex(ards_buf[i].LengthHi, 8);
		print_hex(ards_buf[i].LengthLow, 8);
		print_char(' ');
		if (ards_buf[i].Type > 7)
			print_str("Undefined");
		else
			print_str(e820_type_str[ards_buf[i].Type]);
		print_char('\n');
	}
	getchar();
// delay_ms(3000);
#endif

// print_char('\n');
#if 1
	// print_str("\nshell>lspci\n");
	struct pci_dev_info dev_info;
	bool mf;
	u32 i = 0;
	for (dev_info.bus = 0; dev_info.bus <= 255; ++dev_info.bus)
	{
		for (dev_info.dev = 0; dev_info.dev <= 31; ++dev_info.dev)
		{
			mf = false;
			for (dev_info.func = 0; dev_info.func <= 7; ++dev_info.func)
			{
				u32 dev_ven = pci_conf_read_dword(dev_info.bus, dev_info.dev, dev_info.func, 0x0);
				if ((dev_ven & 0xffff) == 0xffff)
					continue;
				u8 htype = pci_conf_read_byte(dev_info.bus, dev_info.dev, dev_info.func, 0xe);
				if ((htype & 0x7f) > 2)
					continue;
				if (!mf)
					mf = (htype & 0x80) == 0x80;

				dev_info.mf = (htype & 0x80) == 0x80;
				dev_info.type = htype & 0x7f;
				dev_info.dev_id = dev_ven >> 16;
				dev_info.ven_id = dev_ven & 0xffff;

				if (++i == rows)
				{
					i = 0;
					getchar();
				}
				print_pci_conf_info(&dev_info);

				if (!mf)
					break;
			}
		}
	}
	getchar();
	// delay_ms(3000);
#endif

#if 0
	// print_char('\n');
	floppy_setup();
	if (floppy_prepare(0, false))
	{
		floppy_cmd_readid();
		floppy_release(0);
		// delay_ms(3000);
	}
	getchar();


	disable();
	cmos_enable_periodic();
	enable();
	delay_ms(3000);
	cmos_disable_periodic();
	getchar();
#endif

#if 1
	{
		struct pci_dev_info sata_device = {
			.class = 0x1,	// Mass storage controller
			.subclass = 0x6 // Serial ATA controller
		};
		if (pci_dev_find(&sata_device, false))
		{
			print_str("SATA Controller\n");
			printf("bus: 0x%x, dev: 0x%x, func: 0x%x\n",
				   sata_device.bus, sata_device.dev, sata_device.func);
			printf("ven: 0x%x, dev: 0x%x\n",
				   sata_device.ven_id, sata_device.dev_id);
			printf("class: 0x%x, subclass: 0x%x, progif: 0x%x, rev: 0x%x\n",
				   sata_device.class, sata_device.subclass, sata_device.progif, sata_device.rev);
			u32 subsys_ven, status_cmd;
			u16 intr_pin_line;
			subsys_ven = pci_conf_read_dword(sata_device.bus, sata_device.dev, sata_device.func, 11);
			printf("subsys: 0x%x, ven: 0x%x\n", subsys_ven >> 16, subsys_ven & 0xffff);
			status_cmd = pci_conf_read_dword(sata_device.bus, sata_device.dev, sata_device.func, 1);
			printf("status: 0x%x, command: 0x%x\n", status_cmd >> 16, status_cmd & 0xffff);
			intr_pin_line = pci_conf_read_word(sata_device.bus, sata_device.dev, sata_device.func, 30);
			printf("IntrPin: %d, Line: %d\n", intr_pin_line >> 8, intr_pin_line & 0xff);

			const char *sata_type = "unknown";
			switch (sata_device.progif)
			{
			case 0x00:
				sata_type = "Vendor specific";
				break;
			case 0x01:
				sata_type = "AHCI 1.0";
				break;
			case 0x02:
				sata_type = "Serial Storage Bus";
				break;
			}
			printf("SATA Controller type: %s\n", sata_type);

			for (u32 bar = 0; bar <= 5; ++bar)
			{
				struct pci_bar_info bar_info;
				pci_decode_bar(&sata_device, bar, &bar_info);
				if (bar_info.type == PCI_BAR_TYPE_NONE)
					continue;

				printf("BAR%d: base=0x%x, size=0x%x, type=%s\n",
					   bar, bar_info.base, bar_info.size, bar_info.type == PCI_BAR_TYPE_PIO ? "PIO" : "MMIO");
			}

			if ((status_cmd >> 16) & 0x10)
			{
				u8 cap_ptr = pci_conf_read_byte(sata_device.bus, sata_device.dev, sata_device.func, 0x34);
				printf("Capabilities List Ptr=0x%x\n", cap_ptr);
				while (cap_ptr)
				{
					u16 cap = pci_conf_read_word(sata_device.bus, sata_device.dev, sata_device.func, cap_ptr >> 1);
					u8 id = cap & 0xff;
					printf("id=0x%x, next=0x%x\n", id, cap >> 8);
					if (id == 0x1)
					{
						u16 pmc = pci_conf_read_word(sata_device.bus, sata_device.dev, sata_device.func, (cap_ptr >> 1) + 1);
						u32 data_bse_pmcsr = pci_conf_read_dword(sata_device.bus, sata_device.dev, sata_device.func, (cap_ptr >> 2) + 1);
						printf("PPM: pmc=0x%x, sr=0x%x, bse=0x%x, data=0x%x\n",
							   pmc, data_bse_pmcsr & 0xffff, (data_bse_pmcsr >> 16) & 0xff, (data_bse_pmcsr >> 24) & 0xff);

						// printf("version: %d", pmc & 0x7);
						// if(pmc & 0x200) {
						// 	print_str(", D1");
						// }
						// if(pmc & 0x400) {
						// 	print_str(", D2");
						// }
						// print_str(", PME=0x%x\n", pmc >> 11);
					}
					cap_ptr = cap >> 8;
				}
			}
			getchar();
		}
	}
#endif

#if 0
	{
		struct pci_dev_info scsi_device = {
			.class = 0x1,	// Mass storage controller
			.subclass = 0x0 // SCSI
		};
		if (pci_dev_find(&scsi_device, false))
		{
			printf("bus: 0x%x, dev: 0x%x, func: 0x%x\n",
				   scsi_device.bus, scsi_device.dev, scsi_device.func);
			printf("ven: 0x%x, dev: 0x%x\n",
				   scsi_device.ven_id, scsi_device.dev_id);
			printf("class: 0x%x, subclass: 0x%x, progif: 0x%x, rev: 0x%x\n",
				   scsi_device.class, scsi_device.subclass, scsi_device.progif, scsi_device.rev);
			u32 BAR[6], reg = 0x10, subsys_ven, status_cmd;
			u16 intr_pin_line;
			subsys_ven = pci_conf_read_dword(scsi_device.bus, scsi_device.dev, scsi_device.func, 0x2c);
			printf("subsys: 0x%x, ven: 0x%x\n", subsys_ven >> 16, subsys_ven & 0xffff);
			status_cmd = pci_conf_read_dword(scsi_device.bus, scsi_device.dev, scsi_device.func, 0x4);
			printf("status: 0x%x, command: 0x%x\n", status_cmd >> 16, status_cmd & 0xffff);
			intr_pin_line = pci_conf_read_word(scsi_device.bus, scsi_device.dev, scsi_device.func, 0x3c);
			printf("IntrPin: %d, Line: %d\n", intr_pin_line >> 8, intr_pin_line & 0xff);
			const char *scsi_type = "unknown";
			switch (scsi_device.progif)
			{
			case 0x00:
				scsi_type = "controller - vendor-specific interface";
				break;
			case 0x11:
				scsi_type = "storage device - SOP_PQI";
				break;
			case 0x12:
				scsi_type = "controller - host bus adapter - SOP_PQI";
				break;
			case 0x13:
				scsi_type = "storage device and controller - SOP_PQI";
				break;
			case 0x21:
				scsi_type = "storage device - SOP_NVME";
				break;
			}
			printf("SCSI type: %s\n", scsi_type);
			for (int i = 0; i <= 5; ++i)
			{
				BAR[i] = pci_conf_read_dword(scsi_device.bus, scsi_device.dev, scsi_device.func, reg);
				if (BAR[i])
				{
					printf("BAR%d: 0x%x", i, BAR[i]);
					pci_conf_write_dword(scsi_device.bus, scsi_device.dev, scsi_device.func, reg, 0xffffffff);
					u32 base = BAR[i];
					u32 size = pci_conf_read_dword(scsi_device.bus, scsi_device.dev, scsi_device.func, reg);
					bool is_mmio = size & 1;
					if (is_mmio)
					{
						size &= ~0xf;
						base &= ~0xf;
					}
					else
					{
						size &= ~0x3;
						base &= ~0x3;
					}
					size = ~size + 1;
					printf(", base=0x%x, size=0x%x\n", base, size);
				}
				reg += 0x4;
			}
			if ((status_cmd >> 16) & 0x10)
			{
				u8 cap_ptr = pci_conf_read_byte(scsi_device.bus, scsi_device.dev, scsi_device.func, 0x34);
				printf("Capabilities List Ptr=0x%x\n", cap_ptr);
				while (cap_ptr)
				{
					u16 cap = pci_conf_read_word(scsi_device.bus, scsi_device.dev, scsi_device.func, cap_ptr);
					cap_ptr = cap >> 8;
					printf("id=0x%x, next=0x%x\n", cap & 0xff, cap_ptr);
				}
			}
			getchar();
		}
	}
#endif

#if 0
	{
		struct pci_dev_info snd_device = {
			.class = 0x4,	// Multimedia Devices
			.subclass = 0x1 // Multimedia audio controller
		};
		bool snd_device_present = true;
		if (!pci_dev_find(&snd_device, false))
		{
			snd_device.subclass = 0x3; // High Definition Audio (HD-A) 1.0 compatible
			snd_device_present = pci_dev_find(&snd_device, false);
		}
		if (snd_device_present)
		{
			printf("bus: 0x%x, dev: 0x%x, func: 0x%x\n",
				   snd_device.bus, snd_device.dev, snd_device.func);
			printf("ven: 0x%x, dev: 0x%x\n",
				   snd_device.ven_id, snd_device.dev_id);
			printf("class: 0x%x, subclass: 0x%x, progif: 0x%x, rev: 0x%x\n",
				   snd_device.class, snd_device.subclass, snd_device.progif, snd_device.rev);
			u32 subsys_ven, status_cmd;
			u16 intr_pin_line;
			subsys_ven = pci_conf_read_dword(snd_device.bus, snd_device.dev, snd_device.func, 11);
			printf("subsys: 0x%x, ven: 0x%x\n", subsys_ven >> 16, subsys_ven & 0xffff);
			status_cmd = pci_conf_read_dword(snd_device.bus, snd_device.dev, snd_device.func, 1);
			printf("status: 0x%x, command: 0x%x\n", status_cmd >> 16, status_cmd & 0xffff);
			intr_pin_line = pci_conf_read_word(snd_device.bus, snd_device.dev, snd_device.func, 30);
			printf("IntrPin: %d, Line: %d\n", intr_pin_line >> 8, intr_pin_line & 0xff);

			for (u32 bar = 0; bar <= 5; ++bar)
			{
				struct pci_bar_info bar_info;
				pci_decode_bar(&snd_device, bar, &bar_info);
				if (bar_info.type == PCI_BAR_TYPE_NONE)
					continue;

				printf("BAR%d: base=0x%x, size=0x%x, type=%s\n",
					   bar, bar_info.base, bar_info.size, bar_info.type == PCI_BAR_TYPE_PIO ? "PIO" : "MMIO");
			}

			if ((status_cmd >> 16) & 0x10)
			{
				u8 cap_ptr = pci_conf_read_byte(snd_device.bus, snd_device.dev, snd_device.func, 0x34);
				printf("Capabilities List Ptr=0x%x\n", cap_ptr);
				while (cap_ptr)
				{
					u16 cap = pci_conf_read_word(snd_device.bus, snd_device.dev, snd_device.func, cap_ptr >> 1);
					u8 id = cap & 0xff;
					printf("id=0x%x, next=0x%x\n", id, cap >> 8);
					if (id == 0x1)
					{
						u16 pmc = pci_conf_read_word(snd_device.bus, snd_device.dev, snd_device.func, (cap_ptr >> 1) + 1);
						u32 data_bse_pmcsr = pci_conf_read_dword(snd_device.bus, snd_device.dev, snd_device.func, (cap_ptr >> 2) + 1);
						printf("PPM: pmc=0x%x, sr=0x%x, bse=0x%x, data=0x%x\n",
							   pmc, data_bse_pmcsr & 0xffff, (data_bse_pmcsr >> 16) & 0xff, (data_bse_pmcsr >> 24) & 0xff);

						// printf("version: %d", pmc & 0x7);
						// if(pmc & 0x200) {
						// 	print_str(", D1");
						// }
						// if(pmc & 0x400) {
						// 	print_str(", D2");
						// }
						// print_str(", PME=0x%x\n", pmc >> 11);
					}
					cap_ptr = cap >> 8;
				}
			}
			getchar();
		}
	}

#endif

#if 0
	// getchar();

	// char buffer[512] = {"1234567890"};

	// ide_read_write_sectors(0, 0, 0, true, 1, buffer);

	u8 *buffer = alloc_page(PAGE_SIZE, normal_phy_mem);
	do
	{
		int err = ide_read_write_sectors(0, 0, 0, false, 1, buffer);
		if (err)
		{
			printf("ide_read_write_sectors(read) returned %d\n", err);
			break;
		}

		struct riff_chunk_header *file_header = (struct riff_chunk_header *)buffer;
		struct riff_file_chunk *file_chunk = (struct riff_file_chunk *)(file_header + 1);
		if (file_header->id != RIFF_CHUNK_ID_RIFF || file_chunk->format != RIFF_FILE_CHUNK_FORMAT_WAVE)
		{
			printf("not a valid WAVE file!\n");
			break;
		}

		struct wave_format_chunk *wave_format = NULL;
		struct riff_chunk_header *ptr = (struct riff_chunk_header *)(file_chunk + 1);
		while (ptr->id != RIFF_CHUNK_ID_DATA)
		{
			if (ptr->id == RIFF_CHUNK_ID_FORMAT)
			{
				wave_format = (struct wave_format_chunk *)(ptr + 1);
			}
			ptr = (struct riff_chunk_header *)((u8 *)(ptr + 1) + ptr->size);
		}

		if (!wave_format)
		{
			printf("not a valid WAVE file!\n");
			break;
		}

		printf("file_size: 0x%x\naudio_size: 0x%x\n", file_header->size, ptr->size);
		printf("channels: %d\nsample_rate: %d\nbyte_rate: 0x%x\nblock_align: 0x%x\nbits_per_sample: %d\n",
			   wave_format->channels, wave_format->sample_rate, wave_format->byte_rate,
			   wave_format->block_align, wave_format->bits_per_sample);

		// u16 freq = wave_format->sample_rate;
		// bool is_16bits = wave_format->bits_per_sample == 16;
		// bool is_stereo = wave_format->channels == 2;
		// free_page(buffer);

		// u32 offset = (void *)(ptr + 1) - (void *)buffer;
		u32 offset = 0;
		u32 count = (file_header->size + 511) / 512;
		u32 size = count * 512;
		u32 _255_count = count / 255;
		u32 lba = 0;
		void *audio_data = alloc_page(size, normal_phy_mem);
		// memcpy(audio_data, (void *)(ptr + 1) + offset, 512 - offset);
		// offset = 512 - offset;
		count %= 255;
		printf("%d, %d\n", _255_count, count);
		// bool ok = true;
		for (u32 i = 0; i < _255_count; ++i)
		{
			err = ide_read_write_sectors(0, 0, lba, false, 255, audio_data + offset);
			if (err)
			{
				printf("ide_read_write_sectors(read) returned %d\n", err);
				break;
			}
			offset += 512 * 255;
			lba += 255;
			print_char('#');
		}

		if (!err)
		{
			err = ide_read_write_sectors(0, 0, lba, false, count, audio_data + offset);
			if (err)
			{
				printf("ide_read_write_sectors(read) returned %d\n", err);
				break;
			}
			print_char('*');
		}

		if (err)
		{
			free_page(audio_data);
			break;
		}

		offset = (void *)(ptr + 1) - (void *)buffer;
		print_str("\npress any start playback!");
		getchar();
#if 1
		if (!sb16_play(audio_data + offset, ptr->size, wave_format->sample_rate, wave_format->bits_per_sample == 16, wave_format->channels == 2))
		{
			printf("sb16_play failed!\n");
		}
#else
		if (!es1370_play(audio_data + offset, ptr->size, wave_format->sample_rate, wave_format->bits_per_sample, wave_format->channels))
		{
			printf("es1370_play failed!\n");
		}
#endif
		free_page(audio_data);
		print_str("stop playback!\n");

		// printf("\nstart playback!\n");
	} while (false);

	if (buffer)
	{
		free_page(buffer);
		buffer = NULL;
	}
#endif

#if 0
	double PI = 3.5;
	for (int i = 0; i < 4; ++i)
	{
		print_hex(((u8 *)&PI)[i], 2);
	}
	print_char('\n');
	PI *= 2;
	for (int i = 0; i < 4; ++i)
	{
		print_hex(((u8 *)&PI)[i], 2);
	}
	print_char('\n');

	time.year /= 0;


	print_str("Press Y shutdown system.!\n");
	if (getchar() == 'Y')
	{
		apm_shutdown();
	}
#endif

	u32 EbdaAddr = (u32)(*(volatile const u16 *)0x40E) << 4;
	u32 BaseMemSize = (u32)(*(volatile const u16 *)0x413) * 1024;
	printf("EBDA Addr  =0x%x\n", EbdaAddr);
	printf("BaseMemSize=0x%x\n\n", BaseMemSize);

	mpfp_s *mpfp_ptr = MpfpSearch(EbdaAddr, 1024);
	if (!mpfp_ptr)
		mpfp_ptr = MpfpSearch(BaseMemSize - 1024, 1024);
	if (!mpfp_ptr)
		mpfp_ptr = MpfpSearch(0xE0000, 0x20000);
	if (!mpfp_ptr)
	{
		printf("MPFP not found!\n");
		getchar();
	}
	else
	{
		printf("MPFP Addresss=0x%x\n", mpfp_ptr);
		printf("MPCFG Address=0x%x\n", mpfp_ptr->MpCfgAddress);
		printf("Revision     =%d\n", mpfp_ptr->Revision);
		printf("MPCFG Type   =%d\n", mpfp_ptr->MpCfgType);
		printf("Feature      =0x%x, %s\n", mpfp_ptr->Feature,
			   mpfp_ptr->Feature & 0x80 ? "IMCR(PIC Mode)" : "Virtual Wire Mode");
		if (!mpfp_ptr->MpCfgAddress || mpfp_ptr->MpCfgType)
		{
			printf("MPCFG not present!\n");
			getchar();
		}
		else
		{
			getchar();
			WalkMpct(mpfp_ptr);
		}
	}

	xsdp_t *xsdp_ptr = AcpiSearch(EbdaAddr, 1024);
	if (!xsdp_ptr)
		xsdp_ptr = AcpiSearch(0xE0000, 0x20000);
	if (!xsdp_ptr)
	{
		printf("RSDP(XSDP) not found!\n");
		getchar();
	}
	else
	{
		char buf[7];
		memcpy(buf, xsdp_ptr->Rsdp.OemId, 6);
		buf[6] = 0;
		printf("RSDP    =0x%x\n", xsdp_ptr);
		printf("OemId   =%s\n", buf);
		printf("Revision=%d\n", xsdp_ptr->Rsdp.Revsion);
		printf("RSDT    =0x%x\n", xsdp_ptr->Rsdp.RsdtAddress);
		if (xsdp_ptr->Rsdp.Revsion == 2)
		{
			printf("Length  =%d\n", xsdp_ptr->Length);
			printf("XSDT    =0x%x_%x\n", xsdp_ptr->XsdtAddress[1], xsdp_ptr->XsdtAddress[0]);
		}
		getchar();

		WalkSdt(xsdp_ptr);
	}

	smbios_eps_t *SmbiosEpsPtr = SmbiosSearch();
	if (!SmbiosEpsPtr)
	{
		printf("Suitable SMBIOS not found!\n");
	}
	else
	{
		printf("SMBIOS EPS       =0x%x\n", SmbiosEpsPtr);
		printf("Version          =%d.%d\n", SmbiosEpsPtr->MajorVersion, SmbiosEpsPtr->MinorVersion);
		printf("EPS Revision     =%d\n", SmbiosEpsPtr->EpsRevision);
		printf("MaxStructureSize =%d\n", SmbiosEpsPtr->MaxStructureSize);
		printf("StructureLength  =%d\n", SmbiosEpsPtr->StructureLength);
		printf("NumberOfStructure=%d\n", SmbiosEpsPtr->NumberOfStructure);
		printf("StructureAddress =0x%x\n", SmbiosEpsPtr->StructureAddress);
		printf("SmbiosBcdRevison =%x\n", SmbiosEpsPtr->SmbiosBcdRevison);
		getchar();

		WalkSmbios(SmbiosEpsPtr);
	}

	for (;;)
		getchar();
	// year /= 0;
	disable();
	halt();
}
