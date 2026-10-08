;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; October 7, 2026
;
; Demonstrates how to print a single digit (0-9).
;
; assembler command:    yasm -felf64 -gdwarf2 04_print_digit.asm -l 04_print_digit.lst
; linker command:       ld -g -o 04_print_digit 04_print_digit.o
; execute command:      ./04_print_digit
;--------------------------------------------------------------------------------------------------

section .data

    ; System Call Information
    SYS_WRITE      equ     1
    STDOUT         equ     1

    SYS_EXIT       equ     60
    EXIT_SUCCESS   equ     0

    ; Special Characters
    LF             equ     10

    ; Numeric value to print
    ; Notice that this is the NUMBER 5 and NOT the character '5'.
    digit          db      5

    ; Strings
    strTitle       db      "Printing a Single Digit", LF, LF
    titleLen       equ     $ - strTitle

    strLineFeed    db      LF
    lineFeedLen    equ     $ - strLineFeed

section .bss

    ; Temporary buffer used to store the printable character
    strTemp        resb    1

section .text
global _start

_start:

PrintTitle:

    ; Print the title

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strTitle
    mov rdx, titleLen
    syscall

LoadDigit:

    ; Load the number 5 into AL.
    ;
    ; AL now contains: This is the NUMERIC value 5 and not the character '5'.

    mov al, byte [digit]

ConvertToCharacter:

    ; SYS_WRITE prints characters, not numbers.
    ;
    ; ASCII / Unicode values:
    ;
    ; '0' = 48
    ; '1' = 49
    ; '2' = 50
    ; '3' = 51
    ; '4' = 52
    ; '5' = 53
    ; '6' = 54
    ; '7' = 55
    ; '8' = 56
    ; '9' = 57
    ;
    ; To convert a number between 0 and 9 into
    ; its printable character equivalent, add '0'.

    add al, '0'

    ; AL now contains the ASCII value for '5'.

StoreDigit:

    ; Store the printable character in a buffer.
    ;
    ; SYS_WRITE needs an ADDRESS to print from.

    mov byte [strTemp], al

PrintDigit:

    ; Print the digit

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strTemp
    mov rdx, 1
    syscall

    ; Print a line feed

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strLineFeed
    mov rdx, lineFeedLen
    syscall

Exit:

    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall