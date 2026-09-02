global _start
section .bss     
    buffer resb 4000
section .text
    
_start    
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 512
    syscall

    cmp rax, 0
    jle exit
    
    mov r12, rax
    mov rcx, 0
    mov rbx, 0

parseNumber
    cmp rcx, r12
    jge exit
    mov al, [buffer + rcx]
    inc rcx
    
    cmp al, 10
    je calculateShift
    
    ; Convert ASCII digit to integer
    sub al, '0'
    imul rbx, 10
    movzx rax, al
    add rbx, rax
    jmp parseNumber

calculateShift
    mov rax, rbx
    mov rdx, 0
    mov r8, 26
    div r8; rax = quotient, rdx = remainder
    mov r13, rdx
    mov r14, rcx

loopStart:
    cmp rcx, r12
    jge writeOutput

    mov al, [buffer + rcx]

checkUpper
    cmp al, 'A'
    jl storeChar
    cmp al, 'Z'
    jg  checkLower

    add al, r13b
    cmp al, 'Z'
    jle storeChar
    sub al, 26
    jmp storeChar

checkLower
    cmp al, 'a'
    jl storeChar
    cmp al, 'z'
    jg  storeChar

    add al, r13b
    cmp al, 'z'
    jle storeChar
    sub al, 26    

storeChar
    mov [buffer + rcx], al
    inc rcx
    jmp loopStart

writeOutput
    mov rdx, r12
    sub rdx, r14

    mov rax, 1 
    mov rdi, 1
    lea rsi, [buffer + r14]    
    syscall

exit:
    mov rax, 60
    mov rdi, 0
    syscall