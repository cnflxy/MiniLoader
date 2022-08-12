#ifndef _APM_H_
#define _APM_H_ 1

#include "types.h"

struct apm_configuration {
	u16 version;
	u8 original_flags;
	u32 cs32_base;  // 32-bits Code Segment Base
	u16 cs32_size;  // 32-bits Code Segment Size
	u32 cs16_base;  // 16-bits Code Segment Base
	u16 cs16_size;  // 16-bits Code Segment Size
	u32 ds_base;    // Data Segment Base
	u16 ds_size;    // Data Segment Size
	u32 entry_point;    // Entry Point Offset in 32-bits Code Segment
	bool ok;
} __attribute__((packed));

void apm_setup(const struct apm_configuration *info);
bool apm_shutdown(void);

#endif
