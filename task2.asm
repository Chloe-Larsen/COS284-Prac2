global _start
section .bss
    buffer resb 4000
section .text
    
_start    
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 4000
    syscall

    cmp rax, 0
    jle exit

    mov rbx, rax
    mov rcx, 0  

loopStart:
    cmp rcx, rbx
    jge writeOutput

    mov al, [buffer + rcx]

checkUpper
    cmp al, 'A'
    jl storeChar
    cmp al, 'Z'
    jg  checkLower

    add al, 3
    cmp al, 'Z'
    jle storeChar
    sub al, 26
    jmp storeChar

checkLower
    cmp al, 'a'
    jl storeChar
    cmp al, 'z'
    jg  storeChar

    add al, 3
    cmp al, 'z'
    jle storeChar
    sub al, 26    

storeChar
    mov [buffer + rcx], al
    inc rcx
    jmp loopStart

writeOutput
    mov rax, 1 
    mov rdi, 1
    mov rsi, buffer
    mov rdx, rbx
    syscall

exit:
    mov rax, 60
    mov rdi, 0
    syscall