;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 2, 2026
;
; Shows how the register names can provide a different view of the same register.
;
; assembler command:    yasm -felf64 -gdwarf2 register_names.asm -l register_names.lst
; linker command:       ld -g -o register_names register_names.o
; execute command:      ./register_names
;--------------------------------------------------------------------------------------------------

SECTION .data ;------------------------------------------------------------------------------------

; System call information
SYS_WRITE		EQU		1	; Call code for the system write system call (1 for SYS_write)
STDOUT			EQU		1	; The standard output code (1 is for console output)

SYS_READ		equ		0	; Call code for the read system service
STDIN			equ 	0	; The standard input code (0 is for the keyboard)

SYS_EXIT       	EQU 	60  ; Call code for system exit system call (60 for SYS_exit)
EXIT_SUCCESS   	EQU 	0   ; Successful program execution normally returns a 0

; Special Characters
LF		EQU		10
NULL	EQU		0

strAlpha		db	"ABCDEFGH"
bAlphaLen		EQU	$-strAlpha

strLinefeed		db	LF,LF

strLabel1		db	'RBX = '
bLabel1Len		EQU	$-strLabel1

bTempLen		EQU	8
;--------------------------------------------------------------------------------------------------

SECTION .bss ;-------------------------------------------------------------------------------------

; TEMP buffer for printing
strTemp		resb	8
;--------------------------------------------------------------------------------------------------

SECTION .text ;------------------------------------------------------------------------------------

global _start

_start:

	; --------------------------------------------------
    ; AL (8 bits / 1 byte)
    ; --------------------------------------------------

    mov bl, byte [strAlpha] 		; BL contains: 'A'

    ; --------------------------------------------------
    ; AX (16 bits / 2 bytes)
    ; --------------------------------------------------

    mov bx, word [strAlpha] 		; BX contains: 'AB'
    						   		; BL still contains: 'A'

    ; --------------------------------------------------
    ; EAX (32 bits / 4 bytes)
    ; --------------------------------------------------

    mov ebx, dword [strAlpha]		; EBX contains: 'ABCD'
									; BX still contains: 'AB'
    								; BL still contains: 'A'

    ; --------------------------------------------------
    ; RAX (64 bits / 8 bytes)
    ; --------------------------------------------------

    mov rbx, qword [strAlpha]		; RBX contains: "ABCDEFGH"
    								; EBX still contains: 'ABCD'
									; BX still contains: 'AB'
    								; BL still contains: 'A'
PrintRBX1:
	; Print out RAX by copying its contents to the buffer
   	mov qword [strTemp], rbx

   	; Print the contents of RBX that were copied to the buffer.
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strLabel1
	mov rdx, bLabel1Len
	syscall

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strTemp
	mov rdx, 8
	syscall

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strLinefeed
	mov rdx, 2
	syscall

	

PrintRBX2:
	; Change the lower byte of the RBX register using BL
	mov bl, 'Z'

	; copy the contents of RBX into the buffer to print
	mov qword [strTemp], rbx

	; Print the copied values from RBX
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strLabel1
	mov rdx, bLabel1Len
	syscall

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strTemp
	mov rdx, 8
	syscall

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strLinefeed
	mov rdx, 2
	syscall

PrintRBX3:
	; Change the lower 2 bytes of the RBX register using BX
	mov bx, 'ZY'

	; copy the contents of RBX into the buffer to print
	mov qword [strTemp], rbx

	; Print the copied values from RBX
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strLabel1
	mov rdx, bLabel1Len
	syscall

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strTemp
	mov rdx, 8
	syscall

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strLinefeed
	mov rdx, 2
	syscall

PrintRBX4:
	; Change the lower 4 bytes of the RBX register using BX
	; REMEMBER: When you use the 32-bit register names, the upper 4 bytes
	; (32-bits) are zeroed out.
	mov ebx, 'ZYXW'

	; copy the contents of RBX into the buffer to print
	mov qword [strTemp], rbx

	; Print the copied values from RBX
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strLabel1
	mov rdx, bLabel1Len
	syscall

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strTemp
	mov rdx, 8
	syscall

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strLinefeed
	mov rdx, 2
	syscall

exit:
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall