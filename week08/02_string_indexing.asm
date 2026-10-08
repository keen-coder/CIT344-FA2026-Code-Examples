;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; October 7, 2026
;
; Demonstrates how to iterate through a string using string indexing.
;
; assembler command:    yasm -felf64 -gdwarf2 02_string_indexing.asm -l 02_string_indexing.lst
; linker command:       ld -g -o 02_string_indexing 02_string_indexing.o
; execute command:      ./02_string_indexing
;--------------------------------------------------------------------------------------------------

section .data

    SYS_WRITE      equ     1
    STDOUT         equ     1

    SYS_EXIT       equ     60
    EXIT_SUCCESS   equ     0

    LF             equ     10

    ; Example string
    strMsg         db      "HELLO WORLD FROM ASSEMBLY"
    strMsgLen      equ     $ - strMsg

    strTitle       db      "String Indexing Example", LF, LF
    titleLen       equ     $ - strTitle

    strLineFeed    db      LF
    lineFeedLen    equ     $ - strLineFeed

section .bss

    ; Temporary buffer used to print one character
    strTemp        resb    1

section .text
global _start

_start:

PrintTitle:

    ; Print a title for the example

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strTitle
    mov rdx, titleLen
    syscall

InitializeLoop:

    ; RBX will be used as the STRING INDEX
    ;
    ; (_ represents a space)
    ;
    ; String:   H E L L O _ W O R L D  _  F  R  O  M  _  A  S  S  E  M  B  L  Y
    ; Index:    0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24

    mov rbx, 0

NextCharacter:

    ; Have we reached the end of the string?
    ; You can add the null character to the end and check for that OR
    ; See if rbx == length of the string

    cmp rbx, strMsgLen
    jge Exit

    ; Use the current value in RBX as an index.
    ;
    ; First Iteration:
    ; [strMsg + 0] = H
    ;
    ; Second Iteration:
    ; [strMsg + 1] = E
    ;
    ; Third Iteration:
    ; [strMsg + 2] = L

    mov al, byte [strMsg + rbx]

    ; Store the character into a temporary
    ; buffer so SYS_WRITE can print it.

    mov byte [strTemp], al

PrintCharacter:

    ; Print the current character

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strTemp
    mov rdx, 1
    syscall

    ; Print a line feed so that each
    ; character appears on a separate line

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strLineFeed
    mov rdx, lineFeedLen
    syscall

NextIndex:

    ; Move to the next character
    inc rbx

    ; Repeat the loop
    jmp NextCharacter

Exit:

    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall