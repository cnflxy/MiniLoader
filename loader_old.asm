%include "./include/loader.inc"
%include "./include/pm.inc"

org 0x1000

    cli
    jmp LoaderStart

section .gdt
align 64
GDT_DESC:
GDT_DESC_DUMMPY:        Descriptor  0,  0,  0
GDT_DESC_CODE32_R0:     Descriptor  0x00000000, 0xFFFFF,    DA_CodeExecuteRead | DA_32BitsSeg | DA_4KByteUint | DA_Dpl0    ; 4 GB
GDT_DESC_DATA32_R0:     Descriptor  0x00000000, 0xFFFFF,    DA_DataReadWrite | DA_32BitsSeg | DA_4KByteUint | DA_Dpl0   ; 4 GB

GDT_DESC_APM_CODE32_R0: Descriptor  0x00000000, 0x00000,    DA_CodeExecuteRead | DA_32BitsSeg | DA_Dpl0
GDT_DESC_APM_CODE16_R0: Descriptor  0x00000000, 0x00000,    DA_CodeExecuteRead | DA_Dpl0
GDT_DESC_APM_DATA32_R0: Descriptor  0x00000000, 0x00000,    DA_DataReadWrite | DA_32BitsSeg | DA_Dpl0

GdtLen equ $ - GDT_DESC
align 16
GDT_48:
    dw GdtLen - 1       ; limit
    dd BaseOfGdtPhy     ; base

Selector    SelectorCode32_Ring0,       GDT_DESC_CODE32_R0 - GDT_DESC,      SA_TabGdt | SA_Rpl0
Selector    SelectorData32_Ring0,       GDT_DESC_DATA32_R0 - GDT_DESC,      SA_TabGdt | SA_Rpl0

Selector    SelectorAPMCode32_Ring0,    GDT_DESC_APM_CODE32_R0 - GDT_DESC,  SA_TabGdt | SA_Rpl0

; BaseOfGdtSeg    equ 0x1000
; OffsetOfGdt     equ 0
; BaseOfGdtPhy    equ BaseOfGdtSeg * 0x10 + OffsetOfGdt
BaseOfGdtPhy    equ GDT_DESC
; END of [SECTION .gdt]


section .idt
align 64
IDT_DESC:
IDT_DESC_INT_GENERIC:
%rep 256
Gate    SelectorCode32_Ring0,   0,   0,  DA_Sys32BitsIntGate | DA_Dpl0
%endrep

IdtLen equ $ - IDT_DESC
align 16
IDT_48:
    dw IdtLen - 1       ; limit
    dd BaseOfIdtPhy     ; base

; BaseOfIdtSeg    equ 0x1100
; OffsetOfIdt     equ 0
; BaseOfIdtPhy    equ BaseOfIdtSeg * 0x10 + OffsetOfIdt
BaseOfIdtPhy    equ IDT_DESC
; END of [SECTION .idt]


section .s16
bits 16
LoaderStart:
    xor ax, ax
    mov ss, ax
    mov sp, TopOfLoaderStack
    sti

    mov es, ax
    mov di, LoaderParam
    mov cx, _LoaderParam_size
    cld
    rep movsb
    mov ds, ax

    call A20_Gate
    test ax, ax
    jz _LoadFailed

    xor ebx, ebx
    mov es, bx
    mov di, BaseOfMemMapPhy
_GetMemMap__Loop:
    mov edx, 0x534D4150 ; "SMAP"
    mov ecx, 24
    mov eax, 0xE820
    int 0x15
    jc _LoadFailed
    cmp eax, edx
    jne _LoadFailed
    add di, 20
    inc word [dwNumberOfARDS]
    test ebx, ebx
    jnz _GetMemMap__Loop

    xor ah, ah
    mov al, 3
    int 0x10

    mov si, MsgLoadKernel
    call DispStr_RealMode

    ; reset disk controller
    xor ah, ah
    mov dl, [LoaderParam + _LoaderParam.DriveNumber]
    int 0x13
    jc _LoadFailed

    mov ax, [LoaderParam + _LoaderParam.RootDirStartSector]
    mov dx, [LoaderParam + _LoaderParam.RootDirStartSector + 2]
    mov si, KernelFileName
    mov bx, BaseOfRootDirSectorSeg
    mov es, bx
_ReadRootDirSector:
    xor bx, bx
    call ReadSector
    jc _LoadFailed

_LookupRootDirSector:
    cmp byte [es:bx], 0
    je _LoadFailed
    mov di, bx
    pusha
    mov cx, 11
    repz cmpsb
    popa
    jz _KernelFound
    add bx, 0x20
    cmp bx, 0x200
    jne _LookupRootDirSector

    inc ax
    adc dx, 0
    jmp _ReadRootDirSector
    jmp _LoadFailed

_KernelFound:
    mov ax, [es:bx + 28]
    or ax, [es:bx + 30]
    jz _LoadFailed
    ; ; calc the number of 64KB block actually
    ; cmp word [es:bx + 28], 0       ; dword: 0xFFFF FFFF
    ; setne al                     ; 64KB:  0x0001 0000
    ; cbw
    ; add ax, [es:bx + 30]
    ; mov cx, ax                  ; cx = (dword + 64KB - 1) / 64KB    ; cx = dword >> 16 + lword != 0

    ; get first cluster
    mov si, [es:bx + 26]
    test si, si
    jz _LoadFailed

    ; sub sp, 2
    ; mov word [bp - 2], BaseOfKernelFileSeg
    push BaseOfKernelFileSeg
    mov bp, sp
    mov bx, OffsetOfKernelFile
_ReadKernelSector:
    xor dx, dx
    movzx eax, si
    add eax, [LoaderParam + _LoaderParam.DataStartSector]
    dec eax
    dec eax
    mov edx, eax
    shr edx, 16
    push es
    push word [bp]
    pop es
    call ReadSector
    pop es
    jc _LoadFailed
    add bx, [LoaderParam + _LoaderParam.BytesPerSector]
    jnz _ReadKernelSector__Continue
    add word [bp], 0x1000
_ReadKernelSector__Continue:

    pusha
    mov ah, 0x0E
    mov al, '.'
    mov bl, 0x0F
    int 0x10
    popa

    ; calc the FAT offset
    mov ax, 3
    mul si
    mov cx, 2
    div cx

    pusha
    xor dx, dx
    div word [LoaderParam + _LoaderParam.BytesPerSector]
    mov [bp - 2], dx
    movzx eax, ax
    add eax, [LoaderParam + _LoaderParam.FatStartSector]
    mov edx, eax
    shr edx, 16
    xor bx, bx
_ReadFatSector:
    call ReadSector
    jc _LoadFailed
    inc ax
    adc dx, 0
    add bx, [LoaderParam + _LoaderParam.BytesPerSector]
    loop _ReadFatSector
    popa

    xchg dx, si
    xchg si, ax
    mov si, [es:si]
    test dx, 1
    jz _GetNextCluster__Even
_GetNextCluster__Odd:
    shr si, 4
    jmp _GetNextCluster__Exit
_GetNextCluster__Even:
    and si, 0x0FFF
_GetNextCluster__Exit:

    cmp si, 0x0FF8
    jb _ReadKernelSector
    add sp, 2

    call DispReturn

    mov ah, 53h
    mov al, 00h     ; APM Installation Check
    mov bx, 0000h   ; Power device ID(0000h: APM BIOS)
    int 15h
    jc _LoaderContinue
    mov [APM_MajorVersion], ah
    mov [APM_MinorVersion], al
    mov [APM_Flags], cx
    ; cmp ax, 0102h   ; Need APM 1.2 and later
    ; jb _LoaderContinue
    test cx, 2      ; Need 32-bit protected mode interface supported
    jz _LoaderContinue

    mov ah, 53h
    mov al, 04h     ; Interface disconnect
    mov bx, 0000h   ; Power device ID(0000h: APM BIOS)
    int 15h

    mov ah, 53h
    mov al, 03h     ; Protected mode 32-bit interface connect
    mov bx, 0000h   ; Power device ID(0000h: APM BIOS)
    int 15h
    jc _LoaderContinue
    mov [APM_Code32SegAddr], ax
    mov [APM_Code16SegAddr], cx
    mov [APM_DataSegAddr], dx
    mov [APM_Code32SegLen], si
    shr esi, 16
    mov [APM_Code16SegLen], si
    mov [APM_DataSegLen], di
    mov [APM_OffsetOfEntry], ebx
    mov byte [APM_Connected], 1

    movzx eax, word [APM_Code32SegAddr]
    shl eax, 4
    mov [GDT_DESC_APM_CODE32_R0 + 2], ax
    shr eax, 0x10
    mov [GDT_DESC_APM_CODE32_R0 + 4], al
    mov [GDT_DESC_APM_CODE32_R0 + 7], ah

    movzx eax, word [APM_Code32SegLen]
    dec eax
    mov	[GDT_DESC_APM_CODE32_R0], ax
	shr	eax, 0x10
    and al, 0x0F
	or [GDT_DESC_APM_CODE32_R0 + 6], al

    movzx eax, word [APM_Code16SegAddr]
    shl eax, 4
    mov [GDT_DESC_APM_CODE16_R0 + 2], ax
    shr eax, 0x10
    mov [GDT_DESC_APM_CODE16_R0 + 4], al
    mov [GDT_DESC_APM_CODE16_R0 + 7], ah

    movzx eax, word [APM_Code16SegLen]
    dec eax
    mov	[GDT_DESC_APM_CODE16_R0], ax
	shr	eax, 0x10
    and al, 0x0F
	or [GDT_DESC_APM_CODE16_R0 + 6], al

    movzx eax, word [APM_DataSegAddr]
    shl eax, 4
    mov [GDT_DESC_APM_DATA32_R0 + 2], ax
    shr eax, 0x10
    mov [GDT_DESC_APM_DATA32_R0 + 4], al
    mov [GDT_DESC_APM_DATA32_R0 + 7], ah

    movzx eax, word [APM_DataSegLen]
    dec eax
    mov	[GDT_DESC_APM_DATA32_R0], ax
	shr	eax, 0x10
    and al, 0x0F
	or [GDT_DESC_APM_DATA32_R0 + 6], al

    test word [APM_Flags], 8
    jz _APM__Continue0
    ; enable APM BIOS Power Management
    mov ah, 53h
    mov al, 08h     ; Enable/Disable Power Management
    mov bx, 0001h   ; All devices
    mov cx, 0001h   ; Enable power management
    int 15h
    jc _LoaderContinue
_APM__Continue0:
    test word [APM_Flags], 16
    jz _APM__Continue1
    ; engage APM BIOS Power Management
    mov ah, 53h
    mov al, 0Fh     ; Engage/disengage power management
    mov bx, 0001h   ; All devices
    mov cx, 0001h   ; Engage power management
    int 15h
    jc _LoaderContinue
_APM__Continue1:
    test word [APM_Flags], 4
    jz _APM__Continue2
    ; call CPU Busy function
    mov ah, 53h
    mov al, 06h     ; CPU Busy
    int 15h
    jc _APM__Continue2

_APM__Continue2:
    mov ah, 53h
    mov al, 0Eh     ; APM Driver Version
    mov bx, 0000h   ; Power device ID(0000h: APM BIOS)
    mov ch, [APM_MajorVersion]
    mov cl, [APM_MinorVersion]
    int 15h
    jc _LoaderContinue

_LoaderContinue:
    xor ah, ah
    int 0x16

    cli

    ; in al, 0x70
    ; or al, 0x80
    ; out 0x70, al

    db 0x66
    lgdt [GDT_48]
    db 0x66
    lidt [IDT_48]

    mov eax, cr0
    and al, 0xDD ; disable MP NE
    or al, 1    ; enable PE
    mov cr0, eax

    jmp dword SelectorCode32_Ring0:OffsetCode32_Ring0

    _LoadFailed:
    mov si, MsgLoadFailure
    call DispStr_RealMode

    jmp $

; short GetStrLen(char *str)
GetStrLen:
    enter 0, 0
    push di
    push cx

    mov di, [bp + 4]
    xor ax, ax
    mov cx, 0xFFFF
    cld
    repne scasb
    not cx
    dec cx

    mov ax, cx

    pop cx
    pop di
    leave
    ret 2

; void DispChar(char c)
DispChar:
    enter 0, 0
    push bx

    mov ax, [bp + 4]

    mov ah, 0x0e
    mov bx, 0x000c
    int 0x10

    pop bx
    leave
    ret 2

; void DispReturn(void)
DispReturn:
    push `\r`
    call DispChar
    push `\n`
    call DispChar
    ret

; bx: buf addr, dx:ax: begin sector
ReadSector:
    pusha

    ; LBA / SPT
    div word [LoaderParam + _LoaderParam.SectorsPerTrack]

    ; S = (LBA % SPT) + 1
    xor cx, cx
    xchg cx, dx
    inc cx

    div word [LoaderParam + _LoaderParam.NumberHeads]
    ; C = (LBA / SPT) / NH
    xchg ch, al
    ; H = (LBA / SPT) % NH
    xchg dh, dl

    mov dl, [LoaderParam + _LoaderParam.DriveNumber]

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

; void DispInt(int num, int base, int width)
DispInt:
    enter 0, 0
    push edx
    push ebx
    push cx
    push si

    mov eax, [bp + 4]
    mov ebx, [bp + 8]
    xor cx, cx
    _DispInt__StoreLoop:
    xor edx, edx
    div ebx
    push dx
    inc cx
    dec dword [bp + 12]
    test eax, eax
    jnz _DispInt__StoreLoop

    cmp dword [bp + 12], 0
    jle _DispInt__PrintLoop

    _DispInt__FillLoop:
    push '0'
    call DispChar
    dec dword [bp + 12]
    cmp dword [bp + 12], 0
    jg _DispInt__FillLoop

    _DispInt__PrintLoop:
    pop si
    mov al, [TransformTable + si]
    push ax
    call DispChar
    loop _DispInt__PrintLoop

    pop si
    pop cx
    pop ebx
    pop edx
    leave
    ret 8

; void DispHex(int num)
DispHex:
    enter 0, 0

    ; push '0'
    ; call DispChar
    ; push 'x'
    ; call DispChar
    push dword 8
    push dword 0x10
    push dword [bp + 4]
    call DispInt

    leave
    ret 4

; void DispDec(int num)
DispDec:
    enter 0, 0

    push dword 0
    push dword 0xA
    push dword [bp + 4]
    call DispInt

    leave
    ret 4

; void CopyMemory(char *src, char *dst, short len)
CopyMemory:
    push bp
    mov bp, sp
    pusha

    mov si, [bp + 4]
    mov di, [bp + 6]
    mov cx, [bp + 8]
    cld
    rep movsb

    popa
    mov sp, bp
    pop bp
    ret

; int MemCmp(char *src, char *des, int count)
MemCmp:
    enter 0, 0
    push ecx
    push esi
    push edi

    mov esi, [bp + 0x4 * 2]
    mov edi, [bp + 0x4 * 3]
    mov ecx, [bp + 0x4 * 4]
    cld
    repz cmpsb

    mov eax, ecx

    pop edi
    pop esi
    pop ecx
    leave
    ret 0x4 * 3

    ;     push dword 0
    ; push dx
    ; push ax
    ; push es
    ; push bx
    ; push 1
    ; push 0x10
    ;     mov ah, 0x41
    ; int 0x13
    ; jc 

%include "a20.asm"
; End of [SECTION .s16]


section .data
bits 32
align 32

LoaderParam:
    istruc _LoaderParam
        at _LoaderParam.DriveNumber,     dw 0
        at _LoaderParam.SectorsPerTrack, dw 0
        at _LoaderParam.NumberHeads,     dw 0
        at _LoaderParam.BytesPerSector,  dw 0
        at _LoaderParam.TotalSectors,    dd 0
        at _LoaderParam.FatStartSector,  dd 0
        at _LoaderParam.RootDirStartSector, dd 0
        at _LoaderParam.DataStartSector, dd 0
    iend

KernelFileName db "KERNEL  MNS"

BaseOfKernelFileSeg equ 0x1000
OffsetOfKernelFile  equ 0
BaseOfKernelFilePhy equ BaseOfKernelFileSeg * 0x10 + OffsetOfKernelFile

MsgLoadKernel   db `\r\n`, "Loading kernel", 0
MsgLoadFailure  db `\r\n`, "Load failed!", 0
; MsgPressAnyKey  db "Press any key to reboot...", 0

struc _ARDS
    .BaseAddr:   resq 1
    .Length:     resq 1
    .Type:       resd 1
    .ACPIExtAttr:    resd 1    ; if 24 bytes returned
endstruc

BaseOfMemMapPhy equ 0x9000

msgInPmNow  db "In PM now!", `\n`, 0
msgApicBase db "APIC Base: 0x", 0
msgApmVersion   db "APM BIOS Version: ", 0

TransformTable db "0123456789ABCDEF"

ddCurPos  dd 0xB8000

dwNumberOfARDS      dw 0
ddMemSize           dd 0
ddEndOfPhySpaceAddr dd 0

APM_BIOS32_INTERFACE:
    APM_MajorVersion    db 0
    APM_MinorVersion    db 0
    APM_Flags           dw 0
    APM_Connected       db 0
    APM_Code32SegAddr   dw 0
    APM_Code32SegLen    dw 0
    APM_Code16SegAddr   dw 0
    APM_Code16SegLen    dw 0
    APM_DataSegAddr     dw 0
    APM_DataSegLen      dw 0
    APM_OffsetOfEntry   dd 0

KernelMappedAddrVirtualAddress  equ 0x100000
BaseOfPageDirEntryPhy       equ 0x100000
BaseOfPageTableEntryPhy     equ BaseOfPageDirEntryPhy + 4096
;END of [SECTION .data32]


[SECTION .s32_r0]
[BITS 32]
CODE32_R0:
    mov ax, SelectorData32_Ring0
    mov ds, ax
    mov es, ax
    mov ss, ax
    xor ax, ax
    mov fs, ax
    mov gs, ax
    mov ebp, TopOfLoaderStack
    mov esp, ebp

    call ClearScreen
    
    call KillMotor

    push msgInPmNow
    call PrintStr
    add esp, 4

    call ShowMemMap

    call Init8259A

    ; Program the PIT channel 0(IRQ 0), 50ms, 20Hz
    mov al, 0011001b
    out 0x43, al
    call IoWait
    mov ax, 0xE90B   ; 315000000 / 264 / 20
    out 0x40, al
    call IoWait
    xchg ah, al
    out 0x40, al
    call IoWait

    mov edi, BaseOfIdtPhy
    mov eax, TmpClockInt
    mov [edi + 8 * 32], ax
    shr eax, 16
    mov [edi + 8 * 32 + 6], ax

    in al, 0x21
    and al, 011111110b
    out 0x21, al
    call IoWait
    sti

    push dword [ddMemSize]
    call InitPaging
    add esp, 4

    call SetupPaging
    
    push PG_S | PG_RW
    push 0xA0000
    push 0xB8000
    call MapPage
    add esp, 12

    mov edi, 0xA0000 + (80 * 2  + 79) * 2
    mov ah, 0x0E
    mov al, 'P'
    mov [edi], ax

    push msgInPmNow
    call PrintStr
    add esp, 4

    push msgApicBase
    call PrintStr
    add esp, 4
    mov ecx, 0x1B   ; IA32_APIC_BASE
    rdmsr
    push edx
    call PrintHex
    add esp, 4
    and eax, 0xFFFFF000
    push eax
    call PrintHex
    add esp, 4
    call PrintLineBreak

    push msgApmVersion
    call PrintStr
    add esp, 4
    movzx eax, byte [APM_MajorVersion]
    push eax
    call PrintDec
    add esp, 4
    push '.'
    call PrintChar
    add esp, 4
    movzx eax, byte [APM_MinorVersion]
    push eax
    call PrintDec
    add esp, 4
    call PrintLineBreak

    in al, 0x60
_WaitKeyPress:
    in al, 0x64
    test al, 1
    jz _WaitKeyPress


    ; ----------------------- ;
    mov esi, BaseOfKernelFilePhy
    mov edi, KernelMappedAddrVirtualAddress
    push PG_S | PG_RW
    push edi
    push 0x500000
    call MapPage
    add esp, 12

    

    ; call ShutdownSystem

    jmp $

TmpClockInt:
    pushad
    pushfd

    in al, 0x21
    or al, 1
    out 0x21, al
    call IoWait

    mov al, 0x20
    out 0x20, al
    call IoWait

    push 'C'
    call PrintChar
    add esp, 4
    call PrintLineBreak

    popfd
    popad
    iretd

InitAPM:
    push ebp
    mov esp, ebp

    cmp byte [APM_Connected], 1
    jne _InitAPM__Failed
    pushad
    popad
    jmp _InitAPM__Exit

_InitAPM__Failed:

_InitAPM__Exit:

    leave
    ret

ApmBios32Call:

ShutdownSystem:
    push ebp
    mov esp, ebp
    sub esp, 6
    pushad
    
    cmp byte [APM_Connected], 1
    jne _ShutdownSystem__Exit

    mov ah, 53h
    mov al, 07h     ; Set Power State
    mov bx, 0001h   ; All devices
    mov cx, 0003h   ; Off
    mov word [ebp - 2], SelectorAPMCode32_Ring0
    mov edx, [APM_OffsetOfEntry]
    mov dword [ebp - 6], edx
    call far [ebp - 6]

_ShutdownSystem__Exit:
    popad
    leave
    ret

; void ShowMemMap(void)
ShowMemMap:
    push ebp
    mov ebp, esp
    pushad

    mov esi, BaseOfMemMapPhy
    movzx ecx, word [dwNumberOfARDS]
_ShowMemMap__Loop:
    push dword [esi + _ARDS.BaseAddr]
    push dword [esi + _ARDS.BaseAddr + 4]
    call PrintHex
    add esp, 4
    call PrintHex
    add esp, 4
    push ' '
    call PrintChar
    add esp, 4

    push dword [esi + _ARDS.Length]
    push dword [esi + _ARDS.Length + 4]
    call PrintHex
    add esp, 4
    call PrintHex
    add esp, 4
    push ' '
    call PrintChar
    add esp, 4

    push dword [esi + _ARDS.Type]
    call PrintDec
    add esp, 4
    call PrintLineBreak

    cmp dword [esi + _ARDS.Type], 1
    jne _ShowMemMap__Continue
    cmp dword [esi + _ARDS.BaseAddr + 4], 0
    jne _ShowMemMap__Continue
    cmp dword [esi + _ARDS.Length + 4], 0
    jne _ShowMemMap__Continue
    mov eax, [esi + _ARDS.BaseAddr]
    add eax, [esi + _ARDS.Length]
    jc _ShowMemMap__Continue
    mov [ddMemSize], eax
_ShowMemMap__Continue:
    add esi, 20
    loop _ShowMemMap__Loop

    popad
    leave
    ret

Init8259A:
    ; ICW1
    mov al, 0x11    ; ICW4 cascading 8byte edge
    out 0x20, al
    call IoWait
    out 0xA0, al
    call IoWait

    ; ICW2
    mov al, 32
    out 0x21, al
    call IoWait
    mov al, 42
    out 0xA1, al
    call IoWait

    ; ICW3
    mov al, 0x4
    out 0x21, al
    call IoWait
    mov al, 0x2
    out 0xA1, al
    call IoWait

    ; ICW4
    mov al, 0x1
    out 0x21, al
    call IoWait
    out 0xA1, al
    call IoWait

    mov al, 011111011b
    out 0x21, al
    call IoWait
    mov al, 011111111b
    out 0xA1, al
    call IoWait

    ret

; void LillMotor(void)
KillMotor:
    push edx

    mov dx, 0x03F2
    xor al, al
    out dx, al
    call IoWait

    pop edx
    ret

; void ScrollUpScreen(uint32_t rows)
ScrollUpScreen:
    push ebp
    mov ebp, esp
    pushad

    mov edi, 0xB8000
    mov eax, [ebp + 8]
    push 80 * 2
    mul dword [esp]
    pop edx
    cmp eax, [ddCurPos]
    jae _ScrollUpScreen__1
    mov esi, eax
    add esi, 0xB8000
    mov ecx, [ddCurPos]
    sub ecx, 0xB8000
    sub ecx, eax
    shr ecx, 1
    cld
    rep movsw

_ScrollUpScreen__1:
    mov [ddCurPos], edi
    mov ax, 0x0020
_ScrollUpScreen__Clear:
    cmp edi, 0xB8000 + 80 * 25 * 2
    jae _ScrollUpScreen__Exit
    stosw
    jmp _ScrollUpScreen__Clear

_ScrollUpScreen__Exit:
    popad
    leave
    ret

; void PrintChar(char ch)
PrintChar:
    push ebp
    mov ebp, esp
    pushad

    mov edi, [ddCurPos]
    mov ah, 0x07
    mov al, [ebp + 8]
    
    cmp al, `\r`
    jne _PrintChar__1
    xor edx, edx
    mov eax, edi
    sub eax, 0xB8000
    push 80 * 2
    div dword [esp]
    mul dword [esp]
    pop edx
    add eax, 0xB8000
    mov edi, eax
    jmp _PrintChar__Exit
_PrintChar__1:
    cmp al, `\n`
    jne _PrintChar__2
    xor edx, edx
    mov eax, edi
    sub eax, 0xB8000
    push 80 * 2
    div dword [esp]
    inc eax
    mul dword [esp]
    pop edx
    add eax, 0xB8000
    mov edi, eax
    jmp _PrintChar__Exit
_PrintChar__2:
    cld
    stosw

_PrintChar__Exit:
    mov [ddCurPos], edi

    cmp edi, 0xB8000 + 80 * 25 * 2
    jbe _PrintChar__Exit2
    xor edx, edx
    mov eax, edi
    sub eax, 0xB8000 + 80 * 25 * 2
    add eax, (80 - 1) * 2
    push 80 * 2
    div dword [esp]
    pop edx
    push eax
    call ScrollUpScreen
    add esp, 4
_PrintChar__Exit2:

    popad
    leave
    ret

; void PrintStr(char* str)
PrintStr:
    push ebp
    mov ebp, esp
    pushad

    mov esi, [ebp + 8]
    xor eax, eax
    cld
_PrintStr__Loop:
    lodsb
    test al, al
    jz _PrintStr__Exit
    push eax
    call PrintChar
    add esp, 4
    jmp _PrintStr__Loop

_PrintStr__Exit:
    
    popad
    leave
    ret

; void ClearScreen(void)
ClearScreen:
    push ebp
    mov ebp, esp
    pushad

    mov edi, 0xB8000
    mov [ddCurPos], edi
    mov ax, 0x0020
    mov ecx, 80 * 25
    cld
    rep stosw

    popad
    leave
    ret

; void PrintLineBreak(void)
PrintLineBreak:
    push ebp
    mov ebp, esp

    sub esp, 3
    mov byte [esp], `\r`
    mov byte [esp + 1], `\n`
    mov byte [esp + 2], 0
    push esp
    call PrintStr
    add esp, 4

    leave
    ret

; void PrintInt(uint32_t num, uint32_t base, int32_t width)
PrintInt:
    push ebp
    mov ebp, esp
    sub esp, 16
    pushad

    mov esi, ebp
    dec esi
    mov byte [edi], 0
    and dword [ebp + 16], 0xF
    mov eax, [ebp + 8]
_PrintInt__Transform:
    xor edx, edx
    div dword [ebp + 12]
    mov dl, [TransformTable + edx]
    dec esi
    mov [esi], dl
    dec dword [ebp + 16]
    test eax, eax
    jnz _PrintInt__Transform

    cmp dword [ebp + 16], 0
    jle _PrintInt__Output

_PrintInt__FixWidth:
    dec esi
    mov byte [esi], '0'
    dec dword [ebp + 16]
    jnz _PrintInt__FixWidth

_PrintInt__Output:
    push esi
    call PrintStr
    add esp, 4

    popad
    leave
    ret

; void PrintHex(int32_t num)
PrintHex:
    push ebp
    mov ebp, esp

    push 8
    push 16
    push dword [ebp + 8]
    call PrintInt
    add esp, 12

    mov esp, ebp
    pop ebp
    ret

; void PrintDec(int32_t num)
PrintDec:
    push ebp
    mov ebp, esp

    push 0
    push 10
    push dword [ebp + 8]
    call PrintInt
    add esp, 12

    leave
    ret

; void IoWait(void)
IoWait:
    nop
    nop
    nop
    nop
    ret

; void InitPaging(uint32_t ddMemSize)
InitPaging:
    push ebp
    mov ebp, esp
    sub esp, 8
    pushad
    cld

    xor edx, edx
    mov eax, [ebp + 8]
    push 4096   ; PAGE_SIZE (4 KB)
    div dword [esp]
    mov [ebp - 4], eax
    pop edx
    xor edx, edx
    inc eax
    push 1024
    div dword [esp]
    inc eax
    mov [ebp - 8], eax
    pop edx

    mov edi, BaseOfPageDirEntryPhy
    mov ecx, [ebp - 8]
    mov eax, BaseOfPageTableEntryPhy | PG_P | PG_RW | PG_US
_InitPaging__FillPDE:
    stosd
    add eax, 0x1000
    loop _InitPaging__FillPDE

    mov edi, BaseOfPageTableEntryPhy
    mov ecx, [ebp - 4]
    xor eax, eax
_InitPaging__FillPTE:
    or eax, PG_P | PG_RW | PG_US
    stosd
    add eax, 0x1000
    loop _InitPaging__FillPTE

    mov eax, cr3
    mov eax, BaseOfPageDirEntryPhy
    mov cr3, eax

    popad
    leave
    ret

; void SetupPaging(void)
SetupPaging:
    mov eax, cr0
    or eax, 0x80010000  ; set PG WP flag
    mov cr0, eax

    ret

; void MapPage(void* phyAddr, void* linearAddr, uin16_t flags)
MapPage:
    push ebp
    mov ebp, esp
    sub esp, 8
    pushad

    mov eax, [ebp + 12]
    mov edx, eax
    shr edx, 22
    mov [ebp - 8], edx
    shr eax, 12
    and eax, 0x03FF
    mov [ebp - 4], eax

    mov edi, [ebp - 8]
    shl edi, 2
    add edi, BaseOfPageDirEntryPhy
    mov eax, [edi]
    mov edx, [ebp + 16]
    and edx, 0x1E
    or eax, edx
    or eax, PG_P
    mov [edi], eax
    and eax, 0xFFFFF000
    
    mov edi, [ebp - 4]
    shl edi, 2
    add edi, eax
    mov eax, [ebp + 8]
    and eax, 0xFFFFF000
    ; mov eax, [edi]
    mov edx, [ebp + 16]
    and edx, 0xFFF
    or eax, edx
    or eax, PG_P
    mov [edi], eax

    mov eax, cr3
    mov cr3, eax

    popad
    leave
    ret

; void kMsSleep(uin32_t Millsec)
kMsSleep:
    push ebp
    mov ebp, esp



    leave
    ret

OffsetCode32_Ring0  EQU CODE32_R0
; END of [SECTION .s32_r0]
