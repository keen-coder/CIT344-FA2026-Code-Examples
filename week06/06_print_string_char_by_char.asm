;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 23, 2026
;
; Demonstrates how to print a string character by character. We do this by incrementing through
; each memory address of the string.
;
; assembler command:    yasm -felf64 -gdwarf2 06_print_string_char_by_char.asm -l 06_print_string_char_by_char.lst
; linker command:       ld -g -o 06_print_string_char_by_char 06_print_string_char_by_char.o
; execute command:      ./06_print_string_char_by_char
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

string          db      "Pennsylvania College of Technology!", NULL
stringLen       equ     $ - string


;--------------------------------------------------------------------------------------------------

section .text

global _start

_start:

    ; We are going to iterate over our string with indexing.
    ; In assembly, you add an offset to the initial memory address
    ; then increment the offset. Since each character of a string is
    ; a byte, we can increment the offset by 1 each time.

    ; The offset should be stored in a register
    mov rbx, 0

printCharByCharLoop:
    ; Print the next character in the string
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [string + rbx]
    mov rdx, 1
    syscall

    ; Print a new line character
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newLine
    mov rdx, 1
    syscall

    ; increment the offset (index) so we can get to the next character
    inc rbx

    ; check to see if we hit the NULL character yet
    ; NOTE: The NULL character only exists because I added it when I defined the string.
    cmp byte[string + rbx], NULL
    jne printCharByCharLoop

exit:
    mov rax, SYS_EXIT        
    mov rdi, EXIT_SUCCESS
    syscall