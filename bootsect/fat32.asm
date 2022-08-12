ORG 0x7C00

    cli
    jmp BS_BootCodeStart

BS_OEMName:     db "MiniLdr "   ; 3   ; 8 bytes
BPB_BytsPerSec: dw 0x200    ; 11
BPB_SecPerClus: db 0    ; 13
BPB_RsvdSecCnt: dw 0x20 ; 14
BPB_NumFATs:    db 0x2  ; 16
BPB_RootEntCnt: dw 0    ; 17
BPB_TotSec16:   dw 0    ; 19    ; aways 1.44MB Floppy Disk
BPB_Media:      db 0xF8 ; 21
BPB_FATSize16:  dw 0    ; 22
BPB_SecPerTrk:  dw 0    ; 24
BPB_NumHeads:   dw 0    ; 26
BPB_HiddenSec:  dd 0    ; 28
BPB_TotSec32:   dd 0    ; 32

BPB_FATSize32:  dd 0    ; 36
BPB_ExtFlags:   dw 0    ; 40
BPB_FSVersion:  dw 0    ; 42
BPB_RootClus:   dd 0    ; 44
BPB_FSInfo:     dw 0    ; 48
BPB_BkBootSec:  dw 0    ; 50
BPB_Reserved:   dd 0, 0, 0  ; 52

BS_DriveNum:    db 0    ; 64
BS_Reserved1:   db 0    ; 6582
BS_ExtBootSig:  db 0x29 ; 66
BS_VolumeID:    dd 0    ; 67
BS_VolumeLab:   db "MiniOS v01 "    ; 71    ; 11 bytes
BS_FSType:      db "FAT32   "       ; 54     ; 8 bytes


BS_BootCodeStart:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x1000 - _LoaderParam_size
    mov bp, sp

    xor dh, dh
    mov [bp + _LoaderParam.DriveNumber], dx

    ; reset disk controller
    int 0x13
    jc _BootFailed

    xor di, di
    mov ah, 8
    int 0x13
    jnc _GetLoaderParam
    mov cx, 0xFFFF
    mov dh, cl

_GetLoaderParam:
    mov al, dh
    movzx eax, al
    inc ax
    mov [bp + _LoaderParam.NumberHeads], ax

    mov bh, cl
    mov bl, ch
    shr bh, 6
    movzx ebx, bx
    inc bx  ; CyliderCount

    and cl, 0x3F
    movzx ecx, cl
    mov [bp + _LoaderParam.SectorsPerTrack], cx

    mul ecx
    mul ebx
    mov [bp + _LoaderParam.TotalSectors], eax

    mov word [bp + _LoaderParam.BytesPerSector], 0x200

    movzx ebx, word [BPB_RsvdSecCnt]
    mov [bp + _LoaderParam.FatStartSector], ebx

    movzx ax, [BPB_NumFATs]
    mov cx, [BPB_FATSize16]
    mul cx
    add ax, bx
    mov [bp + _LoaderParam.RootDirStartSector], ax
    mov [bp + _LoaderParam.RootDirStartSector + 2], dx
    pusha
    mov bx, dx
    shl ebx, 16
    mov bx, ax

    movzx eax, word [BPB_RootEntCnt]
    mov cl, 32
    movzx ecx, cl
    mul ecx
    movzx ecx, word [bp + _LoaderParam.BytesPerSector]
    add eax, ecx
    dec eax
    div ecx
    add eax, ebx
    mov [bp + _LoaderParam.DataStartSector], eax

    popa
    ; mov ax, [bp + _LoaderParam.RootDirStartSector]
    ; mov dx, [bp + _LoaderParam.RootDirStartSector + 2]
    ; mov cx, [_LoaderParam.RootDirSectors]
    xor ch, ch
    mov si, LoaderFileName
    mov bx, 0x60
    mov es, bx
_ReadRootDirSector:
    xor bx, bx
    call ReadSector
    jc _BootFailed

_LookupRootDirSector:
    cmp byte [es:bx], 0
    je _BootFailed
    mov di, bx
    push si
    mov cl, 11
    repz cmpsb
    pop si
    jz _LoaderFound
    add bx, 0x20
    cmp bx, 0x200
    jne _LookupRootDirSector

    inc ax
    adc dx, 0
    ; loop _ReadRootDirSector
    jmp _ReadRootDirSector
    ; jmp _BootFailed

_LoaderFound:
    ; get first cluster
    movzx eax, word [es:bx + 26]
    cmp ax, 2
    jb _BootFailed

    push ax

    add eax, [bp + _LoaderParam.DataStartSector]
    dec eax
    dec eax
    mov edx, eax
    shr edx, 16
    movzx cx, [BPB_SecPerClus]
    mov bx, 0x100
    mov es, bx
    xor bx, bx
_ReadLoaderFirstCluster:
    call ReadSector
    jc _BootFailed
    add bx, [bp + _LoaderParam.BytesPerSector]
    inc ax
    adc dx, 0
    loop _ReadLoaderFirstCluster

    pop si
    jmp 0:0x1000

_BootFailed:
    mov si, MsgBootFailure
    call DispStr_RealMode

    jmp $

; bx: buf addr, dx:ax: begin sector
ReadSector:
    pusha

    ; LBA / SPT
    div word [bp + _LoaderParam.SectorsPerTrack]

    ; S = (LBA % SPT) + 1
    xor cx, cx
    xchg cx, dx
    inc cx

    div word [bp + _LoaderParam.NumberHeads]
    ; C = (LBA / SPT) / NH
    xchg ch, al
    ; H = (LBA / SPT) % NH
    xchg dh, dl

    mov dl, [bp + _LoaderParam.DriveNumber]

    mov ax, 0x201
    int 0x13

    popa
    ret

; si: point to string
DispStr_RealMode:
    pusha

    mov ah, 0xE
    mov bx, 0x7
_DispStr_RealMode__Loop:
    lodsb
    test al, al
    jz _DispStr_RealMode__Exit
    int 0x10
    jmp _DispStr_RealMode__Loop

_DispStr_RealMode__Exit:

    popa
    ret

STRUC _LoaderParam
    .DriveNumber:       resw 1
    .SectorsPerTrack:   resw 1
    .NumberHeads:       resw 1
    .BytesPerSector:    resw 1
    .TotalSectors:      resd 1
    
    .FatStartSector:        resd 1
    ; .FatSectors:            resd 1
    .RootDirStartSector:    resd 1
    ; .RootDirSectors:        resd 1
    .DataStartSector:       resd 1
    ; .DataSectors:           resd 1
ENDSTRUC

LoaderFileName:  db "LOADER  MNS"

MsgBootFailure: db `\r\n`
                db "Boot failed!"
                ; db `\r\n`
; MsgPressAnyKey  db "Press any key to reboot...", 0

TIMES 510 - ($ - $$) db 0
BS_BootSignature:   db 0x55, 0xAA



























org 0x7C00

    jmp BS_BootCodeStart
    nop

%include "fat12hdr_fd.inc"
%include "loader.inc"

BS_BootCodeStart:
    cli
    xor cx, cx
    mov ds, cx
    mov ss, cx
    mov es, cx
    mov bp, 0x7C00
    mov sp, bp

    sti
    cld

    cmp byte [BS_DriveNumber], 0xFF
    jne _Boot__Continue
    mov [BS_DriveNumber], dl
_Boot__Continue:

    ; reset disk controller
    xor ah, ah
    mov dl, [BS_DriveNumber]
    int 0x13
    jc _BootFailed

    mov ax, RootDirStartSector
    xor dx, dx
    mov cl, RootDirSectors
    mov si, LoaderFileName
    mov bx, BaseOfRootDirSectorSeg
    mov es, bx
_ReadRootDirSector:
    xor bx, bx
    call ReadSector
    jc _BootFailed

_LookupRootDirSector:
    cmp [es:bx], ch
    je _BootFailed
    pusha
    xchg di, bx
    mov cl, 11
    repz cmpsb
    popa
    jz _LoaderFound
    add bx, 0x20
    cmp bx, 0x200
    jne _LookupRootDirSector

    inc ax
    adc dx, 0
    loop _ReadRootDirSector
    jmp _BootFailed

    _LoaderFound:
    mov ax, [es:bx + 28]
    or ax, [es:bx + 30]
    jz _BootFailed

    ; get first cluster
    mov si, [es:bx + 26]
    test si, si
    jz _BootFailed

    mov bx, OffsetOfLoader    ; 不考虑 loader.bin 大小超过 64K 的情况（一般不会这么大吧）
    _ReadFileLoop:
    xor dx, dx
    mov ax, si
    add ax, DataStartSector - 2
    adc dx, 0
    push es
    push BaseOfLoaderSeg
    pop es
    call ReadSector
    pop es
    jc _BootFailed
    add bx, [BPB_BytesPerSector]

    ; calc the FAT offset
    mov ax, 3
    mul si
    mov cl, 2
    div cx

    pusha
    xor dx, dx
    div word [BPB_BytesPerSector]
    mov [bp - 2], dx
    xor dx, dx
    add ax, FatStartSector
    adc dx, 0
    ; mov bx, BaseOfFatSectorSeg
    xor bx, bx
    _InitFatTabLoop:
    call ReadSector
    jc _BootFailed
    inc ax
    adc dx, 0
    add bx, [BPB_BytesPerSector]
    loop _InitFatTabLoop
    popa

    xchg dx, si
    xchg si, ax
    mov si, [es:si]
    test dx, 1
    jz _GetFatNextEntry__Even
    _GetFatNextEntry__Odd:
    shr si, 4
    jmp _GetFatNextEntry__Exit
    _GetFatNextEntry__Even:
    and si, 0x0FFF
    _GetFatNextEntry__Exit:

    cmp si, 0x0FF8
    jb _ReadFileLoop

    jmp BaseOfLoaderSeg:OffsetOfLoader

    _BootFailed:
    mov si, MsgBootFailure
    call DispStr_RealMode
    mov si, MsgPressAnyKey
    call DispStr_RealMode
    xor ah, ah
    int 0x16

    int 0x19

; bx: buf addr, dx:ax: begin sector
ReadSector:
    pusha

    ; LBA / SPT
    div word [BPB_SectorsPerTrack]

    ; S = (LBA % SPT) + 1
    xor cx, cx
    xchg cx, dx
    inc cx

    div word [BPB_NumberHeads]
    ; C = (LBA / SPT) / NH
    xchg ch, al
    ; H = (LBA / SPT) % NH
    xchg dh, dl

    mov dl, [BS_DriveNumber]

    mov ax, 0x201
    int 0x13

    popa
    ret

; si: point to string
DispStr_RealMode:
    pusha

    mov ah, 0xE
    mov bx, 0x7
_DispStr_RealMode__Loop:
    lodsb
    test al, al
    jz _DispStr_RealMode__Exit
    int 0x10
    jmp _DispStr_RealMode__Loop

_DispStr_RealMode__Exit:

    popa
    ret

LoaderFileName  db "LOADER  BIN"

MsgBootFailure  db "Load failed!", `\r\n`, 0
MsgPressAnyKey  db "Press any key to reboot...", 0

TIMES 510 - ($ - $$) db 0
BS_BootSignature dw 0xAA55