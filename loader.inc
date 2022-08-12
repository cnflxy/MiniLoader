%ifndef _LOADER_INC_
%define _LOADER_INC_ 1

STRUC LoaderParameter
    .SectorsPerTrack:   resw 1
    .NumberHeads:       resw 1
    .CyliderCount:      resw 1

    .DriveNumber:       resb 1
    .BytesPerSector:    resw 1
    .SectorsPerCluster: resb 1
    .TotalSectors:      resd 1
    
    .FatStartSector:        resd 1  ; LBA (0 based)
    .FatSectors:            resd 1
    .RootDirStartSector:    resd 1  ; LBA (0 based)
    .RootDirSectors:        resd 1
    .DataStartSector:       resd 1  ; LBA (0 based)
    ; .DataSectors:           resd 1

    .LoaderSize:    resd 1
ENDSTRUC

%define DIR_ENTRY_LAST_AND_UNUSED   0x0
%define DIR_ENTRY_UNUSED            0xE5

%define FAT_ENTRY_FREE                      0x0
%define FAT_ENTRY_DEFECTIVE_CLUSTER         0xfff7
%define FAT_ENTRY_RESERVED_TO_END           0xfff8
%define FAT_ENTRY_ALLOCATED_AND_END_OF_FILE 0xffff

%define CR0_PE  0x1
%define CR0_MP  0x2
%define CR0_EM  0x4
%define CR0_TS  0x8
%define CR0_NE  0x20
%define CR0_WP  0x10000
%define CR0_AM  0x40000


%endif
