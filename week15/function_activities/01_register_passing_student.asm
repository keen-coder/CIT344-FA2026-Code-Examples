; CIT-344 Activity: Passing data in registers
;
;   yasm -f elf64 01_register_passing_student.asm -o 01_register_passing_student.o
;   ld 01_register_passing_student.o -o 01_register_passing_student
;   ./01_register_passing_student
;
; GOAL
;   Pass six characters to a function IN REGISTERS (no stack arguments).
;   The function prints them. When you run the finished program, it should print:
;       Hello!
;
; THE ARGUMENT REGISTERS
;   The first six integer arguments go in these registers, in this order:
;       1st  rdi   (byte part: dil)
;       2nd  rsi   (byte part: sil)
;       3rd  rdx   (byte part: dl)
;       4th  rcx   (byte part: cl)
;       5th  r8    (byte part: r8b)
;       6th  r9    (byte part: r9b)
;
;   The caller puts the arguments in these registers BEFORE the call.
;   The callee reads them right away.
;
; WHY THE FUNCTION COPIES THE CHARACTERS FIRST
;   The function cannot print straight from the argument registers, because
;   sys_write needs the ADDRESS of a block of memory, and the registers hold
;   characters, not addresses. So the function copies each character into the
;   buffer, then prints the buffer.
;
;   The copies MUST happen before the syscall. The syscall instruction
;   overwrites rax, rcx and r11, and it uses rdi, rsi and rdx for its own
;   arguments. If you make the syscall first, your argument values may be gone.
;
;   Copy only the BYTE part of each register (dil, sil, ...). A character is one
;   byte. If you copy the full 64-bit register, you write 8 bytes into the
;   buffer and overwrite the characters next to it.
;
; sys_write (system call 1) NEEDS THESE REGISTERS SET UP:
;   rax = SYS_WRITE   (the call number, 1)
;   rdi = STDOUT      (where to print: 1 = the screen)
;   rsi = address of the bytes to print (the buffer, not its contents)
;   rdx = number of bytes to print
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

NUM_CHARS       equ     6       ; number of characters passed in registers

section .bss ;==================================================================

; The buffer that printSix copies the characters into.
; Room for six characters plus one newline = 7 bytes.
buffer          resb    NUM_CHARS + 1

section .text ;=================================================================
global _start

; ----------------------------------------------------------------------------
; Main program
; ----------------------------------------------------------------------------
_start:
    ; TODO 1: Put the characters 'H', 'e', 'l', 'l', 'o', '!' into the six
    ;         argument registers, in this order:
    ;             rdi, rsi, rdx, rcx, r8, r9
    ;         Example: mov rdi, 'H'
    ;         Use full 64-bit registers here (mov rdi, 'H'), not the byte parts.

    ; TODO 2: Call printSix. The arguments are already in the registers,
    ;         so no push or pop is needed.

    ; After printSix returns, execution continues here and reaches the exit
    ; code below. Do NOT place any other code between the call and exit.

exit:
    ; Exit the program with sys_exit. This is already written for you.
    mov     rax, SYS_EXIT
    mov     rdi, EXIT_SUCCESS
    syscall

; ----------------------------------------------------------------------------
; printSix(char a1, char a2, char a3, char a4, char a5, char a6)
;   Arguments arrive in rdi, rsi, rdx, rcx, r8, r9 (in that order).
;   Copies the six characters into buffer, adds a newline, prints the buffer
;   with sys_write, and returns.
;   Do not use push or pop for the arguments. They are already in registers.
; ----------------------------------------------------------------------------
printSix:
    ; TODO 3: Copy each argument into the buffer. Do this BEFORE any syscall.
    ;         Use the byte part of each register:
    ;             a1 is in rdi  -> dil   and goes to [buffer]
    ;             a2 is in rsi  -> sil   and goes to [buffer + 1]
    ;             a3 is in rdx  -> dl    and goes to [buffer + 2]
    ;             a4 is in rcx  -> cl    and goes to [buffer + 3]
    ;             a5 is in r8   -> r8b   and goes to [buffer + 4]
    ;             a6 is in r9   -> r9b   and goes to [buffer + 5]
    ;         Example: mov [buffer], dil

    ; TODO 4: Put a newline in the seventh byte of the buffer, at buffer + 6.
    ;         Use NL. Example: mov byte [buffer + 6], NL

    ; TODO 5: Print the buffer with sys_write.
    ;         Set rax = SYS_WRITE, rdi = STDOUT, rsi = buffer (its ADDRESS),
    ;         rdx = NUM_CHARS + 1 (7 bytes: six characters plus the newline).
    ;         Then use the syscall instruction.
    ;         Note: mov rsi, buffer gives the address. mov rsi, [buffer] would
    ;         load the first bytes stored there, which is not what sys_write needs.

    ; TODO 6: Return to the caller with ret.
