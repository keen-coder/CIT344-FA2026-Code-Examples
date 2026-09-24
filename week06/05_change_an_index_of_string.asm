;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 23, 2026
;
; Demonstrates how to change any index of a string to another character.
;
; assembler command:    yasm -felf64 -gdwarf2 05_change_an_index_of_string.asm -l 05_change_an_index_of_string.lst
; linker command:       ld -g -o 05_change_an_index_of_string 05_change_an_index_of_string.o
; execute command:      ./05_change_an_index_of_string
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

    ; Change the character at index 2 to and X
    mov byte[string + 2], "X"

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, string
    mov rdx, stringLen
    syscall

exit:
    mov rax, SYS_EXIT        
    mov rdi, EXIT_SUCCESS
    syscall