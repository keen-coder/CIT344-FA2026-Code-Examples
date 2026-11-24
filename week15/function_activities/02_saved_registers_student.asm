; CIT-344 Activity: Caller-saved and callee-saved registers
;
;   yasm -f elf64 02_saved_registers_student.asm -o 02_saved_registers_student.o
;   ld 02_saved_registers_student.o -o 02_saved_registers_student
;   ./02_saved_registers_student
;
; GOAL
;   Learn which registers a function must preserve and which it may change.
;   When the program is finished, it should print:
;       BCK
;
; THE TWO KINDS OF REGISTERS
;   Callee-saved registers: rbx, rbp, r12, r13, r14, r15
;       A function that uses one of these MUST put the original value back
;       before it returns, so the caller can count on it keeping its value.
;       The usual way: push the register at the start of the function, and pop
;       it right before ret.
;
;   Caller-saved registers: rax, rcx, rdx, rsi, rdi, r8, r9, r10, r11
;       A function may change these freely. If the CALLER needs one of them
;       after the call, the caller must save it before the call (push) and
;       restore it after the call (pop).
;
; WHY POP ORDER MATTERS
;   push saves registers in one order, so pop must restore them in the REVERSE
;   order. Example: push rbx, then push r12. Later: pop r12, then pop rbx.
;
; WHY THE BUFFER AND THE syscall
;   The syscall overwrites rcx (and other registers), so copy the three values
;   into the buffer BEFORE the syscall, as you did in the register-passing activity.
;   sys_write needs:
;       rax = SYS_WRITE, rdi = STDOUT, rsi = address of the bytes, rdx = byte count
;
; HOW TO CHECK YOUR WORK
;   Correct program:          prints BCK
;   Missing callee save:      prints XYK   (rbx and r12 were changed by scratchWork)
;   Missing caller save:      prints BCZ   (rcx was changed by scratchWork)
;
; Fill in every TODO. Do not change the labels or the .data and .bss sections.

section .data ;=================================================================

; Constants for sys_exit()
EXIT_SUCCESS    equ     0       ; successful program execution
SYS_EXIT        equ     60      ; call code for termination

; Constants for sys_write()
STDOUT          equ     1       ; the standard output code
SYS_WRITE       equ     1       ; call code for the write system service

; New line character
NL              equ     10      ; line feed (newline) character

section .bss ;==================================================================

; Three characters plus one newline = 4 bytes.
buffer          resb    4

section .text ;=================================================================
global _start

; ----------------------------------------------------------------------------
; Main program
; ----------------------------------------------------------------------------
_start:
    ; These three values are already set up for you.
    mov     rbx, 'B'            ; callee-saved: scratchWork must preserve it
    mov     r12, 'C'            ; callee-saved: scratchWork must preserve it
    mov     rcx, 'K'            ; caller-saved: scratchWork may change it

    ; TODO 1: rcx is caller-saved, so the CALLER must save it before the call.
    ;         Push rcx onto the stack.

    ; TODO 2: Call scratchWork.

    ; TODO 3: Restore rcx. Pop it from the stack.

    ; TODO 4: Copy rbx, r12 and rcx into the buffer, in that order,
    ;         BEFORE the syscall. Use the byte part of each register:
    ;             rbx -> bl    goes to [buffer]
    ;             r12 -> r12b  goes to [buffer + 1]
    ;             rcx -> cl    goes to [buffer + 2]
    ;         Then put NL in buffer + 3 (mov byte [buffer + 3], NL).

    ; TODO 5: Print the buffer with sys_write.
    ;         Set rax = SYS_WRITE, rdi = STDOUT, rsi = buffer (the ADDRESS),
    ;         rdx = 4 (three characters plus the newline). Then use syscall.

exit:
    ; Exit the program with sys_exit. This is already written for you.
    mov     rax, SYS_EXIT
    mov     rdi, EXIT_SUCCESS
    syscall

; ----------------------------------------------------------------------------
; scratchWork
;   Uses rbx, r12 and rcx as scratch space, then returns.
;   rbx and r12 are callee-saved, so this function must save them at the start
;   and restore them before it returns.
;   rcx is caller-saved, so this function may change it without restoring it.
; ----------------------------------------------------------------------------
scratchWork:
    ; TODO 6: Save the callee-saved registers this function uses (rbx and r12).
    ;         Push them at the start of the function.

    ; Scratch work. These instructions change the registers. Leave them as is.
    mov     rbx, 'X'
    mov     r12, 'Y'
    mov     rcx, 'Z'

    ; TODO 7: Restore rbx and r12 before returning. Pop them in REVERSE order
    ;         from the order you pushed them, then return with ret.
