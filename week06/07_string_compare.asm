;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 23, 2026
;
; Demonstrates how to print a string character by character. We do this by incrementing through
; each memory address of the string.
;
; assembler command:    yasm -felf64 -gdwarf2 07_string_compare.asm -l 07_string_compare.lst
; linker command:       ld -g -o 07_string_compare 07_string_compare.o
; execute command:      ./07_string_compare
;--------------------------------------------------------------------------------------------------

section .data ;------------------------------------------------------------------------------------
SYS_WRITE       equ     1   
STDOUT          equ     1   

SYS_READ        equ     0
STDIN           equ     0

SYS_EXIT        equ     60  
EXIT_SUCCESS    equ     0  

; Special Characters
LF              equ     10
NULL            equ     0
newLine         db      LF


prompt          db      "Enter a string: ", NULL
promptLen       equ     $ - prompt

difLength       db      "The strings are different lengths, they are not equal.", LF, NULL
difLengthSize   equ     $ - difLength

equalResult      db      "EQUAL", LF, NULL
equalResultLen   equ     $ - equalResult

notEqualResult      db      "NOT EQUAL", LF, NULL
notEqualResultLen   equ     $ - notEqualResult


BUFFER_SIZE     equ     50

;--------------------------------------------------------------------------------------------------

section .bss ;-------------------------------------------------------------------------------------

str1Buffer      resb    50  ; Reserve space for up to 50 characters
str2Buffer      resb    50  ; 

str1Len         resb    1
str2Len         resb    1

;--------------------------------------------------------------------------------------------------

section .text

global _start

_start:
 
readString1:    
    ; print the prompt to read the first string
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, prompt
    mov rdx, promptLen
    syscall

    ; read the first string
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, str1Buffer
    mov rdx, BUFFER_SIZE
    syscall

    ; Store the number of characters read
    ; RECALL: After using SYS_READ the RAX register will hold the number of characters entered
    ; including the enter key press.
    mov byte[str1Len], al

readString2:
    ; print the prompt to read the second string
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, prompt
    mov rdx, promptLen
    syscall

    ; read the first string
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, str2Buffer
    mov rdx, BUFFER_SIZE
    syscall

    ; Store the number of characters read
    mov byte[str2Len], al

checkLength:
    ; if the size of the two strings is not the same they can't be the same string
    ; Since both values we want to compare are in memory locations, we need to move at 
    ; least one of them to a register.
    mov r9b, byte[str1Len]
    cmp r9b, byte[str2Len]
    jne notSameLength

    ; Load the memory addresses of our strings into registers
    mov r8, str1Buffer
    mov r9, str2Buffer

    ; Use the RBX register for our string index (offset)
    mov rbx, 0

checkCharactersLoop:
    ; compare the next two characters
    ; we need to load ONE of the characters into a third register for the compare instruction
    mov r10b, byte[r8 + rbx]
    cmp r10b, byte[r9 + rbx]
    jne notEqual

    ; Increment the index (offset)
    inc rbx

    ; See if the offset value is equal to the length of the string, 
    ; if so, we reached the end of the string and the two strings are equal
    cmp bl, byte[str1Len]
    je equal

    ; Continue looping if necessary
    jmp checkCharactersLoop
    
equal:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, equalResult
    mov rdx, equalResultLen
    syscall

    jmp exit

notSameLength:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, difLength
    mov rdx, difLengthSize
    syscall

    jmp exit

notEqual:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, notEqualResult
    mov rdx, notEqualResultLen
    syscall

exit:
    mov rax, SYS_EXIT        
    mov rdi, EXIT_SUCCESS
    syscall