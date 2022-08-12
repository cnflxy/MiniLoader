
[BITS 16]

[GLOBAl A20_Gate]
A20_Gate:
    call	CheckA20
    jnc 	.Exit

    call 	A20_Gate_Bios
    call 	CheckA20
    jnc 	.Exit

    call 	A20_Gate_8042
    call 	CheckA20
    jnc 	.Exit

    call 	A20_Gate_FastGate
    call 	CheckA20
    jnc 	.Exit

    call 	A20_Gate_PortEE
    call 	CheckA20
    jnc 	.Exit
    
    .Exit:
    ret

A20_Gate_Bios:
    ; stc
    ; mov ax, 0x2403              ;--- Check A20-Gate Support ---
    ; int 0x15
    ; jc _EnableA20LineByBios__Exit    ;INT 15h is not supported
    ; stc
    ; test ah, ah
    ; jnz _EnableA20LineByBios__Exit   ;INT 15h is not supported

    ; stc
    ; mov ax, 0x2402                ;--- Get A20-Gate Status ---
    ; int 0x15
    ; jc _EnableA20LineByBios__Exit              ;couldn't get status
    ; stc
    ; test ah, ah
    ; jnz _EnableA20LineByBios__Exit              ;couldn't get status
 
    ; test al, 1
    ; jnz _EnableA20LineByBios__Activated  ;A20 is already activated

    ; stc
    mov 	ax, 0x2401                          ;--- A20-Gate Activate ---
    int 	0x15
    ; jc _A20_Gate_ByBios__Exit           ;couldn't activate
    ; stc
    ; test ah, ah
    ; jnz _A20_Gate_ByBios__Exit          ;couldn't activate

; _A20_Gate_ByBios__Activated:
;     clc
; _A20_Gate_ByBios__Exit:
    ret

A20_Gate_8042:
    ; call 	Wait8042Ready
    mov 	al, 0xAD
    out 	0x64, al     ; disable first PS/2 port

    mov 	al, 0xA7
    out 	0x64, al     ; disable second PS/2 port

    .empty_outbuf:
    in 		al, 0x64
    test 	al, 1
    jz      .empty
    in      al, 0x60
    jmp     .empty_outbuf
    .empty:

    call 	Wait_8042_Write
    mov 	al, 0xD0
    out 	0x64, al    ; read controller output port

    call 	Wait_8042_Read
    in 		al, 0x60    ; read it
    push 	ax

    call 	Wait_8042_Write
    mov 	al, 0xD1    ; write it
    out 	0x64, al

    call 	Wait_8042_Write
    pop 	ax
    or 		al, 2       ; A20
    out 	0x60, al

    call 	Wait_8042_Write
    mov 	al, 0xAE
    out 	0x64, al     ; enable first PS/2 port

    call 	Wait_8042_Write
    
    ret

A20_Gate_FastGate:
    in 		al, 0x92    ; System Control Port A
    test 	al, 2
    jnz 	.Exit
    or 		al, 2
    and 	al, 0xFE        ; make sure bit 0(hot reset) is 0
    out 	0x92, al

    .Exit:
    ret

A20_Gate_PortEE:
    in 		al, 0xEE
    ret

CheckA20:
    push    si
    push    di
    push    ax
    push 	ds
    push	es

    xor 	ax, ax
    mov 	ds, ax
    not 	ax ; ax = 0xFFFF
    mov 	es, ax

    mov 	si, 0x0500  ; ds:si = 0x0500
    mov 	di, 0x0510  ; es:di = 0x100500, wrapped address = 0x0500

    mov 	al, [ds:si]
    push 	ax
    mov 	al, [es:di]
    push 	ax

    mov 	byte [ds:si], 0x00
    mov 	byte [es:di], 0xFF
 
    cmp 	byte [ds:si], 0xFF

    pop 	ax
    mov 	byte [es:di], al
    pop 	ax
    mov 	byte [ds:si], al

    stc
    je 		.Exit
    clc

    .Exit:
    
    pop 	es
    pop 	ds
    pop     ax
    pop     di
    pop     si
    ret

Wait_8042_Read:
    in 		al, 0x64
    test 	al, 1
    jnz 	Wait_8042_Read
    ret

Wait_8042_Write:
    in 		al, 0x64
    test 	al, 2
    jnz 	Wait_8042_Write
    ret
