;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; August 20, 2026
;
; Simple assembly program to print "hello, world" to the console

; assembler command:    yasm -felf64 -gdwarf2 hello_world.asm -l hello_world.lst
; linker command:       ld -g -o hello_world hello_world.o
; execute command:      ./hello_world
;--------------------------------------------------------------------------------------------------

section .data ;------------------------------------------------------------------------------------

; The .data section is where initialized data goes. Constants and known pieces of data are defined 

; System Call Codes
; These are the standard codes for the operating system calls. System calls are special mechanisms
; that programs use to ask the operating system kernal to do something on its behalf. Such as
; terminating the program or writing data to the standard output (console)

SYS_write		EQU	1	; Call code for the system write system call (1 for SYS_write)
STDOUT			EQU	1	; The standard output code (1 is for console output)

SYS_exit       	EQU 60  ; Call code for system exit system call (60 for SYS_exit)
EXIT_SUCCESS   	EQU 0   ; Successful program execution normally returns a 0

; The following are constant values for the LF (LineFeed / Newline character) and the Null (string
; termination character)
; If you don't remember where these come from, take a look at an ASCII or Unicode Table online
LF		EQU	10
NULL	EQU	0

; String and string length definitions.
hello         db    "hello, world", LF, NULL
helloLen      EQU   $-hello

;--------------------------------------------------------------------------------------------------
section .bss
; This section contains uninitialized data. Things defined in this section only reserve space
; for future data.
; Right now this section is empty
;--------------------------------------------------------------------------------------------------

section .text ;------------------------------------------------------------------------------------
; The .text section is where all of the rest of the code goes.

global _start

_start:

print:
	mov  rax, SYS_write
	mov  rdi, STDOUT
	mov  rsi, hello
	mov  rdx, helloLen
	syscall

exit:
	mov  rax, SYS_exit
	mov  rdi, EXIT_SUCCESS
	syscall
;--------------------------------------------------------------------------------------------------