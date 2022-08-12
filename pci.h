#ifndef _PCI_H_
#define _PCI_H_ 1

/**
 * https://pci-ids.ucw.cz/
 * https://mj.ucw.cz/sw/pciutils/
 * https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/comet-lake-u/intel-400-series-chipset-on-package-platform-controller-hub-register-database/high-definition-audio-d31-f3-pci-configuration-registers/
 * https://docs.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/ns-wdm-_pci_capabilities_header
 * PCI Specification 3.0
 **/

#include "types.h"

#define PCI_PORT_CONF_ADDR 0x0CF8
#define PCI_PORT_CONF_DATA 0x0CFC

#define PCI_DEV_TYPE_DEVICE         0x0
#define PCI_DEV_TYPE_PCI2PCI_BRIDGE 0x1
#define PCI_DEV_TYPE_CARDBUS_BRIDGE 0x2
#define PCI_DEV_TYPE_MULTI_FUNCTION 0x80

#define PCI_BAR_TYPE_NONE   0x0
#define PCI_BAR_TYPE_PIO    0x1
#define PCI_BAR_TYPE_MMIO   0x2

struct pci_configuration
{
    u16 version;
    u8 hw_mechanism;
    u8 last_bus;
    bool present;
} __attribute__((packed));

struct pci_bar_info
{
    u8 type;
    u32 base;
    u32 size;

    bool mmio_64bits;
    u64 size64;
};

struct pci_dev_info
{
    u32 bus;
    u32 dev;
    u32 func;

    u8 type;
    bool mf;

    u16 ven_id;
    u16 dev_id;
    u8 rev;
    u8 class;
    u8 subclass;
    u8 progif;
};

void pci_setup(struct pci_configuration *info);
u8 pci_conf_read_byte(u32 bus, u32 dev, u32 func, u32 idx);
u16 pci_conf_read_word(u32 bus, u32 dev, u32 func, u32 idx);
u32 pci_conf_read_dword(u32 bus, u32 dev, u32 func, u32 idx);
void pci_conf_write_byte(u32 bus, u32 dev, u32 func, u32 idx, u8 val);
void pci_conf_write_word(u32 bus, u32 dev, u32 func, u32 idx, u16 val);
void pci_conf_write_dword(u32 bus, u32 dev, u32 func, u32 idx, u32 val);
bool pci_dev_find(struct pci_dev_info *info, bool by_id);
void pci_decode_bar(const struct pci_dev_info *dev_info, u32 bar, struct pci_bar_info *bar_info);

#endif
