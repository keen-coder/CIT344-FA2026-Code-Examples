;Keenan Knaur, CIT-344

; Program to show a function with 10 parameters: 6 passed in registers and 4 passed on the stack.
; It also shows both kinds of saved registers:
;   - caller-saved: R10 and R11. compute() overwrites them, so the caller saves them before the arguments.
;   - callee-saved: RBX, R12, and R13. compute() uses them, so it saves them in its prologue and restores them in its epilogue.
; Neither R10 nor R11 is an argument register. RCX and RDX are argument registers, so the caller
; does not need them saved in this example.
;
; compute() adds ten integers and returns the total in RAX.
; The sum is stored in sumResult.

section .data ;=================================================================

; Constants for sys_exit()
EXIT_SUCCESS    equ     0       ; successful program execution
SYS_EXIT        equ     60      ; call code for termination

section .bss ;==================================================================

sumResult       resq    1       ; holds the value returned by compute (should be 70)

section .text ;=================================================================

global _start
_start:

    ; Give the saved registers known values to simulate them being used before the function is called.
    mov rbx, 23              ; RBX = 23 (callee-saved: compute() must restore it)
    mov r12, 42              ; R12 = 42 (callee-saved: compute() must restore it)
    mov r13, 17              ; R13 = 17 (callee-saved: compute() must restore it)
    mov r10, 31              ; R10 = 31 (caller-saved: compute() may change it)
    mov r11, 58              ; R11 = 58 (caller-saved: compute() may change it)

    ; The caller saves its caller-saved registers before it sets up any arguments.
    push r10                 ; save R10 (the caller's value)
    push r11                 ; save R11 (the caller's value)

    ; The first six arguments go in registers.
    mov rdi, 4               ; 1st parameter (a)
    mov rsi, 14              ; 2nd parameter (b)
    mov rdx, 7               ; 3rd parameter (c)
    mov rcx, 2               ; 4th parameter (d)
    mov r8, 9                ; 5th parameter (e)
    mov r9, 5                ; 6th parameter (f)

    ; The last four arguments go on the stack. Push the 10th first, so the 7th ends up at the lowest address.
    push 6                   ; 10th parameter (j)
    push 8                   ; 9th parameter (i)
    push 4                   ; 8th parameter (h)
    push 11                  ; 7th parameter (g)

    call compute             ; RAX = sum of the ten values

    ; The caller removes the four stack arguments it pushed (4 x 8 bytes).
    add rsp, 32

    ; The caller restores its saved registers, in reverse order of the pushes.
    pop r11                  ; restore R11
    pop r10                  ; restore R10

    mov qword[sumResult], rax       ; should be 70 (4 + 14 + 7 + 2 + 9 + 5 + 11 + 4 + 8 + 6)

exit:
    ; sys_exit()
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

; =================================================================================================
; FUNCTION:     long compute(long a, long b, long c, long d, long e, long f,
;                            long g, long h, long i, long j)
; PURPOSE:      Adds ten integers together and returns the total.
; INPUT:        RDI = a
;               RSI = b
;               RDX = c
;               RCX = d
;               R8  = e
;               R9  = f
;               [RBP+16] = g (7th parameter, on the stack)
;               [RBP+24] = h (8th parameter, on the stack)
;               [RBP+32] = i (9th parameter, on the stack)
;               [RBP+40] = j (10th parameter, on the stack)
; OUTPUT:       RAX = a + b + c + d + e + f + g + h + i + j
; CLOBBERED:    RAX, R10, R11
; NOTE:         The stack frame has no local variables. The caller pops the four stack
;               arguments after the call (add rsp, 32).
; =================================================================================================
global compute
compute:
    ; ---- prologue ----
    push rbp                 ; save the caller's base pointer
    mov rbp, rsp             ; set up this function's stack frame
    push rbx                 ; save the caller's RBX (callee-saved)
    push r12                 ; save the caller's R12 (callee-saved)
    push r13                 ; save the caller's R13 (callee-saved)

    ; ---- body ----
    mov rbx, rdi             ; RBX = a
    add rbx, rsi             ; add b
    add rbx, rdx             ; add c
    add rbx, rcx             ; add d
    add rbx, r8              ; add e
    add rbx, r9              ; add f (RBX = a + b + c + d + e + f)

    mov r12, [rbp+16]        ; R12 = g (7th parameter)
    add r12, [rbp+24]        ; add h (8th parameter)

    mov r13, [rbp+32]        ; R13 = i (9th parameter)
    add r13, [rbp+40]        ; add j (10th parameter)

    mov r10, r12             ; R10 = g + h (scratch: caller-saved, so it may be overwritten)
    add r10, r13             ; R10 = g + h + i + j

    mov r11, rbx             ; R11 = a + b + c + d + e + f (scratch: caller-saved)
    mov rax, r11             ; RAX = a + ... + f
    add rax, r10             ; RAX = a + ... + j

    ; ---- epilogue ----
    pop r13                  ; restore the caller's R13 (reverse order of the pushes)
    pop r12                  ; restore the caller's R12
    pop rbx                  ; restore the caller's RBX
    pop rbp                  ; restore the caller's base pointer
    ret                      ; return to the caller
