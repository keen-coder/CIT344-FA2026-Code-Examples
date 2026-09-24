;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 23, 2026
;
; Demonstrates how to use the loop instruction to loop a section of your code. This example
; prints the alphabet by incrementing the UNICODE value of a character starting from A
;
; assembler command:    yasm -felf64 -gdwarf2 04_iteration_with_loop_instruction.asm -l 04_iteration_with_loop_instruction.lst
; linker command:       ld -g -o 04_iteration_with_loop_instruction 04_iteration_with_loop_instruction.o
; execute command:      ./04_iteration_with_loop_instruction
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
maxCount        equ     26
;--------------------------------------------------------------------------------------------------

section .text

global _start

_start:

    ; Initialize the rcx register to the number of iterations you want.
    mov rcx, maxCount

alphabetLoop:

    ; NOTE: Since we are printing in the loop, when you use the syscall
    ; instruction it will destroy what is in the RCX register, we need to 
    ; Preserve the RCX register before the syscall and restore it after.
    ; We can use the push and pop instructions for this.
    ; For now, ONLY use push and pop to save the RCX register if you are
    ; going to use the loop instruction and syscalls in the loop.
    ; We will talk about push and pop much later.

    ; push will save the value of RCX to the stack memory
    push rcx

    ; Print the next character in the alphabet
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, currChar
    mov rdx, 1
    syscall

    ; pop restores the last value saved on the stack.
    pop rcx

    ; Add one to the Unicode value of current char to move to the next character
    ; I will use the add instruction to demonstrate its use.
    add byte[currChar], 1   ;   currChar += 1
    
    loop alphabetLoop

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