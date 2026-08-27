;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; August 24, 2026
;
; This example shows how to declare variables and contants in the .data section of an assembly
; program. Also how to reserve bytes of memory for future use in the .bss section.
; 
; Example Reference: Jorgensen, Ed; x86-64 Assembly Language Programming with Ubuntu; September 2024

; assembler command:    yasm -felf64 -gdwarf2 data_declarations.asm -l data_declarations.lst
; linker command:       ld -g -o data_declarations data_declarations.o
; execute command:      ./data_declarations
;--------------------------------------------------------------------------------------------------

SECTION .data ;------------------------------------------------------------------------------------

; 
SYS_EXIT      	equ 60
EXIT_SUCCESS   	equ 0

bVar  	db 	10              ; byte variable
cVar  	db 	"H"             ; single character
strng 	db 	"Hello World"   ; string
wVar  	dw 	5000            ; 16-bit variable
dVar  	dd 	50000           ; 32-bit variable
arr   	dd 	100, 200, 300   ; 3 element array
flt1  	dd 	3.14159         ; 32-bit float
qVar  	dq 	1000000000      ; 64-bit variable

;--------------------------------------------------------------------------------------------------

SECTION .bss ;-------------------------------------------------------------------------------------

x       resb	1       ; a 1 byte value
bArr 	resb 	10  	; 10 element byte array
wArr 	resw 	50  	; 50 element word array
dArr 	resd 	100 	; 100 element double array
qArr 	resq 	200 	; 200 element quad array

SECTION .text ;------------------------------------------------------------------------------------ 

global _start
_start:

exit:
	mov  rax, SYS_EXIT
	mov  rdi, EXIT_SUCCESS
	syscall