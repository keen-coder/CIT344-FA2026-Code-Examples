; Keenan Knaur, CIT-344
; Program to show a function that uses stack dynamic local variables and a loop, with no strings.
; highestScore receives 8 scores: 6 in registers and 2 on the stack.
; It copies the scores into a local array, keeps the highest score so far in a local integer,
; and uses a loop to check the rest of the array.
;
; Register arguments: scores 1 to 6 (RDI, RSI, RDX, RCX, R8, R9)
; Stack arguments:    score 7 at [RBP+16], score 8 at [RBP+24]
;
; Caller-saved registers: R10 and R11. highestScore may overwrite them, so the caller saves them first.
; Callee-saved registers: RBX and R12. RBX holds the score being checked, and R12 is the loop index.
; highestScore saves and restores both.
;
; The result is stored in highestResult so it can be checked in DDD.

section .data ;=================================================================

; Constants for sys_exit()
EXIT_SUCCESS    equ     0       ; successful program execution
SYS_EXIT        equ     60      ; call code for termination

section .bss ;==================================================================

highestResult   resq    1       ; holds the highest score returned by highestScore (should be 92)

section .text ;=================================================================

global _start
_start:

    ; Give the saved registers known values, so you can watch them in DDD before and after the call.
    mov rbx, 23              ; RBX = 23 (callee-saved: highestScore must restore it)
    mov r12, 42              ; R12 = 42 (callee-saved: highestScore must restore it)
    mov r10, 31              ; R10 = 31 (caller-saved: highestScore may change it)
    mov r11, 58              ; R11 = 58 (caller-saved: highestScore may change it)

    ; The caller saves its caller-saved registers before it sets up any arguments.
    push r10                 ; save R10
    push r11                 ; save R11

    ; The first six scores go in registers.
    mov rdi, 58              ; score 1 (a)
    mov rsi, 92              ; score 2 (b)
    mov rdx, 75              ; score 3 (c)
    mov rcx, 64              ; score 4 (d)
    mov r8, 81               ; score 5 (e)
    mov r9, 70               ; score 6 (f)

    ; Scores 7 and 8 go on the stack. Push score 8 first, so score 7 ends up at the lower address.
    push 67                  ; score 8 (h)
    push 85                  ; score 7 (g)

    call highestScore        ; RAX = highest of the eight scores

    ; The caller removes the two stack arguments it pushed (2 x 8 bytes).
    add rsp, 16

    ; The caller restores its saved registers, in reverse order of the pushes.
    pop r11
    pop r10

    mov qword[highestResult], rax   ; should be 92 (the highest of the eight scores)

exit:
    ; sys_exit()
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

; =================================================================================================
; FUNCTION:     long highestScore(long s1, long s2, long s3, long s4, long s5, long s6,
;                                 long s7, long s8)
; PURPOSE:      Returns the highest of eight scores. A loop checks each score, and the highest
;               so far is kept in a local integer.
; INPUT:        RDI = s1
;               RSI = s2
;               RDX = s3
;               RCX = s4
;               R8  = s5
;               R9  = s6
;               [RBP+16] = s7 (on the stack)
;               [RBP+24] = s8 (on the stack)
; OUTPUT:       RAX = the highest of the eight scores
; CLOBBERED:    RAX (the return value)
; LOCALS:       [RBP-88]              local integer: the highest score so far (8 bytes)
;               [RBP-80] to [RBP-17]  local array of 8 scores (8 bytes each)
;                                     array[0] at [RBP-80], array[7] at [RBP-24]
; NOTE:         The caller removes the two stack arguments after the call (add rsp, 16).
; =================================================================================================
global highestScore
highestScore:
    ; ---- prologue ----
    push rbp                 ; save the caller's base pointer
    mov rbp, rsp             ; set up this function's stack frame
    push rbx                 ; save the caller's RBX (callee-saved)
    push r12                 ; save the caller's R12 (callee-saved)
    sub rsp, 72              ; make room for the locals (highest 8 bytes, array 64 bytes)

    ; ---- copy the eight scores into the local array ----
    mov [rbp-80], rdi        ; array[0] = s1
    mov [rbp-72], rsi        ; array[1] = s2
    mov [rbp-64], rdx        ; array[2] = s3
    mov [rbp-56], rcx        ; array[3] = s4
    mov [rbp-48], r8         ; array[4] = s5
    mov [rbp-40], r9         ; array[5] = s6
    mov rax, [rbp+16]        ; read s7 from the stack
    mov [rbp-32], rax        ; array[6] = s7
    mov rax, [rbp+24]        ; read s8 from the stack
    mov [rbp-24], rax        ; array[7] = s8

    ; ---- start with the first score as the highest ----
    mov rax, [rbp-80]        ; RAX = array[0]
    mov [rbp-88], rax        ; highest = array[0]

    ; ---- loop over the other seven scores ----
    mov r12, 1               ; R12 = index, starts at 1 because array[0] is already the highest

.loop:
    mov rbx, [rbp-80+r12*8]  ; RBX = array[index]
    cmp rbx, [rbp-88]        ; is this score bigger than the highest so far?
    jle .next                ; no: skip the update
    mov [rbp-88], rbx        ; yes: this score is the new highest

.next:
    inc r12                  ; index = index + 1
    cmp r12, 8
    jl .loop                 ; repeat until index reaches 8

    mov rax, [rbp-88]        ; RAX = highest (return value)

    ; ---- epilogue ----
    add rsp, 72              ; remove the locals
    pop r12                  ; restore the caller's R12 (reverse order of the pushes)
    pop rbx                  ; restore the caller's RBX
    pop rbp                  ; restore the caller's base pointer
    ret                      ; return to the caller