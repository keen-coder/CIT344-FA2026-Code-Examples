; CIT-344 Activity: Local variables on the stack (STUDENT VERSION)
;
;   yasm -f elf64 04_local_variables_student.asm -o 04_local_variables_student.o
;   ld 04_local_variables_student.o -o 04_local_variables_student
;   ./04_local_variables_student
;
; GOAL
;   Give a function its own local variables on the stack, store values in them,
;   and read them back. When the program is finished, it should print:
;       iH
;
; WHAT A LOCAL VARIABLE IS
;   A local variable is memory that belongs to one function call. Local variables
;   live in the function's stack frame, BELOW rbp, at negative offsets:
;       [rbp-8]   first local
;       [rbp-16]  second local
;
;   Arguments are above rbp (positive offsets, as in the stack activity).
;   Locals are below rbp (negative offsets).
;
; MAKING ROOM FOR THE LOCALS
;   The function moves rsp down to reserve the space:
;       sub rsp, 16          ; reserve 16 bytes for two 8-byte locals
;   Do this BEFORE storing anything in the locals. Memory below rsp is not
;   reserved, so using it can be overwritten by later pushes or calls.
;
; LEAVING THE FUNCTION
;   Release the locals, then restore the caller's rbp:
;       add rsp, 16          ; release the 16 bytes of locals
;       pop rbp              ; restore the caller's rbp
;       ret
;   Use add rsp, N to release locals (this matches the course slides). It
;   works even when a function also pushes saved registers after setting up
;   the frame, where mov rsp, rbp would skip past those saved values.
;
; WHY BYTE-SIZED MOVES
;   Each local holds one character, so store the byte part of the register
;   (dil, sil) and read it back with a byte-sized register (al).
;   Memory can't be copied to memory in one instruction, so move through a
;   register: mov al, [rbp-16] then mov [buffer], al.
;
; sys_write NEEDS THESE REGISTERS SET UP:
;   rax = SYS_WRITE, rdi = STDOUT, rsi = address of the bytes, rdx = byte count
;
; HOW TO CHECK YOUR WORK
;   Correct program:                 prints iH
;   Locals copied in the wrong order: prints Hi
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

; Two characters plus one newline = 3 bytes.
buffer          resb    3

section .text ;=================================================================
global _start

; ----------------------------------------------------------------------------
; Main program
; ----------------------------------------------------------------------------
_start:
    ; TODO 1: Put 'H' in rdi and 'i' in rsi, then call printReversed.

exit:
    ; Exit the program with sys_exit. This is already written for you.
    mov     rax, SYS_EXIT
    mov     rdi, EXIT_SUCCESS
    syscall

; ----------------------------------------------------------------------------
; printReversed(char first, char second)
;   Arguments arrive in rdi and rsi.
;   Stores them in two local variables, then prints them in reverse order.
; ----------------------------------------------------------------------------
printReversed:
    ; TODO 2: Set up the stack frame (push rbp, then mov rbp, rsp).

    ; TODO 3: Reserve 16 bytes for the locals (sub rsp, 16).
    ;         Do this before you store anything in the locals.

    ; TODO 4: Store the arguments in the locals.
    ;         first  (dil) goes to [rbp - 8]
    ;         second (sil) goes to [rbp - 16]

    ; TODO 5: Copy the locals into buffer in REVERSE order, through al.
    ;         buffer[0] should get the second argument (from [rbp - 16]).
    ;         buffer[1] should get the first argument (from [rbp - 8]).
    ;         Example: mov al, [rbp - 16]  then  mov [buffer], al

    ; TODO 6: Put NL in buffer + 2.

    ; TODO 7: Print the buffer with sys_write.
    ;         rax = SYS_WRITE, rdi = STDOUT, rsi = buffer (the ADDRESS),
    ;         rdx = 3, then syscall.

    ; TODO 8: Release the locals and return.
    ;         add rsp, 16 (release the 16 bytes of locals), then pop rbp,
    ;         then ret.
