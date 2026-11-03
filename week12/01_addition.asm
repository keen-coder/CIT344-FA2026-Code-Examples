;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; November 2, 2026
;
; Example 1:
; Demonstrates several ways to use the ADD instruction.
;
; The ADD instruction may be used with:
; 1. Immediate values
; 2. Register values
; 3. Memory values
;
;--------------------------------------------------------------------------------------------------

section .data

    bNum1      db      5
    bNum2      db      4
    result     db      0

section .text
global _start

_start:

;--------------------------------------------------------------------------------------------------
; Example 1: Addition Using An Immediate Value
;--------------------------------------------------------------------------------------------------

ImmediateExample:

    mov al, 5
    add al, 4

;--------------------------------------------------------------------------------------------------
; Example 2: Addition Using a Register Value
;--------------------------------------------------------------------------------------------------

RegisterExample:

    mov al, 5
    mov bl, 4 
    add al, bl ; AL now contains: 9

;--------------------------------------------------------------------------------------------------
; Example 3: Addition Using a Memory Value
;--------------------------------------------------------------------------------------------------

MemoryExample:
    mov al, byte [bNum1]  ; Move  
    add al, byte [bNum2]  ; Add the value stored in memory 
                          ; AL now contains: 9
    mov byte[result], al  ; Store the result back into memory

Exit:
    mov rax, 60
    mov rdi, 0
    syscall