; Keenan Knaur, CIT-344
; 
; Program to show a simple function to print strings and read data from the
; console. 
;
; This program does not use advanced features of functions such as:
; passing things on the stack, using local variables, having to deal with setting
; up and managing the stack frame, worrying about the rsp register, and using
; preserved registers.

section .data ;=================================================================

; Constants for sys_exit()
EXIT_SUCCESS    equ     0       ; successful program execution
SYS_EXIT        equ     60      ; call code for termination

; Constants for sys_write()
STDOUT          equ     1       ; The standard output code (1 is for the console)
SYS_WRITE       equ     1       ; Call code for the write system service

; Constants for sys_read()
STDIN           equ     0       ; The standard input code (0 is for the keyboard)
SYS_READ        equ     0       ; Call code for the read system service

; Constants for special characters
NL              equ     10      ; line feed (newline) character

; Strings do not end with a NULL byte. Their lengths are calculated with $-label,
; so only the actual text is printed.
str1            db      "I was wondering why the frisbee kept getting bigger and bigger, but then it hit me."
str1Len         dq      $-str1

strPrompt       db      "Enter a string: "
strPromptLen    dq      $-strPrompt

BUFFER_LEN      equ     100
charsRead       dq      0

newLine         db      NL

section .bss ;==================================================================

strBuffer       resb    BUFFER_LEN

section .text ;=================================================================

global _start
_start:

    ; printString(str1, str1Len)
    mov rsi, str1                   ; RSI = address of the string
    mov rdx, qword[str1Len]         ; RDX = length of the string
    call printString

    ; printNewLine()
    call printNewLine

    ; printString(strPrompt, strPromptLen)
    mov rsi, strPrompt
    mov rdx, qword[strPromptLen]
    call printString

    ; readInput(strBuffer, BUFFER_LEN)
    mov rsi, strBuffer              ; RSI = where to store the input
    mov rdx, BUFFER_LEN             ; RDX = maximum number of bytes to read
    call readInput                  ; RAX = number of bytes read

    ; Save the number of characters read so it survives the next calls
    mov qword[charsRead], rax

    ; printString(strBuffer, charsRead)
    mov rsi, strBuffer
    mov rdx, qword[charsRead]
    call printString

exit:
    ; sys_exit()
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

; =================================================================================================
; FUNCTION:     printString(char *str, long len)
; PURPOSE:      Prints len bytes of a string to the console.
; INPUT:        RSI = address of the string to print
;               RDX = number of bytes to print
; OUTPUT:       None
; CLOBBERED:    RAX, RCX, RDI, R11
; NOTE:         Does not add a line feed. Use printNewLine for that.
; =================================================================================================
global printString
printString:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    syscall

    ret

; =================================================================================================
; FUNCTION:     printNewLine(void)
; PURPOSE:      Prints a line feed, which moves the cursor to the next line.
; INPUT:        None
; OUTPUT:       None
; CLOBBERED:    RAX, RCX, RDI, RSI, RDX, R11
; NOTE:         Writes the NL character stored in newLine.
; =================================================================================================
global printNewLine
printNewLine:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newLine
    mov rdx, 1
    syscall

    ret

; =================================================================================================
; FUNCTION:     readInput(char *buf, long max)
; PURPOSE:      Reads one line of keyboard input into a buffer.
; INPUT:        RSI = address of the buffer to store the input
;               RDX = maximum number of bytes to read
; OUTPUT:       RAX = number of bytes read, including the line feed
; CLOBBERED:    RAX, RCX, RDI, R11
; NOTE:         Returns 0 at end of input. Input longer than max is cut off, and the
;               rest is read by the next call.
; =================================================================================================
global readInput
readInput:
    mov rax, SYS_READ
    mov rdi, STDIN
    syscall

    ret