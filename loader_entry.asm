%include "loader.inc"

[BITS 16]

; 0x0040:0x0075: number of hard drives currently installed

[GLOBAL LdrEntry16]
LdrEntry16:	; void LdrEntry16(u8 FatType, u16 FirstClusterNum)
    ; parameter
    ; di: FirstClusterNum
	; cs: [bp - 2]
	; ip: [bp - 4]
	jmp		short .JmpOutLdrSignature
	dw	0xaa55
	.JmpOutLdrSignature:
	
	; sti
	cld
    push    0   ; [bp - 6]	; Is FAT16 ?
	push	0	; [bp - 8]	; LBA Invalid
    
    test	di, di
    jz		_LoadFailed

	xor     edx, edx
	mov		es, dx

    mov     eax, [bp + LoaderParameter.TotalSectors]
    sub     eax, [bp + LoaderParameter.DataStartSector]
    movzx   ecx, byte [bp + LoaderParameter.SectorsPerCluster]
    div     ecx
    cmp		eax, 65525	; FAT32
    jae		_LoadFailed
    cmp     eax, 4085
    setae	[bp - 6]

    ; load FAT into memory
	mov     ecx, [bp + LoaderParameter.FatSectors]
	; shr		ecx, 1
    mov     ax, [bp + LoaderParameter.FatStartSector]
    mov     dx, [bp + LoaderParameter.FatStartSector + 2]
    mov     bx, 0x800	; can hold 119 FAT sector (0x800 - 0xf000 (0x10000 - 0x1000 (4096 - PAGE_SIZE) ))
_ReadFatSector:	; dangerous!!! overwrite BootLoader code
    call    ReadSector
    jc      _LoadFailed

    cmp     byte [es:bx], 0
    je      .Done

    add     bx, [bp + LoaderParameter.BytesPerSector]
    inc     ax
    adc     dx, 0
	dec		ecx
	jnz		_ReadFatSector

	.Done:

	mov		ax, [bp + LoaderParameter.BytesPerSector]
	movzx	cx, [bp + LoaderParameter.SectorsPerCluster]
	mul		cx
	shr		ax, 4
	add		ax, 0x1000
	mov		es, ax
	mov		bx, [bp + LoaderParameter.BytesPerSector]
	shr		bx, 4
_ReadLoaderSector:
    mov     ax, di
	push	cx
    mov     cx, 3
    add     cx, [bp - 6]
    mul     cx
    mov     cl, 2
    div     cx
	pop		cx
    mov     si, ax
    
    mov     ax, FAT_ENTRY_RESERVED_TO_END
    mov     dx, di
    mov     di, [si + 0x800]
    cmp     byte [bp - 6], 1
    je      .Out
    and     ah, 0xf	; ax = 0xff8
    and     dl, 1
    jz      .Even
    shr     di, 4
    jmp     .Out
	.Even:
    and     di, 0xfff
	.Out:

    cmp     di, ax
    jae     _LoadDone

    mov   	ax, di
	dec		ax
	dec		ax
	movzx	cx, [bp + LoaderParameter.SectorsPerCluster]
	mul		cx
    add     ax, [bp + LoaderParameter.DataStartSector]
	; xor		dx, dx
    adc     dx, [bp + LoaderParameter.DataStartSector + 2]
_ReadOneCluster:
	push	bx
	xor		bx, bx
    call    ReadSector
	pop		bx
	jc     	_LoadFailed
	push    es	; [bp - 10]
	add		[bp - 10], bx
	pop		es
	inc     ax
    adc     dx, 0
	loop	_ReadOneCluster
	jmp		_ReadLoaderSector

_LoadFailed:
	add		sp, 2
    retf

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

	cmp		byte [bp - 8], 1
	je		.CHS.1

    .LBA:
	mov     si, sp
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

.CHS:
	mov		byte [bp - 8], 1
    popa

.CHS.1:
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

DispStr:
	pusha
	mov     ah, 0xe
    mov     bx, 0x7
	.Loop:
	lodsb
	test	al, al
	jz		.Exit
	int		0x10
	jmp		.Loop
	.Exit:
	mov		al, `\r`
	int		0x10
	mov		al, `\n`
	int		0x10
	xor		ah, ah
	int 	0x16
	popa
	ret

[EXTERN A20_Gate]
_LoadDone:
	call	A20_Gate
	jc		_LoadFailed

_CopyLoaderParameter:
	mov		ax, 0x1000
	mov		es, ax
	mov		si, bp
	mov		di, Boot_ConfigInfo
	mov		cx, LoaderParameter_size / 2
	rep		movsw

_GetMemMap:
	; http://www.uruk.org/orig-grub/mem64mb.html
	; https://wiki.osdev.org/Detecting_Memory_(x86)
	mov		ax, 0x1000
	mov		es, ax
	mov		di, ARDS_Buf
    xor 	ebx, ebx
	mov 	edx, 0x534d4150 ; "SMAP"
	mov 	ecx, 20
	.E820:
	mov 	eax, 0xE820	; Query System Address Map
    int 	0x15
    jc 		.E801
    cmp 	eax, 0x534d4150
    jne 	.E801
	cmp		ecx, 20
	jne		.E801
    add 	di, 20
    test 	ebx, ebx
    jnz 	.E820
    jmp		.Exit

	.E801:
	mov		ax, 0xE801	; Get Memory Size for Large Configurations
	int		0x15
	jc		.88

	mov		di, ARDS_Buf
	test	ax, ax
	jz		.1
	movzx	eax, ax
	jmp		.2
	.1:
	movzx	eax, cx
	.2:
	test	bx, bx
	jz		.3
	movzx	ebx, bx
	jmp		.4
	.3:
	movzx	ebx, dx
	.4:
	mov		ecx, 1024
	mul		ecx
	mov		ecx, eax
	mov		eax, 0x100000	; 1MB
	stosd
	xor		eax, eax
	stosd
	mov		eax, ecx
	stosd
	mov		eax, edx
	stosd
	mov		eax, 1
	stosd
	mov		eax, 0x10000
	mul		ebx
	mov		ecx, eax
	mov		eax, 0x1000000	; 16MB
	stosd
	xor		eax, eax
	stosd
	mov		eax, ecx
	stosd
	mov		eax, edx
	stosd
	mov		eax, 1
	stosd
	; xor		eax, eax
	; stosd
	; stosd
	; stosd
	; stosd
	; stosd
	jmp		.Exit

	.88:
	mov		ah, 0x88	; Get Extended Memory Size
	int		0x15
	jc		_LoadFailed
	mov		di, ARDS_Buf
	movzx	eax, ax
	mov		ecx, 1024
	mul		ecx
	mov		ecx, eax
	mov		eax, 0x100000	; 1MB
	stosd
	xor		eax, eax
	stosd
	mov		eax, ecx
	stosd
	mov		eax, edx
	stosd
	mov		eax, 1
	stosd
	; xor		eax, eax
	; stosd
	; stosd
	; stosd
	; stosd
	; stosd
	; jmp		_GetMemMap_Exit
	
	.Exit:
	; mov		bp, 0x1000
	; mov		sp, bp

	; mov		ax, 0x1130	; GET FONT INFORMATION
	; mov		bh, 6	; ROM 8x16 font
	; push	bp
	; int		0x10
	; mov		si, bp
	; pop		bp
	; push	0x1000
	; push	es
	; pop		ds
	; pop		es
	; add		si, 32 * 16
	; mov		di, FontBitmap_Buf
	; mov		cx, 95 * 16 / 4
	; rep		movsd

_SetupConsoleMode:
	mov		ax, 0x1000
	mov		ds, ax
	shr		ax, 4
	mov		es, ax
	; jmp		.Legacy
	mov		ax, 0x4F00	; GET SuperVGA INFORMATION
	xor		di, di	; es:di = 0x1000 - Pointer to buffer in which to place VbeInfoBlock structure
	mov		dword [es:di], 'VBE2'
	int		0x10	; BOCHS Fuck the bp
	cmp		ax, 0x4F
	jne		.Legacy
	cmp		dword [es:di], 'VESA'		; VBE Signature
	jne		.Legacy
	mov		ax, [es:di + 4]
	cmp		ax, 0x200	; VBE Version
	jb		.Legacy
	mov		[Console_ConfigInfo + 1], ax
	mov		ax, [es:di + 18]			; Number of 64kb memory blocks
	mov		[Console_ConfigInfo + 17], ax
	mov		ax, [es:di + 20]
	mov		[Console_ConfigInfo + 3], ax

	push	dword [es:di + 6]
	pop		si
	pop		ds
	call	DispStr
	; push	dword [es:di + 22]
	; pop		si
	; pop		ds
	; call	DispStr
	; push	dword [es:di + 26]
	; pop		si
	; pop		ds
	; call	DispStr
	; push	dword [es:di + 30]
	; pop		si
	; pop		ds
	; call	DispStr

	push	dword [es:di + 14]
	pop		si
	pop		ds
	push	0x1000
	pop		es
	mov		di, VideoMode_Buf
	.CopyVideoMode:
	lodsw
	stosw
	cmp		ax, 0xFFFF
	jne		.CopyVideoMode

	.GUI:
	mov		ax, 0x1000
	mov		ds, ax
	shr		ax, 4
	mov		es, ax

	mov		si, VideoMode_Buf
	.LookupTargetMode:
	lodsw
	cmp		ax, 0xFFFF
	je		.Legacy
	mov		cx, ax
	mov		bx, ax

	xor		di, di	; es:di = 0x1000 - Pointer to ModeInfoBlock structure
	mov		ax, 0x4F01	; Return VBE Mode Information
	int		0x10
	cmp		ax, 0x4F
	jne		.LookupTargetMode
	mov		al, [es:di]	; Mode Attributes
	; and		al, 0xBB
	and		al, 0x9B
	cmp		al, 0x9B
	jne		.LookupTargetMode
	mov		al, [es:di + 27]	; memory model	06h for DirectColor
	cmp		al, 6
	jne		.LookupTargetMode
	mov		al, [es:di + 31]	; size of direct color red mask in bits
	cmp		al, 8
	jne		.LookupTargetMode
	mov		al, [es:di + 33]	; size of direct color green mask in bits
	cmp		al, 8
	jne		.LookupTargetMode
	mov		al, [es:di + 35]	; size of direct color blue mask in bits
	cmp		al, 8
	jne		.LookupTargetMode
	mov		al, [es:di + 25]	; bits per pixel
	cmp		al, 24
	jb		.LookupTargetMode
	mov		[Console_ConfigInfo + 19], al
	mov		ax, [es:di + 18]	; horizontal resolution in pixels
	cmp		ax, 800
	jb		.LookupTargetMode
	mov		[Console_ConfigInfo + 5], ax

	mov		ax, [es:di + 16]	; bytes per scan line
	mov		[Console_ConfigInfo + 20], ax
	mov		ax, [es:di + 20]	; vertical resolution in pixels
	mov		[Console_ConfigInfo + 7], ax
	mov		eax, [es:di + 40]	; physical address for flat memory frame buffer
	mov		[Console_ConfigInfo + 9], eax
	; mov		eax, [es:di + 44]	; pointer to start of off screen memory
	; mov		[Console_ConfigInfo + 19], eax
	; mov		ax, [es:di + 48]	; amount of off screen memory in 1k units
	; mov		[Console_ConfigInfo + 23], ax

	; and		bx, 0x1FF
	or		bh, 0x40	; Use linear/flat frame buffer model
						; 0x40 - and clear display memory
						; 0xC0 - and Don't clear display memory
	mov		ax, 0x4F02	; Set VBE Mode
	int		0x10
	cmp		ax, 0x4F
	jne		.LookupTargetMode

	jmp		.Exit

	.Legacy:
	mov		ax, 0x3
	int		0x10
	mov		byte [Console_ConfigInfo], 0
	mov		word [Console_ConfigInfo + 5], 80
	mov		word [Console_ConfigInfo + 7], 25
	mov		dword [Console_ConfigInfo + 9], 0xB8000
	mov		word [Console_ConfigInfo + 17], 80 * 25 * 2	; 0xFA0
	mov		byte [Console_ConfigInfo + 19], 16
	mov		word [Console_ConfigInfo + 20], 80 * 2

	.Exit:

_SetupPCI:
	mov		ax, 0xB101	; PCI_BIOS_PRESENT
	int		0x1A
	jc		.Exit
	test	ah ,ah
	jnz		.Exit
	cmp		edx, 'PCI '
	jne		.Exit
	mov		[PCI_ConfigInfo], bx
	mov		[PCI_ConfigInfo + 2], al
	mov		[PCI_ConfigInfo + 3], cl
	mov		byte [PCI_ConfigInfo + 4], 1

	.Exit:
	
_SetupAPM:
	mov		ax, 0x5300	; APM Installation Check
	xor		bx, bx
	int		0x15
	jc		.Exit
	cmp		bx, 'MP'	; bh='P', bl='M'
	jne		.Exit
	; test	cx, 0xFFE0
	; jnz		.Exit
	; mov		dl, cl
	; and		dl, 0x3
	; cmp		dl, 0x3
	; jne		.Exit
	test	cl, 2
	jz		.Exit
	mov		[APM_ConfigInfo], ax
	mov		[APM_ConfigInfo + 2], cl
	
	mov		ax, 0x5304	; APM Interface Disconnect
	xor		bx, bx
	int		0x15
	
	; xor		esi, esi
	; xor		di, di
	mov		ax, 0x5303	; APM Protected Mode 32-bit Interface Connect
	xor		bx, bx
	int		0x15
	jc		.Exit
	movzx	eax, ax
	shl		eax, 4
	mov		[APM_ConfigInfo + 3], eax
	mov		[APM_ConfigInfo + 7], si
	movzx	ecx, cx
	shl		ecx, 4
	mov		[APM_ConfigInfo + 9], ecx
	shr		esi, 16
	mov		[APM_ConfigInfo + 13], si
	movzx	edx, dx
	shl		edx, 4
	mov		[APM_ConfigInfo + 15], edx
	mov		[APM_ConfigInfo + 19], di
	mov		[APM_ConfigInfo + 21], ebx
	mov		byte [APM_ConfigInfo + 25], 1
	
	.Exit:

_SetupPM:
	cli
	mov		al, 0x80
	out		0x70, al

	xor		al, al
	out		0xf0, al
	out		0xf1, al

	not		al
	out		0xa1, al
	mov		al, 0xfb
	out		0x21, al

    ; db      0x66	; operand-size override prefix
    lgdt    [gdt48_ptr]
    ; db		0x66	; switch to 32-bit operand size
    lidt	[idt48_ptr]
    
    ; mov     eax, cr0
	smsw    ax
	or      al, CR0_PE
    ; mov     cr0, eax	; switch to protected mode
	lmsw    ax
    
    jmp     kcode - knull: dword LdrEntry32
	; jmp		$

[BITS 32]
[EXTERN LdrMain]
ALIGN 4
LdrEntry32:
    mov     ax, kdata - knull
    mov     ds, ax
    mov     es, ax
    mov     ss, ax
    xor     ax, ax
    mov     fs, ax
    mov     gs, ax
    
    mov     ebp, 0x2000
    mov     esp, ebp

	smsw    ax
	or		al, CR0_NE | CR0_MP
	and		al, ~(CR0_EM | CR0_TS)
	lmsw    ax

	finit

	; FNINIT
    
    push	LdrParameter
    call    LdrMain
    
    jmp     $

ALIGN 4
LdrParameter:
	dd $$ + Boot_ConfigInfo
	dd $$ + Console_ConfigInfo
	dd $$ + PCI_ConfigInfo
	dd $$ + APM_ConfigInfo
	dd $$ + ARDS_Buf

ALIGN 4
Boot_ConfigInfo	equ ($-$$)
	dw 0
	dw 0
	dw 0

	db 0
	dw 0
	db 0
	dd 0

	dd 0
	dd 0
	dd 0
	dd 0
	dd 0

	dd 0

ALIGN 4
Console_ConfigInfo	equ ($ - $$)
	db 	1	; GUI			; [Console_ConfigInfo]
	dw	0	; Version		; [Console_ConfigInfo + 1]
	dw	0	; OemVersion	; [Console_ConfigInfo + 3]
	dw	0	; Width			; [Console_ConfigInfo + 5]
	dw	0	; Height		; [Console_ConfigInfo + 7]
	dd	0	; ShowMemBase	; [Console_ConfigInfo + 9]
	dd	$$ + VideoMode_Buf	; [Console_ConfigInfo + 13]
	dw	0	; TotalMemory	; [Console_ConfigInfo + 17]
	db	0	; BitsPerPixel	; [Console_ConfigInfo + 19]
	dw	0	; BytesPerLine	; [Console_ConfigInfo + 20]

ALIGN 4
PCI_ConfigInfo	equ ($ - $$)
	dw 0	; version		; [PCI_ConfigInfo]
	db 0	; hw_mechanism	; [PCI_ConfigInfo + 2]
	db 0	; last_bus		; [PCI_ConfigInfo + 3]
	db 0	; present		; [PCI_ConfigInfo + 4]

ALIGN 4
APM_ConfigInfo	equ ($ - $$)
	dw 0	; Version		; [APM_ConfigInfo]
	db 0	; Flags			; [APM_ConfigInfo + 2]
	dd 0	; CodeSeg32Base	; [APM_ConfigInfo + 3]
    dw 0	; CodeSeg32Len	; [APM_ConfigInfo + 7]
    dd 0	; CodeSeg16Base	; [APM_ConfigInfo + 9]
    dw 0	; CodeSeg16Len	; [APM_ConfigInfo + 13]
    dd 0	; DataSegBase	; [APM_ConfigInfo + 15]
    dw 0	; DataSegLen	; [APM_ConfigInfo + 19]
    dd 0	; EntryPoint	; [APM_ConfigInfo + 21]
	db 0	; Ok			; [APM_ConfigInfo + 25]

ALIGN 4
ARDS_Buf	equ ($ - $$)
%rep 64
	dq 0
	dq 0
	dd 0
%endrep

ALIGN 4
VideoMode_Buf	equ ($ - $$)
	dw 0xffff
	times 127 dw 0

ALIGN 4
gdt_begin:
knull:  ; null seg
	dq  0

kcode:  ; system code seg
	dw  0xffff	; limit[0:15]
	dw	0x0000	; base[0:15]
	db	0x00	; base[16:23]
	db	0x9a	; P[1]:DPL[00]:S[1]:Type[1010]
	db 	0xcf	; G[1]:D_B[1]:L[0]:AVL[0]:limit[16:19]
	db	0x00	; base[24:31]

kdata:	; system data/stack seg
	dw	0xffff
	dw	0x0000
	db	0x00
	db 	0x92
	db 	0xcf
	db	0x00

; apm_code32:	; apm code32 seg
;     dw  0xffff
; 	dw	0xf000
;     db  0x00
; 	db	0x9a
; 	db	0x40
; 	db	0x00

; apm_code16: ; apm code16 seg
;     dw  0xffff
; 	dw	0xf000
;     db  0x00
; 	db	0x9a
; 	db	0x00
; 	db	0x00

; apm_data:   ; apm data seg
;     dw  0xffff
; 	dw	0xf000
;     db  0x00
; 	db	0x92
; 	db	0x40
; 	db	0x00

; pnp_code16:
; 	dw  0xffff
; 	dw	0xf000
;     db  0x00
; 	db	0x9a
; 	db	0x00
; 	db	0x00

gdt_dummpy:  ; dummpy seg
TIMES 32 - (gdt_dummpy - gdt_begin) / 8 dq 0
gdt_end:

ALIGN 2
gdt48_ptr	equ ($-$$)
    dw  (gdt_end - gdt_begin) - 1 	; limit
    dd  gdt_begin       			; base

ALIGN 4
idt_begin:
TIMES 256 dq 0
idt_end:

ALIGN 2
idt48_ptr	equ ($-$$)
    dw  (idt_end - idt_begin) - 1	; limit
    dd  idt_begin       			; base

