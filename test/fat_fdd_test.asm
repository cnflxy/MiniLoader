ORG 0x7c00
[BITS 16]

BS_jmpBoot:
    ; jmp     near BS_BootCodeStart ; e9xxxx
    jmp     short BS_BootCodeStart  ; ebxx
    nop

BS_OEMName:     db "MiniLdr "   ; 3   ; 8 bytes
; BPB (BIOS Parameter Block)
BPB_BytsPerSec: dw 0x200    ; 11
BPB_SecPerClus: db 0x1  ; 13
BPB_RsvdSecCnt: dw 0x1  ; 14
BPB_NumFATs:    db 0x2  ; 16
BPB_RootEntCnt: dw 0xe0 ; 17
BPB_TotSec16:   dw 0xb40    ; 19    ; aways 1.44MB Floppy Disk
BPB_Media:      db 0xf0 ; 21
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
BS_VolumeLab:   db "NO NAME    "    ; 43    ; 11 bytes
BS_FSType:      db "FAT     "       ;54     ; 8 bytes

;   0x1234
;   dx
;   cs
;   ds
;   es
;   ss
;   sp
;   bp
;   blank line
;   NumberHeads
;   CyliderCount
;   SectorsPerTrack

BS_BootCodeStart:
    mov     cx, ds
    xor     ax, ax
    mov     ds, ax
    mov     [_OldCS], cs
    mov     [_OldDS], cx
    mov     [_OldSS], ss
    mov     [_OldBP], bp
    mov     [_OldSP], sp
    mov     [_DriveNumber], dl
    ; mov     cs, ax
    mov     ss, ax
    mov     bp, 0x1000
    mov     sp, bp

    mov     ax, 0x1234
    xchg    cx, dx
    xor     dx, dx
    call    PrintHex

    xchg    ax, cx
    xor     dx, dx
    call    PrintHex

    mov     ax, [_OldCS]
    xor     dx, dx
    call    PrintHex

    mov     ax, [_OldDS]
    xor     dx, dx
    call    PrintHex

    mov     ax, es
    xor     dx, dx
    call    PrintHex

    mov     ax, [_OldSS]
    xor     dx, dx
    call    PrintHex

    mov     ax, [_OldSP]
    xor     dx, dx
    call    PrintHex

    mov     ax, [_OldBP]
    xor     dx, dx
    call    PrintHex

    mov     al, `\r`
    call    PrintChar
    mov     al, `\n`
    call    PrintChar

    mov     dl, [_DriveNumber]
    mov     ah, 8
    int     0x13
    jc      _HOLD
    ; jnc     _GetLoaderParam
    ; mov     cx, 0xffff
    ; mov     dh, cl

_GetLoaderParam:
    ; CHS (Cylider-Head-Sector)
    ; C: 0-1023
    ; H: 0-255
    ; S: 1-63
    movzx   ax, dh
    inc     ax
    xor     dx, dx
    call    PrintHex    ; NumberHeads

    ; ch[0..7] = CyliderCount[0..7]
    ; cl[6..7] = CyliderCount[8..9]
    ; cl[0..5] = SectorsPerTrack[0..5]
    mov     al, ch
    mov     ah, cl
    shr     ah, 6
    inc     ax
    call    PrintHex    ; CyliderCount

    and     cx, 0x3f
    mov     ax, cx
    call    PrintHex    ; SectorsPerTrack

_HOLD:
    cli
    hlt
    jmp     $

; al - Char
PrintChar:
    pusha
    mov     ah, 0xe
    mov     bx, 0x7
    int     0x10
    popa
    ret

; ds:si - Str
PrintStr:
    pusha
    lodsb
    test    al, al
    jz      .Done
    call    PrintChar
    jmp     PrintStr
.Done:
    popa
    ret

; ax:dx - Hex
PrintHex:
    pusha
    mov     bx, 16
.Next:
    div     bx
    mov     si, dx
    add     si, _TranslateTable
    xchg    dx, ax
    lodsb
    call    PrintChar
    xchg    dx, ax
    xor     dx, dx
    test    ax, ax
    jnz     .Next
    mov     al, `\r`
    call    PrintChar
    mov     al, `\n`
    call    PrintChar
    popa
    ret

_TranslateTable:
    db  "0123456789ABCDEF"
_OldCS: dw 0
_OldDS: dw 0
_OldSS: dw 0
_OldBP: dw 0
_OldSP: dw 0
_DriveNumber: db 0

TIMES 510-($-$$) db 0
dw 0xaa55
