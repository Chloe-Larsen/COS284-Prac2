global _start

section .data
    newline db 10

section .bss
    buffer resb 4000
    keyword resb 4000

section .text
_start:    
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 4000
    syscall
    
    mov rcx, rax
    mov rsi, buffer
    mov rdi, keyword
    mov rbx, 0
    mov r12, 0
    mov r13, 0
parseKeyword:
    cmp r13, rcx
    jge done
    
    mov al, [rsi + r13]
    cmp al, 10
    je keywordDone
        
    mov [rdi + r12], al
    inc r12
    inc r13
    jmp parseKeyword

keywordDone:
    inc r13
    mov r14, r13

processText:
    cmp r13, rcx
    jge done
    
    mov al, [rsi + r13]
    cmp al, 'A'
    jb notLetter
    cmp al, 'Z'
    jbe uppercaseLetter
    
    cmp al, 'a'
    jb notLetter
    cmp al, 'z'
    jbe lowercaseLetter
    jmp notLetter

uppercaseLetter:    
    sub al, 'A'
        
    push rax
    mov rax, rbx
    xor rdx, rdx
    div r12
    mov rbx, rdx
    mov al, [keyword + rbx]
    sub al, 'a'
        
    pop rdx
    add al, dl
    cmp al, 26
    jb uppercaseEncryptDone
    sub al, 26
    
uppercaseEncryptDone:
    add al, 'A'
    mov [rsi + r13], al
    inc rbx
    jmp nextChar

lowercaseLetter:    
    sub al, 'a'
        
    push rax
    mov rax, rbx
    xor rdx, rdx
    div r12
    mov rbx, rdx
    mov al, [keyword + rbx]
    sub al, 'a'
        
    pop rdx
    add al, dl
    cmp al, 26
    jb lowercaseEncryptDone
    sub al, 26
    
lowercaseEncryptDone:
    add al, 'a'
    mov [rsi + r13], al
    inc rbx
    jmp nextChar

notLetter:    
    nop

nextChar:
    inc r13
    jmp processText

done:    
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    add rsi, r14
    sub rcx, r14
    mov rdx, rcx
    syscall
    
exit:
    mov rax, 60
    mov rdi, 0
    syscall