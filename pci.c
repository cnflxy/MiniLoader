#include "pci.h"
#include "io.h"
#include "cpu.h"

static struct pci_configuration *_pci_conf;

void pci_setup(struct pci_configuration *info)
{
    _pci_conf = info;

    if (!_pci_conf->present)
        _pci_conf->last_bus = 255;
}

u8 pci_conf_read_byte(u32 bus, u32 dev, u32 func, u32 idx)
{
    u8 data;
    u32 tmp = pci_conf_read_dword(bus, dev, func, idx >> 2);
    data = ((u8 *)&tmp)[idx & 0x3];
    return data;
}

u16 pci_conf_read_word(u32 bus, u32 dev, u32 func, u32 idx)
{
    u16 data;
    u32 tmp = pci_conf_read_dword(bus, dev, func, idx >> 1);
    data = ((u16 *)&tmp)[idx & 0x1];
    return data;
}

u32 pci_conf_read_dword(u32 bus, u32 dev, u32 func, u32 idx)
{
    if (bus > _pci_conf->last_bus || dev > 31 || func > 7 || idx > 63)
        return -1;

    u32 addr = 0x80000000 | bus << 16 | dev << 11 | func << 8 | idx << 2;
    u32 save_eflags = read_eflags();
    disable();
    port_write_dword(PCI_PORT_CONF_ADDR, addr);
    u32 data = port_read_dword(PCI_PORT_CONF_DATA);
    write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    return data;
}

void pci_conf_write_byte(u32 bus, u32 dev, u32 func, u32 idx, u8 val)
{
    u32 data = pci_conf_read_dword(bus, dev, func, idx >> 2);
    // if (data == -1)
    //     return;
    u8 *ptr = (u8 *)&data;
    ptr[idx & 0x3] = val;
    pci_conf_write_dword(bus, dev, func, idx >> 2, data);
}

void pci_conf_write_word(u32 bus, u32 dev, u32 func, u32 idx, u16 val)
{
    u32 data = pci_conf_read_dword(bus, dev, func, idx >> 1);
    // if (data == -1)
    //     return;
    u16 *ptr = (u16 *)&data;
    ptr[idx & 0x1] = val;
    pci_conf_write_dword(bus, dev, func, idx >> 1, data);
}

void pci_conf_write_dword(u32 bus, u32 dev, u32 func, u32 idx, u32 val)
{
    if (bus > _pci_conf->last_bus || dev > 31 || func > 7 || idx > 63)
        return;

    u32 addr = 0x80000000 | bus << 16 | dev << 11 | func << 8 | idx << 2;
    u32 save_eflags = read_eflags();
    disable();
    port_write_dword(PCI_PORT_CONF_ADDR, addr);
    port_write_dword(PCI_PORT_CONF_DATA, val);
    write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
}

bool pci_dev_find(struct pci_dev_info *info, bool by_id)
{
    u32 target = by_id ? info->dev_id << 16 | info->ven_id : info->class << 8 | info->subclass;
    u16 bus, dev, func;
    bool mf, found = false;

    for (bus = 0; bus <= _pci_conf->last_bus; ++bus)
    {
        for (dev = 0; dev <= 31; ++dev)
        {
            mf = false;
            for (func = 0; func <= 7; ++func)
            {
                u32 dev_ven = pci_conf_read_dword(bus, dev, func, 0x0);
                if ((dev_ven & 0xffff) == 0xffff)
                    continue;
                u8 htype = pci_conf_read_byte(bus, dev, func, 0xe);
                if ((htype & 0x7f) > 2)
                    continue;
                if (!mf)
                    mf = (htype & 0x80) == 0x80;

                u32 class_rev;
                if (by_id)
                {
                    if (dev_ven == target)
                    {
                        class_rev = pci_conf_read_dword(bus, dev, func, 0x2);
                        found = true;
                    }
                }
                else
                {
                    class_rev = pci_conf_read_dword(bus, dev, func, 0x2);
                    if ((class_rev >> 16) == target)
                        found = true;
                }

                if (found)
                {
                    info->bus = bus;
                    info->dev = dev;
                    info->func = func;
                    info->mf = (htype & 0x80) == 0x80;
                    info->type = htype & 0x7f;
                    info->dev_id = dev_ven >> 16;
                    info->ven_id = dev_ven & 0xffff;
                    info->class = class_rev >> 24;
                    info->subclass = (class_rev >> 16) & 0xff;
                    info->progif = (class_rev >> 8) & 0xff;
                    info->rev = class_rev & 0xff;
                    return true;
                }

                if (!mf)
                    break;
            }
        }
    }

    return false;
}

void pci_decode_bar(const struct pci_dev_info *dev_info, u32 bar, struct pci_bar_info *bar_info)
{
    bar_info->type = PCI_BAR_TYPE_NONE;

    if (bar > 5)
        return;

    u32 idx = 4 + bar;

    u32 base = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, idx);
    if ((base & 0x2) == 0x2)
        return;

    if ((base & 0x1) == 0x1)
    {
        pci_conf_write_dword(dev_info->bus, dev_info->dev, dev_info->func, idx, 0xffffffff);
        u32 size = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, idx);
        size = ~(size & 0xfffffffc) + 1;
        if (size > 256)
            return;
        pci_conf_write_dword(dev_info->bus, dev_info->dev, dev_info->func, idx, base);
        if (pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, idx) != base)
            return;
        bar_info->base = base & 0xfffffffc;
        bar_info->size = size;
        bar_info->type = PCI_BAR_TYPE_PIO;
    }
    else
    {
        // only support Type 0 Configuration
        pci_conf_write_dword(dev_info->bus, dev_info->dev, dev_info->func, idx, 0xffffffff);
        u32 size_low = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, idx);
        if(size_low == 0) return;
        if((size_low & 0x4) == 0x4) {
            pci_conf_write_dword(dev_info->bus, dev_info->dev, dev_info->func, idx + 1, 0xffffffff);
            u32 size_hi = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, idx + 1);
            // if(size_hi == 0) return;
            u64 size = (u64)size_hi << 32 | (size_low & 0xfffffff0);
            size = ~size + 1;
            if(size == 0) return;
            bar_info->size = 0;
            bar_info->size64 = size;
            bar_info->mmio_64bits = true;
        } else {
            size_low = ~(size_low & 0xfffffff0) + 1;
            if(size_low == 0) return;
            bar_info->size64 = 0;
            bar_info->mmio_64bits = false;
            bar_info->size = size_low;
        }

        bar_info->base = 0;
        // bar_info->size = 0;
        bar_info->type = PCI_BAR_TYPE_MMIO;
        // bar_info->base = base & 0xfffffff0;
        // bar_info->size = ~(size & 0xfffffff0) + 1;
    }
}
