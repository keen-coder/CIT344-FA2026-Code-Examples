;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; November 2, 2026
;
; Example 3:
; Demonstrates several ways to use the MUL instruction.
;
; One operand must be stored in the A register:
;
;     AL   -> 8-bit multiplication
;     AX   -> 16-bit multiplication
;     EAX  -> 32-bit multiplication
;     RAX  -> 64-bit multiplication
;
; The result may be larger than the operands being multiplied.
;
;--------------------------------------------------------------------------------------------------

section .data

    ;----------------------------------------------------------------------------
    ; 8-Bit Example
    ;----------------------------------------------------------------------------

    bNum1      db      5
    bNum2      db      4

    ; 8-bit x 8-bit can produce a 16-bit result
    wResult1   dw      0

    ;----------------------------------------------------------------------------
    ; 16-Bit Example
    ;----------------------------------------------------------------------------

    wNum1      dw      4321
    wNum2      dw      1234

    ; 16-bit x 16-bit can produce a 32-bit result
    dResult2   dd      0

    ;----------------------------------------------------------------------------
    ; 32-Bit Example
    ;----------------------------------------------------------------------------

    dNum1      dd      42000
    dNum2      dd      73000

    ; 32-bit x 32-bit can produce a 64-bit result
    qResult3   dq      0

    ;----------------------------------------------------------------------------
    ; 64-Bit Example
    ;----------------------------------------------------------------------------

    qNum1      dq      420000
    qNum2      dq      730000

section .bss

    ; 64-bit x 64-bit can produce a 128-bit result.
    ; Reserve two quadwords (16 bytes total).
    ;
    ; dqResult4
    ; ├── Lower 64 bits
    ; └── Upper 64 bits

    dqResult4  resq    2

section .text
global _start

_start:

;--------------------------------------------------------------------------------------------------
; Example 1: 8-Bit Multiplication
;
; AL * operand
;
; Result stored in AX
;--------------------------------------------------------------------------------------------------

ByteMultiplicationExample:

    ; 5 * 4 = 20
    mov al, byte [bNum1]
    mul byte [bNum2]

    ; Result stored in AX
    ; Save the contents of ax into a 16-bit memory location
    mov word [wResult1], ax

;--------------------------------------------------------------------------------------------------
; Example 2: 16-Bit Multiplication
;
; AX * operand
;
; Result stored in DX:AX
;--------------------------------------------------------------------------------------------------

WordMultiplicationExample:
    
    ; 4,321 x 1,234 =  5,332,114
    mov ax, word [wNum1]
    mul word [wNum2]

    ; Result stored in DX:AX
    ; DX contains the upper 16 bits
    ; AX contains the lower 16 bits
    mov word [dResult2], ax
    mov word [dResult2 + 2], dx

;--------------------------------------------------------------------------------------------------
; Example 3: 32-Bit Multiplication
;
; EAX * operand
;
; Result stored in EDX:EAX
;--------------------------------------------------------------------------------------------------

DoubleWordMultiplicationExample:

    ; 42,000 x 73,000 = 3,066,000,000
    mov eax, dword [dNum1]
    mul dword [dNum2]

    ; Result stored in EDX:EAX
    ;
    ; EDX contains the upper 32 bits
    ; EAX contains the lower 32 bits
    mov dword [qResult3], eax
    mov dword [qResult3 + 4], edx

;--------------------------------------------------------------------------------------------------
; Example 4: 64-Bit Multiplication
;
; RAX * operand
;
; Result stored in RDX:RAX
;--------------------------------------------------------------------------------------------------

QuadWordMultiplicationExample:

    ; 420,000 x 730,000 = 306,600,000,000
    mov rax, qword [qNum1]
    mul qword [qNum2]

    ; Result stored in RDX:RAX
    ;
    ; RDX contains the upper 64 bits
    ; RAX contains the lower 64 bits
    mov qword [dqResult4], rax
    mov qword [dqResult4 + 8], rdx

Exit:

    mov rax, 60
    mov rdi, 0
    syscall