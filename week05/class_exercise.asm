;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 15, 2026
;
; assembler command:    yasm -felf64 -gdwarf2 class_exercise.asm -l class_exercise.lst
; linker command:       ld -g -o class_exercise class_exercise.o
; execute command:      ./class_exercise
;--------------------------------------------------------------------------------------------------

SECTION .data ;--------------------------------------------------------------------------------

LF				EQU		10
NULL			EQU		0

SYS_WRITE 		EQU 	1
STDOUT			EQU		1

SYS_READ		EQU		0
STDIN			EQU		0

SYS_EXIT		EQU		60
EXIT_SUCCESS	EQU		0

strHello		db		"hello, world", LF, NULL
bHelloLen		EQU		$-strHello

strPrompt1		db		"Enter your name: ", NULL
prompt1Len		EQU		$-strPrompt1

; strUserIn		db		"                                                  ", NULL
; userInLen		EQU		$-strUserIn

; userInSize		dw		0

BUFFER_SIZE		EQU 	50
;-------------------------------------------------------------------------------------

SECTION .bss
strUserIn		resb  BUFFER_SIZE
userInSize		resb  1

SECTION .text

global _start

_start:
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strHello
;	mov dl, byte [bHelloLen]
	mov rdx, bHelloLen
	syscall

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strPrompt1
	mov rdx, prompt1Len
	syscall

	mov rax, SYS_READ
	mov rdi, STDIN
	mov rsi, strUserIn
	mov rdx, BUFFER_SIZE
	syscall

	mov byte [userInSize], al

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strUserIn
	mov dl, byte [userInSize]
	syscall

	
exit:
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall

