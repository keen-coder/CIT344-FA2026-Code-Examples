; CIT-344 Activity: Passing arguments on the stack (STUDENT VERSION)
;
;   yasm -f elf64 03_stack_passing_student.asm -o 03_stack_passing_student.o
;   ld 03_stack_passing_student.o -o 03_stack_passing_student
;   ./03_stack_passing_student
;
; GOAL
;   Pass two characters to a function ON THE STACK, then read them from the stack
;   and print them. When the program is finished, it should print:
;       Hi
;
;   Fill in every TODO. Do not change the labels or the .data section.
;
; WHY PUT ARGUMENTS ON THE STACK
;   Registers hold only a few values, so larger or extra arguments go on the stack.
;   This activity passes ALL the arguments on the stack, so you can focus on how
;   they are placed there and how the function reads them.
;
; THE STACK GROWS DOWN
;   push subtracts 8 from rsp, then writes the value at the new top of the stack.
;   pop reads the value at the top, then adds 8 to rsp.
;   Addresses get SMALLER as the stack grows.
;
; THE CALLER PUSHES THE ARGUMENTS IN REVERSE ORDER
;   Push the SECOND argument first, then the FIRST. That way the first argument
;   ends up at the lowest address, right above the return address.
;
; WHAT THE FUNCTION SEES (after push rbp and mov rbp, rsp)
;       address       contents
;       [rbp+24]      second argument ('i')
;       [rbp+16]      first argument  ('H')
;       [rbp+8]       return address (pushed by call)
;       [rbp]         the caller's saved rbp (pushed by push rbp)
;   Arguments are ABOVE rbp, so they have positive offsets.
;
; EACH ARGUMENT IS 8 BYTES, BUT A CHARACTER IS 1 BYTE
;   Each push puts 8 bytes on the stack. The character is in the LOWEST byte of
;   the slot, which is the byte at the slot's address. So lea rsi, [rbp+16] gives
;   the address of the first character, and sys_write prints 1 byte from there.
;
; THE CALLER CLEANS UP
;   After the call, the caller removes its two arguments:
;       add rsp, 16          ; 2 arguments x 8 bytes
;   This program prints the same output with or without that line, but the
;   stack would keep growing if the caller skipped it. Programs that call a
;   function many times must clean up each time.
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
newLine         db      NL

section .text ;=================================================================
global _start

; ----------------------------------------------------------------------------
; Main program
; ----------------------------------------------------------------------------
_start:
    ; TODO 1: Push the characters onto the stack in REVERSE order.
    ;         First push 'i' (the second argument), then push 'H' (the first).
    ;         Use push, one value at a time.

    ; TODO 2: Call printTwoChars.
    ;         The call instruction pushes the return address for you.

    ; TODO 3: Remove the two arguments from the stack in the caller.
    ;         They take 2 x 8 = 16 bytes, so use add rsp, 16.

exit:
    ; Exit the program with sys_exit. This is already written for you.
    mov     rax, SYS_EXIT
    mov     rdi, EXIT_SUCCESS
    syscall

; ----------------------------------------------------------------------------
; printTwoChars(char first, char second)
;   Arguments are on the stack: [rbp+16] = first, [rbp+24] = second.
;   Prints first, then second, then a newline.
;   The stack frame setup and teardown are the same ones you learned earlier.
; ----------------------------------------------------------------------------
printTwoChars:
    ; TODO 4: Set up the stack frame.
    ;         a) push rbp      (save the caller's rbp)
    ;         b) mov rbp, rsp  (rbp now marks this function's frame)

    ; TODO 5: Print the first character.
    ;         rax = SYS_WRITE, rdi = STDOUT, rdx = 1.
    ;         rsi must be the ADDRESS of the first argument, which is [rbp+16].
    ;         Use lea rsi, [rbp+16]. Do NOT use mov rsi, [rbp+16].
    ;         Then use syscall.

    ; TODO 6: Print the second character the same way.
    ;         Its address is [rbp+24].

    ; TODO 7: Print a newline. Use the newLine label.
    ;         rax = SYS_WRITE, rdi = STDOUT, rsi = newLine, rdx = 1, then syscall.

    ; TODO 8: Tear down the stack frame and return.
    ;         a) pop rbp   (restore the caller's rbp)
    ;         b) ret       (pop the return address and jump back)
