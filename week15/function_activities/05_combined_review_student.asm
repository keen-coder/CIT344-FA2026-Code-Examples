; CIT-344 Activity: Combined review (STUDENT VERSION)
;
;   yasm -f elf64 05_combined_review_student.asm -o 05_combined_review_student.o
;   ld 05_combined_review_student.o -o 05_combined_review_student
;   ./05_combined_review_student
;
; GOAL
;   Use everything from the earlier activities in one program:
;     - arguments 1 to 6 in registers (rdi, rsi, rdx, rcx, r8, r9)
;     - arguments 7 and 8 on the stack
;     - local variables in the function's stack frame
;     - a callee-saved register (rbx) that must survive the call
;     - a caller-saved register (r10) that the caller must save and restore
;   When the program is finished, it should print (on one line):
;       Assembly!.
;
;   Fill in every TODO. The setup lines for r10 and rbx are already done for you.
;   Do not change the labels or the .data and .bss sections.
;
; HOW TO CHECK YOUR WORK
;   Correct program:                 Assembly!.
;   rbx not saved in printEight:     Assemblyy.
;   r10 not saved in main:           Assembly!l
;
; THE CALL, STEP BY STEP
;   1. Caller loads arguments 1 to 6 into rdi, rsi, rdx, rcx, r8, r9.
;      Registers are always used first.
;   2. Caller saves r10 (caller-saved), because the function may change it.
;   3. Caller pushes the 8th argument, then the 7th, so the 7th is at the lowest
;      address (right above the return address).
;   4. call pushes the return address.
;   5. Callee saves rbx (callee-saved), builds its frame, and uses locals.
;   6. Callee restores rbx, tears down the frame, and returns.
;   7. Caller removes the two stack arguments (add rsp, 16), then restores r10.

; WHAT THE FUNCTION SEES ON ENTRY
;   [rsp]      return address
;   [rsp+8]    7th argument  ('l')
;   [rsp+16]   8th argument  ('y')
;   [rsp+24]   the caller's saved r10
;   After push rbp and mov rbp, rsp, these become [rbp+16] and [rbp+24] for the
;   arguments, as in the stack activity.
;
; THE FRAME (after the callee's setup)
;   [rbp+24]   8th argument ('y')
;   [rbp+16]   7th argument ('l')
;   [rbp+8]    return address
;   [rbp]      caller's rbp
;   [rbp-8]    caller's rbx (saved by push rbx)
;   [rbp-16]   local1: copy of the 7th argument
;   [rbp-24]   local2: copy of the 8th argument
;
; sys_write NEEDS THESE REGISTERS SET UP:
;   rax = SYS_WRITE, rdi = STDOUT, rsi = address of the bytes, rdx = byte count

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

buffer          resb    8       ; the eight characters
tail            resb    3       ; the two marker characters plus the newline

section .text ;=================================================================
global _start

; ----------------------------------------------------------------------------
; Main program
; ----------------------------------------------------------------------------
_start:
    mov     r10, '.'            ; (done for you) r10 is caller-saved
    mov     rbx, '!'            ; (done for you) rbx is callee-saved

    ; TODO 1: Put arguments 1 to 6 in the registers FIRST:
    ;         rdi = 'A', rsi = 's', rdx = 's', rcx = 'e', r8 = 'm', r9 = 'b'.
    ;         Registers are always used first. Only then do we push.

    ; TODO 2: r10 is caller-saved, and printEight may change it.
    ;         Save r10 on the stack (push r10) BEFORE the call.

    ; TODO 3: Push the 8th argument, 'y', then the 7th argument, 'l'.
    ;         Push the 8th first, so the 7th ends up at the lowest address.

    ; TODO 4: Call printEight.

    ; TODO 5: The caller removes the two stack arguments (2 x 8 bytes).
    ;         Use add rsp, 16.

    ; TODO 6: Restore r10 from the stack with pop.

    ; Copy the two marker characters into tail, then print them.
    ; (Done for you. rbx holds '!' and r10 should hold '.'.)
    mov     [tail], bl
    mov     [tail + 1], r10b
    mov     byte [tail + 2], NL

    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, tail
    mov     rdx, 3
    syscall

exit:
    ; Exit the program with sys_exit. This is already written for you.
    mov     rax, SYS_EXIT
    mov     rdi, EXIT_SUCCESS
    syscall

; ----------------------------------------------------------------------------
; printEight(char a1, ..., char a6, char a7, char a8)
;   Arguments 1-6 arrive in rdi, rsi, rdx, rcx, r8, r9.
;   Arguments 7 and 8 are on the stack at [rbp+16] and [rbp+24].
;   Copies all eight characters into buffer, prints them, and returns.
;   rbx must be preserved (callee-saved). r10 may be changed (caller-saved).
; ----------------------------------------------------------------------------
printEight:
    ; TODO 7: Set up the stack frame (push rbp, mov rbp, rsp).

    ; TODO 8: Save rbx, because this function uses it below (push rbx).

    ; TODO 9: Reserve 16 bytes for the two locals (sub rsp, 16).
    ;         Do this before storing anything in the locals.

    ; TODO 10: Copy arguments 1-6 from the registers into buffer[0] to buffer[5].
    ;          Use the byte part of each register:
    ;          dil, sil, dl, cl, r8b, r9b.
    ;          Example: mov [buffer], dil

    ; TODO 11: Copy the 7th argument from [rbp + 16] into local1 at [rbp - 16].
    ;          Go through r10b, as shown: mov r10b, [rbp + 16]  then  mov [rbp - 16], r10b
    ;          Copy the 8th argument from [rbp + 24] into local2 at [rbp - 24].
    ;          Go through al.

    ; TODO 12: Copy local1 into buffer[6] and local2 into buffer[7].
    ;          Go through bl, because memory cannot be copied directly to memory.

    ; TODO 13: Print the eight characters with sys_write.
    ;          rax = SYS_WRITE, rdi = STDOUT, rsi = buffer (the ADDRESS),
    ;          rdx = 8, then syscall.
    ;          Do not add a newline here. main prints the newline.

    ; TODO 14: Release the locals (add rsp, 16), restore rbx (pop rbx),
    ;          restore the caller's rbp (pop rbp), and return (ret).
