;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 23, 2026
;
; Demonstrates how to use cmp and jumps to loop a section of your code. This example
; prints the alphabet by incrementing the UNICODE value of a character starting from A
;
; assembler command:    yasm -felf64 -gdwarf2 03_iteration_with_jumps.asm -l 03_iteration_with_jumps.asm.lst
; linker command:       ld -g -o 03_iteration_with_jumps 03_iteration_with_jumps.o
; execute command:      ./03_iteration_with_jumps
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

currChar        db      "A"
count           db      0
maxCount        equ     26
;--------------------------------------------------------------------------------------------------

section .text

global _start

_start:

alphabetLoop:    

    ; Print the next character in the alphabet
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, currChar
    mov rdx, 1
    syscall

    ; Add one to the Unicode value of current char to move to the next character
    ; I will use the add instruction to demonstrate its use.
    add byte[currChar], 1   ;   currChar += 1
    
    ; Increment the counter, I will use inc this time
    inc byte[count] 

    ; Check the count and see if we need to keep looping
    cmp byte[count], maxCount
    jne alphabetLoop

    ; Print a new line character at the end
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newLine
    mov rdx, 1
    syscall

exit:
    mov rax, SYS_EXIT        
    mov rdi, EXIT_SUCCESS
    syscall