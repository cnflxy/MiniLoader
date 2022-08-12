
[BITS 32]

%macro StoreTrapFrame 0
	push	dword [esp + 4 * 4]	; EFLAGS
	push	dword [esp + 4 * 4]	; CS
	push	dword [esp + 4 * 4]	; EIP
	pushad
	; pushfd
	mov		eax, cr4
	push	eax
	mov		eax, cr3
	push	eax
	mov		eax, cr2
	push	eax
	mov		eax, cr0
	push	eax
%endmacro

%macro RestoreTrapFrame 0
	add		esp, 16
	; pop		eax
	; mov		cr0, eax
	; pop		eax
	; mov		cr2, eax
	; pop		eax
	; mov		cr3, eax
	; pop		eax
	; mov		cr4, eax
	; popfd
	popad
	add		esp, 12
%endmacro

%macro IdtTrap 2	; haven't error code
[GLOBAL %1]
ALIGN 4
%1:
	push	dword 0
	push 	dword %2
	StoreTrapFrame
	call	common_trap_handler
	RestoreTrapFrame
	add		esp, 8
	iretd
%endmacro

%macro IdtTrap2 2	; have error code
[GLOBAL %1]
ALIGN 4
%1:
	push 	dword %2
	StoreTrapFrame
	call	common_trap_handler
	RestoreTrapFrame
	add		esp, 8
	iretd
%endmacro

[EXTERN common_trap_handler]

IdtTrap		kTrap0, 0x00
IdtTrap		kTrap1, 0x01
IdtTrap		kTrap2, 0x02
IdtTrap		kTrap3, 0x03
IdtTrap		kTrap4, 0x04
IdtTrap		kTrap5, 0x05
IdtTrap		kTrap6, 0x06
IdtTrap		kTrap7, 0x07
IdtTrap2	kTrap8, 0x08
IdtTrap		kTrap9, 0x09
IdtTrap2	kTrap10, 0x0A
IdtTrap2	kTrap11, 0x0B
IdtTrap2	kTrap12, 0x0C
IdtTrap2	kTrap13, 0x0D
IdtTrap2	kTrap14, 0x0E
;	15 is reserved
IdtTrap		kTrap16, 0x10
IdtTrap2	kTrap17, 0x11
IdtTrap		kTrap18, 0x12
IdtTrap		kTrap19, 0x13
IdtTrap		kTrap20, 0x14
;	21-31 is reserved
; IRQ entry
IdtTrap 	kTrap32, 0x20
IdtTrap 	kTrap33, 0x21
; IdtTrap 	kTrap34, 0x22  ; cascaded
IdtTrap 	kTrap35, 0x23
IdtTrap 	kTrap36, 0x24
IdtTrap 	kTrap37, 0x25
IdtTrap 	kTrap38, 0x26
IdtTrap 	kTrap39, 0x27
IdtTrap 	kTrap40, 0x28
IdtTrap 	kTrap41, 0x29
IdtTrap 	kTrap42, 0x2a
IdtTrap 	kTrap43, 0x2b
IdtTrap 	kTrap44, 0x2c
IdtTrap 	kTrap45, 0x2d
IdtTrap 	kTrap46, 0x2e
IdtTrap 	kTrap47, 0x2f

IdtTrap		kTrapReserved, 0x0F	; just make a new entry

