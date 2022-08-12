[BITS 32]

; u32 apm_entry_call(u32 seg, u32 entrypoint, u32 func, u32 devid, u32 pstate)
[GLOBAL apm_entry_call]
apm_entry_call:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    mov     ah, 0x53
    mov     al, [ebp + 16]
    mov     bx, [ebp + 20]
    mov     cx, [ebp + 24]
    push    word [ebp + 8]
    push    dword [ebp + 12]
    call    far [esp]
    add     esp, 6
    jc     .Exit
    xor     ah, ah
    .Exit:
    movzx   eax, ah
    pop     ecx
    pop     ebx
    pop     ebp
    ret
