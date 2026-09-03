;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 1, 2026
;
; Demonstrates how to read data from the console using the SYS_READ system call. The buffer
; to store the input string is defined in the .data section. Keep in mind that this will
; increase the size of your executable file once the program is full assembled and linked.
;
; assembler command:    yasm -felf64 -gdwarf2 read_data_buffer_in_bss_section.asm -l read_data_buffer_in_bss_section.lst
; linker command:       ld -g -o read_data_buffer_in_bss_section read_data_buffer_in_bss_section.o
; execute command:      ./read_data_buffer_in_data_section
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

; Buffer to store a future string with console input. You must create the space for
; the characters ahead of time. Here we just use spaces to fill out the buffer.
; NOTE: Creating a buffer in the .data section will increase the size of your
; assembled executable file.

; Create a 50 character buffer
BUFFER_SIZE		EQU		50						; Define the size of the entire buffer
bBufferLen		db		0						; Create a variable to hold the length of the string 
                                                ; (how many characters were actually entered)
;--------------------------------------------------------------------------------------------------

SECTION .bss ;-------------------------------------------------------------------------------------

; Buffer to store a future string with console input.
; NOTE: Creating a buffer in the .bss section will not increase the size of your
; assembled executable file.
strBuffer		resb	BUFFER_SIZE
;--------------------------------------------------------------------------------------------------

SECTION .text ;------------------------------------------------------------------------------------

global _start

_start:

readString:
	mov rax, SYS_READ
	mov rdi, STDIN
	mov rsi, strBuffer
	mov rdx, BUFFER_SIZE
	syscall

	; After executing the SYS_READ system call, RAX will hold the number of characters that were
	; entered. We normally want to save this in a variable for later use.
	mov byte[bBufferLen], al

printOutput:
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, strBuffer
	mov dl, byte [bBufferLen]	; bBufferLen is a byte-sized variable, so we must use the byte-sized
	syscall						; register name (DL). RDX must contain the actual character count,
								; so we load the value stored in bBufferLen rather than its address.

exit:
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall