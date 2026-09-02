global _start

section .data
    newline db 10

section .bss
    buffer resb 4000
    temp db 0

section .text

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 4000
    syscall

    cmp rax, 0
    je exit

    mov rcx, rax
    mov rsi, buffer

processByte:
    xor byte [rsi], 0x2a
        
    movzx rbx, byte [rsi]
    shr rbx, 4
    cmp rbx, 9
    jle highDigit
    add rbx, 87
    jmp printHigh
highDigit:
    add rbx, 48

printHigh:
    mov [temp], bl
    push rcx
    push rsi
    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, temp
    mov rdx, 1
    syscall
    pop rax
    pop rsi
    pop rcx
    
    movzx rbx, byte [rsi]
    and rbx, 0x0f
    cmp rbx, 9
    jle lowDigit
    add rbx, 87
    jmp printLow
lowDigit:
    add rbx, 48

printLow:
    mov [temp], bl
    push rcx
    push rsi
    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, temp
    mov rdx, 1
    syscall
    pop rax
    pop rsi
    pop rcx

    inc rsi
    dec rcx
    jnz processByte
    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
    syscall