#ifndef _DISK_H_
#define _DISK_H_ 1

#include "types.h"

struct disk_geomtery {
    u32 cylinders;
    u32 tracks;
    u32 sectors;
    u32 sector_size;
};

#endif
