%include "loader.inc"

ORG 0x7c00
[BITS 16]

BS_jmpBoot:
    jmp     short BS_BootCodeStart  ; ebxx
    nop

BS_OEMName:     db "MiniLdr "   ; 3 - 8 bytes
; BPB (BIOS Parameter Block)
BPB_BytsPerSec: dw 0x200    ; 11
BPB_SecPerClus: db 0x8      ; 13
BPB_RsvdSecCnt: dw 0x1      ; 14
BPB_NumFATs:    db 0x2      ; 16
BPB_RootEntCnt: dw 0x200    ; 17
BPB_TotSec16:   dw 0x0      ; 19
BPB_Media:      db 0xf8     ; 21
BPB_FATSize16:  dw 0xe5     ; 22
BPB_SecPerTrk:  dw 0x38     ; 24
BPB_NumHeads:   dw 0x24     ; 26
BPB_HiddenSec:  dd 0        ; 28
BPB_TotSec32:   dd 0x72a00  ; 32
; FAT12/16
BS_DriveNum:    db 0x80     ; 36
BS_Reserved1:   db 0        ; 37
BS_ExtBootSig:  db 0x29     ; 38
BS_VolumeID:    dd 0        ; 39
BS_VolumeLab:   db "MiniOS v01 "    ; 43 - 11 bytes
BS_FSType:      db "FAT     "       ; 54 - 8 bytes   // actually the fs type not depend this
; FAT12/16
; FAT=File Allocate Table
; 12=every cluster offset size in FAT is 12bits


BS_BootCodeStart:
    ; sti
    cld
    ; xor     ax, ax
    xor     si, si  ; int 0x13 AH=0x8 not effect
    mov     ds, si
    ; mov     es, ax
    mov     ss, si
    mov     sp, 0x700
    ; mov     sp, 0x1000 - LoaderParameter_size
    mov     bp, sp

    ; reset disk controller
    ; int     0x13
    ; jc      _BootFailed

_GetLoaderParameter:
    ; CHS (Cylider-Head-Sector)
    ; C: 0-1023
    ; H: 0-255
    ; S: 1-63
    mov     [bp + LoaderParameter.DriveNumber], dl

    mov     ah, 8   ; GET DRIVE PARAMETERS
    int     0x13
    mov     es, si  ; zero ES here
    jnc     .1
    ; mov     cx, 0xff30
    ; jmp     .2
    mov     cx, 0xffff
    mov     dh, cl
    .1:
    ; CH[0..7] = CyliderCount[0..7]
    ; CL[6..7] = CyliderCount[8..9]
    ; CL[0..5] = SectorsPerTrack[0..5]
    ; DH = maximum head number
    mov     dl, cl
    xchg    ch, cl
    shr     ch, 6
    inc     cx
    .2:
    mov     [bp + LoaderParameter.CyliderCount], cx

    movzx   ax, dh
    inc     ax
    mov     [bp + LoaderParameter.NumberHeads], ax

    and     dx, 0x3f
    mov     [bp + LoaderParameter.SectorsPerTrack], dx

    movzx   eax, word [BPB_TotSec16]
    test    ax, ax
    jnz     .3
    mov     eax, [BPB_TotSec32]
    .3:
    mov     [bp + LoaderParameter.TotalSectors], eax

    ; FatStartSector = BPB_RsvdSecCnt
    movzx   ebx, word [BPB_RsvdSecCnt]
    mov     [bp + LoaderParameter.FatStartSector], ebx

    ; FatSectors = BPB_FATSize16 * BPB_NumFATs
    movzx   eax, word [BPB_FATSize16]
    mov     [bp + LoaderParameter.FatSectors], eax
    movzx   ecx, byte [BPB_NumFATs]
    mul     ecx

    ; RootDirStartSector = FatStartSector + FatSectors
    add     ebx, eax
    mov     [bp + LoaderParameter.RootDirStartSector], ebx

    ; RootDirSectors = (BPB_RootEntCnt * 32 + BytesPerSector - 1) / BytesPerSector
    ; BPB_RootEntCnt * 32 / BytesPerSector + (BPB_RootEntCnt * 32 % BytesPerSector) != 0
    ; mov     ax, [BPB_RootEntCnt]
    ; mov     cl, 0x20
    ; mul     cx
    ; mov     cx, [BPB_BytsPerSec]
    ; mov     [bp + LoaderParameter.BytesPerSector], cx
    ;; add     ax, cx
    ;; adc     dx, 0
    ;; div     cx
    ;; movzx   eax, ax
    ;; div     cx
    ; test    dx, dx
    ; setnz   cl
    ; xor     ch, ch
    ; movzx   eax, ax
    ; add     eax, ecx

    movzx   eax, word [BPB_RootEntCnt]
    mov     cl, 0x20
    mul     ecx
    mov     cx, [BPB_BytsPerSec]
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

    ; xor     bx, bx
    ; mov     es, bx
_ReadRootDirSector:
    mov     bx, 0x800
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
    cmp     bx, 0x800 + 0x200
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
    ; mov     ebx, [es:bx + 28]
    ; mov     [bp + LoaderParameter.LoaderSize], ebx
    push    dword [es:bx + 28]   ; File Size
    pop     dword [bp + LoaderParameter.LoaderSize]

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
    mov     es, bx
    push    es  ; [bp - 4]
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

    ; di: FirstClusterNum
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
                ; db "Press any key to restart"
                db 0

TIMES 510 - ($ - $$) db 0
BS_BootSignature:   db 0x55, 0xaa
