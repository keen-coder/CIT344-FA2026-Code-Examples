; Keenan Knaur, CIT-344

; Program to show a function that takes six parameters. The first six integer
; parameters are passed in registers (RDI, RSI, RDX, RCX, R8, R9), so the stack
; is not needed. sumSix adds the six values and returns the total in RAX.

; This program does not use local variables, stack frames, or preserved registers.

section .data ;=================================================================

; Constants for sys_exit()
EXIT_SUCCESS    equ     0       ; successful program execution
SYS_EXIT        equ     60      ; call code for termination

; Constants for sys_write()
STDOUT          equ     1       ; The standard output code (1 is for the console)
SYS_WRITE       equ     1       ; Call code for the write system service

section .bss ;==================================================================

qSum             resq    1       ; buffer to hold the sum

section .text ;=================================================================

global _start
_start:

    ; sumSix(10, 20, 30, 40, 50, 60)
    mov rdi, 10               ; 1st parameter (a)
    mov rsi, 20               ; 2nd parameter (b)
    mov rdx, 30               ; 3rd parameter (c)
    mov rcx, 40               ; 4th parameter (d)
    mov r8, 50                ; 5th parameter (e)
    mov r9, 60                ; 6th parameter (f)
    call sumSix               ; RAX = sum of the six values

    ; At this point the sum (return value) is in the RAX register
    ; We can save it in a variable for later.
    mov qword[qSum], rax

exit:
    ; sys_exit()
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

; =================================================================================================
; FUNCTION:     long sumSix(long a, long b, long c, long d, long e, long f)
; PURPOSE:      Adds six integers together and returns the total.
; INPUT:        RDI = a
;               RSI = b
;               RDX = c
;               RCX = d
;               R8  = e
;               R9  = f
; OUTPUT:       RAX = a + b + c + d + e + f
; CLOBBERED:    RAX
; NOTE:         Does not call a system call, so RCX is not overwritten. A function that
;               calls syscall would clobber RCX and R11.
; =================================================================================================
global sumSix
sumSix:
    mov rax, rdi             ; RAX = a
    add rax, rsi             ; add b
    add rax, rdx             ; add c
    add rax, rcx             ; add d
    add rax, r8              ; add e
    add rax, r9              ; add f
    ret