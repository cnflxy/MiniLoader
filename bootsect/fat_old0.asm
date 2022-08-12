%include "loader.inc"

ORG 0x7C00
USE16

    jmp     BS_BootCodeStart
    nop

BS_OEMName:     db "MiniLdr "   ; 3   ; 8 bytes
BPB_BytsPerSec: dw 0x200    ; 11
BPB_SecPerClus: db 0x1  ; 13
BPB_RsvdSecCnt: dw 0x1  ; 14
BPB_NumFATs:    db 0x2  ; 16
BPB_RootEntCnt: dw 0xE0 ; 17
BPB_TotSec16:   dw 0xB40    ; 19    ; aways 1.44MB Floppy Disk
BPB_Media:      db 0xF0 ; 21
BPB_FATSize16:  dw 0x9  ; 22
BPB_SecPerTrk:  dw 0x12 ; 24
BPB_NumHeads:   dw 0x2  ; 26
BPB_HiddenSec:  dd 0    ; 28
BPB_TotSec32:   dd 0    ; 32
; FAT12/16
BS_DriveNum:    db 0    ; 36
BS_Reserved1:   db 0    ; 37
BS_ExtBootSig:  db 0x29 ; 38
BS_VolumeID:    dd 0    ; 39
BS_VolumeLab:   db "MiniOS v01 "    ; 43    ; 11 bytes
BS_FSType:      db "FAT12   "       ;54     ; 8 bytes   // actually the fs type not depend this
; FAT12/16
; FAT=File Allocate Table
; 12=every cluster offset size in FAT is 12bits


BS_BootCodeStart:
    cli
    cld

    xor     ax, ax
    mov     ds, ax
    mov     es, ax
    mov     ss, ax
    mov     sp, 0x1000 - _LoaderParam_size
    mov     bp, sp
    ; sti

    ; xor     dh, dh
    mov     [bp + _LoaderParam.DriveNumber], dl

    ; reset disk controller
    int     0x13
    jc      _BootFailed

    xor     di, di  ; some buggy BIOS need this(ES:DI=0000h:0000h)
    mov     ah, 8
    int     0x13
    jnc     _GetLoaderParam
    mov     cx, 0xFFFF
    mov     dh, cl

_GetLoaderParam:
    mov     al, dh
    ; movzx   eax, al
    inc     ax
    mov     [bp + _LoaderParam.NumberHeads], ax

    mov     bh, cl
    mov     bl, ch
    shr     bh, 6
    ; movzx   ebx, bx
    inc     bx  ; CyliderCount

    and     cx, 0x003F
    ; xor     ch, ch
    ; movzx   ecx, cl
    mov     [bp + _LoaderParam.SectorsPerTrack], cx

    mul     cx  ; dx:ax = ax * cx
    mov     cx, dx
    mul     bx  ; dx:ax = ax * bx
    mov     [bp + _LoaderParam.TotalSectors], ax
    mov     ax, cx
    mov     cx, dx
    mul     bx
    add     ax, cx
    mov     [bp + _LoaderParam.TotalSectors + 2], ax

    mov     word [bp + _LoaderParam.BytesPerSector], 0x200

    mov     bx, [BPB_RsvdSecCnt]
    mov     [bp + _LoaderParam.FatStartSector], bx
    xor     ax, ax
    mov     [bp + _LoaderParam.FatStartSector + 2], ax

    mov     al, [BPB_NumFATs]
    mov     cx, [BPB_FATSize16]
    mul     cx
    mov     [bp + _LoaderParam.FatSectors], ax
    mov     [bp + _LoaderParam.FatSectors + 2], dx

    add     ax, bx
    adc     dx, 0
    mov     [bp + _LoaderParam.RootDirStartSector], ax
    mov     [bp + _LoaderParam.RootDirStartSector + 2], dx
    ; pop     ebx

    pusha
    push    dx
    push    ax

    mov     ax, [BPB_RootEntCnt]
    mov     cx, 0x20
    ; movzx   ecx, cl
    mul     cx
    mov     cx, [bp + _LoaderParam.BytesPerSector]
    add     ax, cx
    adc     dx, 0

    dec     ax
    test    ax, 0xffff
    jne     .1
    dec     dx
    .1:

    div     cx
    mov     [bp + _LoaderParam.RootDirSectors], ax
    xor     dx, dx
    mov     [bp + _LoaderParam.RootDirSectors + 2], dx

    pop     cx
    add     ax, cx
    mov     [bp + _LoaderParam.DataStartSector], ax
    adc     dx, 0
    pop     ax
    add     dx, ax
    mov     [bp + _LoaderParam.DataStartSector + 2], dx
    popa

    mov     cx, [bp + _LoaderParam.RootDirSectors]
    mov     bx, 0x60
    mov     es, bx
_ReadRootDirSector:
    xor     bx, bx
    call    ReadSector
    jc      _BootFailed

_LookupLoaderImage:
    cmp     [es:bx], byte 0
    je      _BootFailed
    mov     si, LoaderImageName
    mov     di, bx
    ; push    si
    mov     cx, 11
    repz    cmpsb
    ; pop     si
    jz      _LoaderFound
    add     bx, 0x20
    cmp     bx, 0x200
    jne     _LookupLoaderImage

    inc     ax
    adc     dx, 0
    loop    _ReadRootDirSector
    jmp     _BootFailed

_LoaderFound:
    ; get first cluster
    mov     ax, [es:bx + 26]
    cmp     ax, 2
    jb      _BootFailed
    push    ax

    add     eax, [bp + _LoaderParam.DataStartSector]
    dec     eax
    dec     eax
    mov     edx, eax
    shr     edx, 16
    movzx   cx, [BPB_SecPerClus]
    mov     bx, 0x100
    mov     es, bx
    xor     bx, bx
_ReadLoaderFirstCluster:
    call    ReadSector
    jc      _BootFailed
    add     bx, [bp + _LoaderParam.BytesPerSector]
    inc     ax
    adc     dx, 0
    loop    _ReadLoaderFirstCluster

    pop     si
    mov     di, ReadSector
    call    word 0:0x1000

_BootFailed:
    mov     si, MsgBootFailure
    call    DispStr
    ; mov     si, MsgPressAnyKey
    ; call    DispStr

    xor     ah, ah
    int     0x16
    ; mov     [0x7c00 + 510], byte 0
    int     0x19

    ; jmp $

; es:bx: buf addr, dx:ax: begin sector
ReadSector:
    pusha
    ; device address packet
    push    dword 0 ;}
    push    dx      ;} - logical block address (LBA)
    push    ax      ;}
    push    es      ;} - address of buffer(form Seg:Offset)
    push    bx      ;}
    push    word 1  ;} - count
    push    word 16 ;} - packet size

    cmp     dx, [bp + _LoaderParam.TotalSectors + 2]
    ja      _ReadSector_LBA
    jb      _ReadSector_CHS
    cmp     ax, [bp + _LoaderParam.TotalSectors]
    ja      _ReadSector_LBA

_ReadSector_CHS:
    ; LBA / SPT
    div     word [bp + _LoaderParam.SectorsPerTrack]

    ; S = (LBA % SPT) + 1
    xor     cx, cx
    xchg    cx, dx
    inc     cx

    div     word [bp + _LoaderParam.NumberHeads]
    ; C = (LBA / SPT) / NH
    xchg    ch, al
    ; H = (LBA / SPT) % NH
    xchg    dh, dl

    mov     ax, 0x201
    jmp     _ReadSector_Read

_ReadSector_LBA:
    mov     ah, 0x41
    mov     bx, 0x55AA
    mov     dl, [bp + _LoaderParam.DriveNumber]
    int     0x13
    jc      _ReadSector_Failed
    cmp     bx, 0xAA55
    jne     _ReadSector_Failed
    test    cx, 0xF8
    jnz     _ReadSector_Failed
    test    cl, 1
    jz      _ReadSector_Failed

    mov     ah, 0x42
    mov     si, sp

_ReadSector_Read:
    mov     dl, [bp + _LoaderParam.DriveNumber]
    int     0x13
    jnc     _ReadSector_Exit

_ReadSector_Failed:
    stc
_ReadSector_Exit:

    popa
    popa
    ret

; si: point to string
DispStr:
    pusha

    mov     ah, 0xE
    mov     bx, 0x7
_DispStr__Loop:
    lodsb
    test    al, al
    jz      _DispStr__Exit
    int     0x10
    jmp     _DispStr__Loop

_DispStr__Exit:

    popa
    ret

LoaderImageName: db "LOADER  MNS"

MsgBootFailure: db "Boot failed!"
MsgPressAnyKey: db `\r\n`
                db "Press any key to reboot", 0

TIMES 510 - ($ - $$) db 0
BS_BootSignature:   db 0x55, 0xAA
