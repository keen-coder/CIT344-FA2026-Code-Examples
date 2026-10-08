;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; October 7, 2026
;
; Demonstrates how to read a character and say whether it is uppercase or lowercase
;
; assembler command:    yasm -felf64 -gdwarf2 01_char_comparison.asm -l 01_char_comparison.asm.lst
; linker command:       ld -g -o 01_char_comparison.asm 01_char_comparison.asm.o
; execute command:      ./01_char_comparison.asm
;--------------------------------------------------------------------------------------------------

section .data

    SYS_WRITE       equ     1   
    STDOUT          equ     1   

    SYS_READ        equ     0
    STDIN           equ     0

    SYS_EXIT        equ     60  
    EXIT_SUCCESS    equ     0  

    ; Special Characters
    LF              equ     10
    NULL            equ     0

    prompt      db "Enter a character: "
    promptLen   equ $ - prompt

    msgUpper    db "uppercase", LF
    upperLen    equ $ - msgUpper

    msgNot      db "not uppercase", LF
    notLen      equ $ - msgNot

section .bss

    inputChar   resb 1

section .text
global _start

_start:

    ; Print prompt
    mov rax, SYS_WRITE      
    mov rdi, STDOUT         
    mov rsi, prompt
    mov rdx, promptLen
    syscall

    ; Read one character
    mov rax, SYS_READ          
    mov rdi, STDIN          
    mov rsi, inputChar
    mov rdx, 1
    syscall

    ; Get character into AL
    mov al, byte [inputChar]

    ; Is it less than 'A'?
    cmp al, 'A'     ; 'A' is 65 in ASCII
    jb NotUpper

    ; Is it greater than 'Z'? 
    cmp al, 'Z'     ; 'Z' is 90 in ASCII
    ja NotUpper

Upper:

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, msgUpper
    mov rdx, upperLen
    syscall

    jmp Exit

NotUpper:

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, msgNot
    mov rdx, notLen
    syscall

Exit:

    mov rax, SYS_EXIT         ; SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall