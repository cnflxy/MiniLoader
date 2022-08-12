
[BITS 32]

%macro SaveRegs 0
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
%endmacro

%macro StoreRegs 0
	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
%endmacro

%macro IdtEntry 2	; haven't error code
[GLOBAL %1]
%1:
	push	dword 0
	SaveRegs
	push	dword [esp + 4 * 6]
	push 	dword %2
	call	common_exception_handler
	add		esp, 8
	StoreRegs
	add		esp, 4
	iretd
%endmacro

%macro IdtEntry2 2	; have error code
[GLOBAL %1]
%1:
	SaveRegs
	push	dword [esp + 4 * 6]
	push 	dword %2
	call	common_exception_handler
	add		esp, 8
	StoreRegs
	add		esp, 4
	iretd
%endmacro

[EXTERN common_exception_handler]

IdtEntry	entry_DivideError, 0
IdtEntry	entry_DebugException, 1
IdtEntry	entry_NMIException, 2
IdtEntry	entry_Breakpoint, 3
IdtEntry	entry_Overflow, 4
IdtEntry	entry_BoundException, 5
IdtEntry	entry_UndefinedOpcode, 6
IdtEntry	entry_NoMathCoprocessor, 7
IdtEntry2	entry_DoubleFault, 8
IdtEntry	entry_CorprocessorOverrun, 9
IdtEntry2	entry_InvalidTSS, 10
IdtEntry2	entry_SegmentNotPresent, 11
IdtEntry2	entry_StackSegmentFault, 12
IdtEntry2	entry_GeneralProtection, 13
IdtEntry2	entry_PageFault, 14
;	15 is reserved
IdtEntry	entry_MathFault, 16
IdtEntry2	entry_AlignmentCheck, 17
IdtEntry	entry_MachineCheck, 18
IdtEntry	entry_SIMDException, 19
IdtEntry	entry_VirtualizationException, 20
;	21-31 is reserved

