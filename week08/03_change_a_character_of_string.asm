;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 23, 2026
;
; Demonstrates how to change any index of a string to another character.
;
; assembler command:    yasm -felf64 -gdwarf2 05_change_a_character_of_string.asm -l 05_change_a_character_of_string.lst
; linker command:       ld -g -o 05_change_a_character_of_string 05_change_a_character_of_string.o
; execute command:      ./05_change_a_character_of_string
;--------------------------------------------------------------------------------------------------

section .data ;------------------------------------------------------------------------------------
SYS_WRITE       equ     1   
STDOUT          equ     1   

SYS_EXIT        equ     60  
EXIT_SUCCESS    equ     0  

; Special Characters
LF              equ     10
NULL            equ     0
newLine         db      LF

string          db      "HELLO", NULL, LF
stringLen       equ     $ - string

;--------------------------------------------------------------------------------------------------

section .text

global _start

_start:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, string
    mov rdx, stringLen
    syscall

    ; Load the index we want to change into a register
    mov rbx, 2

    ; Use the RBX register (which holds the index) to compute
    ; the memory address of the character at index 2
    ; the string name holds the memory address of the first character.
    ; We add RBX to offset the base address, then dereference to get the character.
    mov byte[string + rbx], "X"

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, string
    mov rdx, stringLen
    syscall

exit:
    mov rax, SYS_EXIT        
    mov rdi, EXIT_SUCCESS
    syscall