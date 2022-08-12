#include "gdt.h"

void gdt_set_entry(u32 seg, const struct gdt_entry *entry)
{
    struct gdt_ptr48 gdt_ptr;
    sgdt(&gdt_ptr);

    u16 *entry_ptr = (u16*)(gdt_ptr.base + (seg << 3));
    entry_ptr[0] = entry->limit;
	entry_ptr[1] = entry->base;
	entry_ptr[2] = ((entry->attr & 0xff) << 8) | ((entry->base >> 16) & 0xff);
	entry_ptr[3] = ((entry->base >> 16) & 0xff00) | ((entry->attr >> 4) & 0xf0) | (entry->limit >> 16);
}

void gdt_get_entry(u32 seg, struct gdt_entry *entry)
{
    struct gdt_ptr48 gdt_ptr;
    sgdt(&gdt_ptr);

    u32 *entry_ptr = (u32*)(gdt_ptr.base + (seg << 3));
    entry->base = (entry_ptr[0] >> 16) | (entry_ptr[1] & 0xff000000) | ((entry_ptr[1] << 16) & 0xff0000);
    entry->limit = (entry_ptr[0] & 0xffff) | (entry_ptr[1] & 0xf0000);
    entry->attr = ((entry_ptr[1] >> 8) & 0xff) | ((entry_ptr[1] >> 16) & 0xf00);
}
