;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 23, 2026
;
; Demonstrates how to use the cmp and conditional jump instructions.
;
; assembler command:    yasm -felf64 -gdwarf2 02_compare_jump_example.asm -l 02_compare_jump_example.lst
; linker command:       ld -g -o 02_compare_jump_example 02_compare_jump_example.o
; execute command:      ./02_compare_jump
;--------------------------------------------------------------------------------------------------

section .data ;------------------------------------------------------------------------------------
SYS_WRITE       equ     1   
STDOUT          equ     1   

SYS_READ        equ     0
STDIN           equ     0

SYS_EXIT        equ     60  
EXIT_SUCCESS    equ     0  

; Special Characters
LF              equ     10
NULL            equ     0

charSize        equ     2

prompt          db      "Enter a character: ", NULL
promptLen       equ      $ - prompt

strCharsEqual       db      "The characters are equal!", NULL, LF
strCharsEqualLen    equ     $ - strCharsEqual

strCharsNotEqual    db      "The characters are not equal!", NULL, LF
strCharsNotEqualLen    equ     $ - strCharsNotEqual
;--------------------------------------------------------------------------------------------------

section .bss ;-------------------------------------------------------------------------------------
charA       resb    2   ; Need to account for the enter key press
charB       resb    2   ; Need to account for the enter key press
;--------------------------------------------------------------------------------------------------

section .text

global _start

_start:
    ; Read the first character and store it
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, prompt
    mov rdx, promptLen
    syscall

    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, charA
    mov rdx, charSize
    syscall

    ; Read the second character and store it
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, prompt
    mov rdx, promptLen
    syscall

    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, charB
    mov rdx, charSize
    syscall

    ; Compare the characters and jump
    ; since only one of the operands for cmp is allowed to be a memory location (variable)
    ; I am just going to move both of the values into registers
    mov bl, byte [charA]
    mov cl, byte [charB]

    cmp bl, cl 
    je charsEqual
    jne charsNotEqual

charsEqual:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strCharsEqual
    mov rdx, strCharsEqualLen
    syscall

    jmp exit ; Unconditional jump to the exit to skip the not equal section

charsNotEqual:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strCharsNotEqual
    mov rdx, strCharsNotEqualLen
    syscall

exit:
    mov rax, SYS_EXIT        
    mov rdi, EXIT_SUCCESS
    syscall