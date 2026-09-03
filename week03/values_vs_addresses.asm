;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; September 3, 2026
;
; Example to explain the different between the memory address to a value and the value itself
;
; assembler command:    yasm -felf64 -gdwarf2 values_vs_addresses.asm -l values_vs_addresses.lst
; linker command:       ld -g -o values_vs_addresses values_vs_addresses.o
; execute command:      ./values_vs_addresses
;--------------------------------------------------------------------------------------------------

SECTION .data ;------------------------------------------------------------------------------------

; System call information
SYS_WRITE       EQU     1   ; Call code for the system write system call (1 for SYS_write)
STDOUT          EQU     1   ; The standard output code (1 is for console output)

SYS_EXIT        EQU     60  ; Call code for system exit system call (60 for SYS_exit)
EXIT_SUCCESS    EQU     0   ; Successful program execution normally returns a 0

NULL            EQU     0
LF              EQU     10

; Define a string
strMsg      db      "ASSEMBLY", NULL
strMsgLen   EQU     $-strMsg

; Define a variable to be able to print the newLine character
strNewline  db      LF,LF

;--------------------------------------------------------------------------------------------------

SECTION .bss;--------------------------------------------------------------------------------------

strTemp     resb    1 ; Reserve a 1 byte buffer to store a character

;--------------------------------------------------------------------------------------------------


section .text
global _start

_start:

    ; strMsg is a label that represents the address where
    ; the string "Assembly" begins in memory.
    ; SYS_WRITE expects the ADDRESS of the data to print,
    ; so we can pass the address represented by strMsg.

    ; Print the whole string
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strMsg             ; RSI receives the ADDRESS of the string.
                                ; No characters are copied into RSI.  
    mov rdx, strMsgLen
    syscall

    ; print a new line
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strNewline
    mov rdx, 2
    syscall

    ; If we want only the first character of the string,
    ; we must DEREFERENCE the address represented by strMsg
    ; using [ ].
    ; We also need to specify the size of the data being read.
    ; This retrieves the value stored at that memory location.
    mov bl, byte [strMsg]  ; bl now contains 'A' (ASCII value 65)

    ; lets get the other characters, by using an OFFSET value, we can
    ; add 1 to the memory address to move one address through the string.
    ; Since characters are 1 byte in size we can increment the offset by one.
    mov cl,     byte [strMsg + 1]   ; cl now contains 'S' (ASCII value 83)
    mov r8b,    byte [strMsg + 2]  ; r8b now contains 'S' (ASCII value 83)
    mov r9b,    byte [strMsg + 3]  ; r9b now contains 'E' (ASCII value 69)
    mov r10b,   byte [strMsg + 4] ; r10b now contains 'M' (ASCII value 77)
    mov r11b,   byte [strMsg + 5] ; r11b now contains 'B' (ASCII value 66) 
    mov r12b,   byte [strMsg + 6] ; r12b now contains 'L' (ASCII value 76)
    mov r13b,   byte [strMsg + 7] ; r13b now contains 'Y' (ASCII value 89)

    ; What if I wanted to print the character 'A' stored in the BL register? 
    ; You can't print the character directly because the register contains
    ; the ASCII value (65) and the SYS_WRITE system call needs an ADDRESS
    ; to the piece of data. If you tried to print what was in register BL
    ; the SYS_WRITE call would interpret ASCII value 65 as ADDRESS 65.

    ; Store the value in the buffer we created previously
    ; strTemp is a label that represents the address of the reserved memory space
    ; We must dereference strTemp with [ ] because we want to
    ; store the value into the memory location represented by
    ; the label strTemp.
    mov byte [strTemp], bl

    ; Now we can print the letter A
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strTemp
    mov rdx, 1
    syscall

    ; print a new line
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, strNewline
    mov rdx, 2
    syscall

Exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall