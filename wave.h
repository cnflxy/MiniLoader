#ifndef _WAV_H_
#define _WAV_H_ 1

#include "types.h"

struct riff_chunk_header
{
    u32 id;
    u32 size;
} __attribute__((packed));

struct riff_file_chunk
{
    u32 format;
} __attribute__((packed));

struct wave_format_chunk
{
    u16 format;
    u16 channels;
    u32 sample_rate;
    u32 byte_rate;
    u16 block_align;
    u16 bits_per_sample;
} __attribute__((packed));

#define RIFF_FILE_CHUNK_FORMAT_WAVE 0x45564157 // 'WAVE'

#define RIFF_CHUNK_ID_RIFF 0x46464952   // 'RIFF'
#define RIFF_CHUNK_ID_FORMAT 0x20746D66 // 'fmt '
#define RIFF_CHUNK_ID_DATA 0x61746164   // 'data'

#endif
