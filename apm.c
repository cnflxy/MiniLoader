#include "apm.h"
#include "gdt.h"
#include "segment.h"
#include "console.h"

static bool _present;
static u32 _entrypoint;
static u16 _version;

extern u32 apm_entry_call(u32 seg, u32 entrypoint, u32 func, u32 devid, u32 pstate);

void apm_setup(const struct apm_configuration *info)
{
    if(info->ok) {
        struct gdt_entry entry;
        // gdt_get_entry(APM_CS16, &entry);
        entry.base = info->cs16_base;
        entry.limit = info->cs16_size;
        entry.attr = SEG_CODE_XR | SEG_PRESENT | SEG_DPL_KERNEL;
        gdt_set_entry(APM_CS16, &entry);

        entry.base = info->cs32_base;
        entry.limit = info->cs32_size;
        entry.attr = SEG_CODE_XR | SEG_PRESENT | SEG_DPL_KERNEL | SEG_32BITS;
        gdt_set_entry(APM_CS32, &entry);

        entry.base = info->ds_base;
        entry.limit = info->ds_size;
        entry.attr = SEG_DATA_RW | SEG_PRESENT | SEG_DPL_KERNEL | SEG_32BITS;
        gdt_set_entry(APM_DS, &entry);

        _entrypoint = info->entry_point;
        _version = info->version;
        _present = true;
    }
}

bool apm_shutdown(void)
{
    if(_present) {
        u32 err = apm_entry_call(APM_CS32 << 3, _entrypoint, 0x7, 0x1, 0x3);
        // printf("%s - apm_entry_call failed - 0x%x\n", __func__, err);
        // err = apm_entry_call(APM_CS32 << 3, _entrypoint, 0x7, 0x1, 0x2);
        // printf("%s - apm_entry_call failed - 0x%x\n", __func__, err);
        // err = apm_entry_call(APM_CS32 << 3, _entrypoint, 0x7, 0x1, 0x1);
        // printf("%s - apm_entry_call failed - 0x%x\n", __func__, err);
        // err = apm_entry_call(APM_CS32 << 3, _entrypoint, 0x5, 0, 0);
        // printf("%s - apm_entry_call failed - 0x%x\n", __func__, err);
        return true;
    }
    return false;
}
