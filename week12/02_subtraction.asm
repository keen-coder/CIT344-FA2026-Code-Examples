;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; November 2, 2026
;
; Example 2:
; Demonstrates several ways to use the SUB instruction.
;
; The SUB instruction may be used with:
; 1. Immediate values
; 2. Register values
; 3. Memory values
;
;--------------------------------------------------------------------------------------------------

section .data

    bNum1      db      9
    bNum2      db      4
    result     db      0

section .text
global _start

_start:

;--------------------------------------------------------------------------------------------------
; Example 1: Subtraction Using An Immediate Value
;--------------------------------------------------------------------------------------------------

ImmediateExample:

    mov al, 9
    sub al, 4 ; AL now contains: 5

;--------------------------------------------------------------------------------------------------
; Example 2: Subtraction Using a Register Value
;--------------------------------------------------------------------------------------------------

RegisterExample:

    mov al, 9
    mov bl, 4
    sub al, bl ; AL now contains: 5

;--------------------------------------------------------------------------------------------------
; Example 3: Subtraction Using a Memory Value
;--------------------------------------------------------------------------------------------------

MemoryExample:

    mov al, byte [bNum1]
    sub al, byte [bNum2]    ; Subtract the value stored in memory
                            ; AL now contains: 5
    mov byte [result], al   ; result now contains: 5

Exit:

    mov rax, 60
    mov rdi, 0
    syscall