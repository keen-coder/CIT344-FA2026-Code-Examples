;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 23, 2026
;
; Demonstrates how to use the unconditional jmp command. jmp can jump to any label you specify
;
; assembler command:    yasm -felf64 -gdwarf2 01_jmp_example.asm -l 01_jmp_example.lst
; linker command:       ld -g -o 01_jmp_example 01_jmp_example.o
; execute command:      ./01_jmp_example
;--------------------------------------------------------------------------------------------------


section .data ;------------------------------------------------------------------------------------

SYS_WRITE       equ     1
STDOUT          equ     1

SYS_EXIT        equ     60
EXIT_SUCCESS    equ     0

; Special Characters
LF              equ     10
NULL            equ     0

skippedMsg  db      'You should not see this!', NULL, LF
skippedLen  equ     $ - skippedMsg

helloMsg    db      'Hello from the JMP target!', NULL, LF
helloLen    equ     $ - helloMsg

;--------------------------------------------------------------------------------------------------


section .bss ;-------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------

section .text

global _start

_start:
    ; Jump over the first print
    jmp printHello

printSkipped: 
    mov rax, SYS_WRITE          
    mov rdi, STDOUT          
    mov rsi, skippedMsg
    mov rdx, skippedLen
    syscall

    jmp exitProgram

printHello:
    mov rax, SYS_WRITE          
    mov rdi, STDOUT          
    mov rsi, helloMsg
    mov rdx, helloLen
    syscall

exitProgram:
    mov rax, SYS_EXIT        
    mov rdi, EXIT_SUCCESS
    syscall