%include "loader.inc"

ORG 0x7c00
[BITS 16]

BS_jmpBoot:
    ; jmp     near BS_BootCodeStart ; e9xxxx
    jmp     short BS_BootCodeStart  ; ebxx
    nop

BS_OEMName:     db "MiniLdr "   ; 3 - 8 bytes
; BPB (BIOS Parameter Block)
BPB_BytsPerSec: dw 0x200    ; 11
BPB_SecPerClus: db 0x1      ; 13    ; 1.44MB - 0x1, 2.88MB - 0x2
BPB_RsvdSecCnt: dw 0x1      ; 14
BPB_NumFATs:    db 0x2      ; 16
BPB_RootEntCnt: dw 0xe0     ; 17    ; 1.44MB - 0xe0 (224) - 14 sectors, 2.88MB - 0xf0 (240) - 15 sectors
BPB_TotSec16:   dw 0xb40    ; 19    ; 1.44MB - 0xb40 (2880), 2.88MB - 0x1680 (5760)
BPB_Media:      db 0xf0     ; 21
BPB_FATSize16:  dw 0x9      ; 22
BPB_SecPerTrk:  dw 0x12     ; 24    ; 1.44MB - 0x12, 2.88MB - 0x24
BPB_NumHeads:   dw 0x2      ; 26
BPB_HiddenSec:  dd 0        ; 28
BPB_TotSec32:   dd 0        ; 32
; FAT12/16
BS_DriveNum:    db 0        ; 36
BS_Reserved1:   db 0        ; 37
BS_ExtBootSig:  db 0x29     ; 38
BS_VolumeID:    dd 0        ; 39
BS_VolumeLab:   db "MiniOS v01 "    ; 43 - 11 bytes
BS_FSType:      db "FAT12   "       ; 54 - 8 bytes   // actually the fs type not depend this
; FAT12/16
; FAT=File Allocate Table
; 12=every cluster offset size in FAT is 12bits


BS_BootCodeStart:
    ; cli
    
    xor     ax, ax
    mov     ds, ax
    ; mov     es, ax
    mov     ss, ax
    mov     sp, 0x1000 - LoaderParameter_size
    mov     bp, sp

    ; mov     si, 0x7c00
    ; mov     di, 0x600
    ; mov     cx, 0x100
    ; cld
    ; rep     movsw

    ; db 0xe9
    ; dw 0x600 - 0x7c00
    ; jmp     near 0x600 - 0x7c00 + BS_BootCodeStart_Relocate   ; ORG 0x600
    ; jmp     0x0: word BS_BootCodeStart_Relocate

; BS_BootCodeStart_Relocate:
    mov     [bp + LoaderParameter.DriveNumber], dl

    ; reset disk controller
    ; int     0x13
    ; jc      _BootFailed

    ; xor     di, di  ; some buggy BIOS need this(ES:DI=0000h:0000h) but we don't need it
    mov     ah, 8
    int     0x13
    jnc     _GetLoaderParam
    mov     cx, 0xffff
    mov     dh, cl

_GetLoaderParam:
    ; CHS (Cylider-Head-Sector)
    ; C: 0-1023
    ; H: 0-255
    ; S: 1-63
    movzx   eax, dh
    inc     ax
    mov     [bp + LoaderParameter.NumberHeads], ax

    ; ch[0..7] = CyliderCount[0..7]
    ; cl[6..7] = CyliderCount[8..9]
    ; cl[0..5] = SectorsPerTrack[0..5]
    mov     bl, ch
    mov     bh, cl
    shr     bh, 6
    inc     bx  ; CyliderCount
    mov     [bp + LoaderParameter.CyliderCount], bx
    mul     bx

    mov     es, dx

    and     ecx, 0x3f
    mov     [bp + LoaderParameter.SectorsPerTrack], cx
    mul     ecx
    
    ; TotalSectors = CyliderCount * NumberHeads * SectorsPerTrack
    mov     [bp + LoaderParameter.TotalSectors], eax

    ; FatStartSector = BPB_RsvdSecCnt
    movzx   ebx, word [BPB_RsvdSecCnt]
    mov     [bp + LoaderParameter.FatStartSector], ebx

    ; FatSectors = BPB_FATSize16 * BPB_NumFATs
    movzx   eax, word [BPB_FATSize16]
    mov     [bp + LoaderParameter.FatSectors], eax
    mov     cl, [BPB_NumFATs]
    mul     ecx

    ; RootDirStartSector = FatStartSector + FatSectors
    add     ebx, eax
    mov     [bp + LoaderParameter.RootDirStartSector], ebx

    ; RootDirSectors = (BPB_RootEntCnt * 32 + BytesPerSector - 1) / BytesPerSector
    movzx   eax, word [BPB_RootEntCnt]
    mov     cl, 0x20
    mul     ecx
    shl     cx, 4
    mov     [bp + LoaderParameter.BytesPerSector], cx
    add     eax, ecx
    dec     eax
    div     ecx
    mov     [bp + LoaderParameter.RootDirSectors], eax
    push    eax ; [bp - 4]

    ; DataStartSector = RootDirStartSector + RootDirSectors
    add     eax, ebx
    mov     [bp + LoaderParameter.DataStartSector], eax

    ; ebx = RootDirStartSector
    push    ebx
    pop     ax
    pop     dx

    ; mov     cx, [bp + LoaderParameter.RootDirSectors]
    ; mov     bx, 0x100
    ; mov     es, bx
_ReadRootDirSector:
    mov     bx, 0x1000
    ; xor     bx, bx
    call    ReadSector
    jc      _BootFailed

_LookupLoaderDirEntry:
    cmp     byte [es:bx], DIR_ENTRY_LAST_AND_UNUSED
    je      _BootFailed
    cmp     byte [es:bx], DIR_ENTRY_UNUSED
    je      .Next
    mov     si, LoaderImageName
    mov     di, bx
    mov     cx, 11
    repe    cmpsb
    je      _LoaderFound
.Next:
    add     bx, 0x20
    cmp     bx, 0x1200
    jne     _LookupLoaderDirEntry

    inc     ax
    adc     dx, 0
    dec     dword [bp - 4]
    jnz     _ReadRootDirSector
    jmp     _BootFailed

_LoaderFound:
    pop     eax
    ; get first cluster
    mov     ax, [es:bx + 26]    ; DIR_FstClusLO
    cmp     ax, 2
    jb      _BootFailed
    mov     di, ax

    dec     ax
    dec     ax
    add     ax, [bp + LoaderParameter.DataStartSector]
    xor     dx, dx
    adc     dx, [bp + LoaderParameter.DataStartSector + 2]
    mov     cl, [BPB_SecPerClus]
    mov     [bp + LoaderParameter.SectorsPerCluster], cl

    mov     bx, [bp + LoaderParameter.BytesPerSector]
    shr     bx, 4
    push    bx  ; [bp - 2]
    mov     bx, 0x1000
    push    bx  ; [bp - 4]
    mov     es, bx
_ReadLoaderFirstCluster:
    xor     bx, bx
    call    ReadSector
    jc      _BootFailed
    mov     bx, [bp - 2]
    push    es  ; [bp - 6]
    add     [bp - 6], bx
    pop     es
    inc     ax
    adc     dx, 0
    loop    _ReadLoaderFirstCluster

    pop     es
    pop     ax
    cmp     word [es:0x2], 0xaa55
    jne     _BootFailed

    xor     si, si  ; isFAT32
    call    0x1000:0

_BootFailed:
_DispStr:
    mov     si, MsgBootFailure
    mov     ah, 0xe
    mov     bx, 0x7
_DispStr__Loop:
    lodsb
    test    al, al
    jz      _DispStr__Exit
    int     0x10
    jmp     _DispStr__Loop

_DispStr__Exit:

    xor     ah, ah
    int     0x16
    int     0x19

    ; jmp $

; es:bx: buf addr, ax:dx: begin sector
ReadSector:
    pusha
    ; device address packet
    push    dword 0 ;} - logical block address (LBA)
    push    dx      ;}
    push    ax      ;}
    push    es      ;} - address of buffer(form Seg:Offset)
    push    bx      ;}
    push    word 1  ;} - count
    push    word 16 ;} - packet size

    mov     si, sp

    ; cmp     dx, [bp + LoaderParameter.TotalSectors + 2]
    ; ja      _ReadSector_LBA
    ; jb      _ReadSector_CHS
    ; cmp     ax, [bp + LoaderParameter.TotalSectors]
    ; ja      _ReadSector_LBA

    .LBA:
    pusha
    mov     ah, 0x41
    mov     bx, 0x55aa
    mov     dl, [bp + LoaderParameter.DriveNumber]
    int     0x13
    jc      .CHS
    cmp     bx, 0xaa55
    jne     .CHS
    ; test    cx, 0xF8
    ; jnz     _ReadSector_Failed
    test    cl, 1
    jz      .CHS

    mov     ah, 0x42
    mov     dl, [bp + LoaderParameter.DriveNumber]
    int     0x13
    jc      .CHS
    popa
    jmp     .Exit

    ; push    dx
    ; push    ax
    ; pop     ecx
    ; cmp     ecx, [bp + LoaderParameter.TotalSectors]
    ; jae     .LBA

.CHS:
    popa
    ; LBA / SPT
    div     word [bp + LoaderParameter.SectorsPerTrack]

    ; S = (LBA % SPT) + 1
    mov     cl, dl
    inc     cl
    ; and     cl, 0x3f

    ; (LBA / SPT) / NH
    xor     dl, dl
    div     word [bp + LoaderParameter.NumberHeads]

    ; H = (LBA / SPT) % NH
    mov     dh, dl

    ; C = (LBA / SPT) / NH
    mov     ch, al
    shl     ah, 6
    or      cl, ah

    mov     ax, 0x201
    mov     dl, [bp + LoaderParameter.DriveNumber]
    int     0x13

.Exit:

    popa
    popa
    ret

LoaderImageName: db "LOADER  MNS"

MsgBootFailure: db `\r\n`
                db "Boot failed!"
MsgPressAnyKey: db `\r\n`
                db "Press any key to restart"
                db 0

TIMES 510 - ($ - $$) db 0
BS_BootSignature:   db 0x55, 0xaa
