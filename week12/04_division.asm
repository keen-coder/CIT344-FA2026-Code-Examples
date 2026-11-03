;--------------------------------------------------------------------------------------------------
; Keenan Knaur, CIT-344
; November 2, 2026
;
; Example 4:
; Demonstrates several ways to use the DIV instruction.
;
; Division returns two values:
;
;     Quotient
;     Remainder
;
; Division uses:
;     AX       -> 8-bit dividend
;     DX:AX    -> 16-bit dividend
;     EDX:EAX  -> 32-bit dividend
;     RDX:RAX  -> 64-bit dividend
;
; The size of the divisor determines the type of division performed.
;   8-bit divisor  -> AX ÷ byte
;   16-bit divisor -> DX:AX ÷ word
;   32-bit divisor -> EDX:EAX ÷ dword
;   64-bit divisor -> RDX:RAX ÷ qword
;
; If the dividend fits entirely within the A register,
; clear the D register before division.
;
; If the dividend does not fit entirely within the A register,
; split the dividend across the D:A register pair and do NOT clear the D register.
;--------------------------------------------------------------------------------------------------

section .data

    ;----------------------------------------------------------------------------
    ; 8-Bit Example
    ;----------------------------------------------------------------------------

    bDividend1      db      17
    bDivisor1       db      10

    bQuotient1      db      0
    bRemainder1     db      0

    ;----------------------------------------------------------------------------
    ; 16-Bit Example (Dividend Fits Entirely in A Register)
    ;----------------------------------------------------------------------------

    wDividend2      dw      17
    wDivisor2       dw      10

    wQuotient2      dw      0
    wRemainder2     dw      0

    ;----------------------------------------------------------------------------
    ; 16-Bit Example (Dividend DOES NOT Fit Entirely in A Register)
    ;----------------------------------------------------------------------------

    dDividend3      dd      100005
    wDivisor3       dw      1000

    wQuotient3      dw      0
    wRemainder3     dw      0

    ;----------------------------------------------------------------------------
    ; 32-Bit Example (Dividend Fits Entirely in A Register)
    ;----------------------------------------------------------------------------

    dDividend4      dd      100005
    dDivisor4       dd      1000

    dQuotient4      dd      0
    dRemainder4     dd      0

    ;----------------------------------------------------------------------------
    ; 32-Bit Example (Dividend DOES NOT Fit Entirely in A Register)
    ;----------------------------------------------------------------------------

    qDividend5      dq      5000000000
    dDivisor5       dd      100000

    dQuotient5      dd      0
    dRemainder5     dd      0

    ;----------------------------------------------------------------------------
    ; 64-Bit Example (Dividend Fits Entirely in A Register)
    ;----------------------------------------------------------------------------

    qDividend6      dq      306600000000
    qDivisor6       dq      1000000

    qQuotient6      dq      0
    qRemainder6     dq      0

    ;----------------------------------------------------------------------------
    ; 64-Bit Example (Dividend DOES NOT Fit Entirely in A Register)
    ;
    ; 64-bit division uses RDX:RAX as a 128-bit dividend.
    ;----------------------------------------------------------------------------
    qDivisor7       dq      1000000

    qQuotient7      dq      0
    qRemainder7     dq      0

section .bss
    dqDividend7     resq    2

section .text
global _start

_start:

;--------------------------------------------------------------------------------------------------
; Example 1: 8-Bit Division
;
; AX ÷ operand
;
; Quotient stored in AL
; Remainder stored in AH
;--------------------------------------------------------------------------------------------------

ByteDivisionExample:

    ; Dividend must be loaded into AX for 8-bit divide.
    ; RECALL: AL is the lower 8-bits of the AX register
    mov al, byte [bDividend1]

    ; The dividend is contained entirely in the AL part of the AX register,
    ; so we need to zero out any garbage values from the AH part of the register 
    xor ah, ah

    ; Perform the division
    div byte [bDivisor1] 

    ; 17 ÷ 10
    ; Quotient  = 1
    ; Remainder = 7

    mov byte [bQuotient1], al
    mov byte [bRemainder1], ah

;--------------------------------------------------------------------------------------------------
; Example 2: 16-Bit Division (Dividend Fits Entirely in A Register)
;
; DX:AX ÷ operand
;
; Quotient stored in AX
; Remainder stored in DX
;--------------------------------------------------------------------------------------------------

WordDivisionExampleA:

    ; AX contains the complete dividend.
    mov ax, word [wDividend2]

    ; Clear DX before division.
    xor dx, dx

    div word [wDivisor2]

    ; 17 ÷ 10
    ;
    ; Quotient  = 1
    ; Remainder = 7

    mov word [wQuotient2], ax
    mov word [wRemainder2], dx

;--------------------------------------------------------------------------------------------------
; Example 3: 16-Bit Division (Dividend DOES NOT Fit Entirely in A Register)
;
; DX:AX ÷ operand
;
; Quotient stored in AX
; Remainder stored in DX
;--------------------------------------------------------------------------------------------------

WordDivisionExampleB:

    ; dDividend3 = 100,005
    ;
    ; The dividend no longer fits entirely within AX.
    ; Therefore it must be split across DX:AX.
    mov ax, word [dDividend3]
    mov dx, word [dDividend3 + 2]

    ; Do NOT clear DX. DX contains the upper 16 bits of the dividend.

    div word [wDivisor3]

    ; 100,005 ÷ 1,000
    ;
    ; Quotient  = 100
    ; Remainder = 5

    mov word [wQuotient3], ax
    mov word [wRemainder3], dx

;--------------------------------------------------------------------------------------------------
; Example 4: 32-Bit Division (Dividend Fits Entirely in A Register)
;
; EDX:EAX ÷ operand
;
; Quotient stored in EAX
; Remainder stored in EDX
;--------------------------------------------------------------------------------------------------

DoubleWordDivisionExampleA:
    
    ; EAX contains the complete dividend.
    mov eax, dword [dDividend4]

    ; Clear EDX before division.
    xor edx, edx

    div dword [dDivisor4]

    ; 100,005 ÷ 1,000
    ;
    ; Quotient  = 100
    ; Remainder = 5

    mov dword [dQuotient4], eax
    mov dword [dRemainder4], edx

;--------------------------------------------------------------------------------------------------
; Example 5: 32-Bit Division (Dividend DOES NOT Fit Entirely in A Register)
;
; EDX:EAX ÷ operand
;
; Quotient stored in EAX
; Remainder stored in EDX
;--------------------------------------------------------------------------------------------------

DoubleWordDivisionExampleB:

    ; qDividend5 = 5,000,000,000
    ;
    ; The dividend no longer fits entirely within EAX.
    ; Therefore it must be split across EDX:EAX.
    mov eax, dword [qDividend5]
    mov edx, dword [qDividend5 + 4]

    ; Do NOT clear EDX. EDX contains the upper 32 bits of the dividend.
    div dword [dDivisor5]

    ; 5,000,000,000 ÷ 100,000
    ;
    ; Quotient  = 50,000
    ; Remainder = 0

    mov dword [dQuotient5], eax
    mov dword [dRemainder5], edx

;--------------------------------------------------------------------------------------------------
; Example 6: 64-Bit Division (Dividend Fits Entirely in A Register)
;
; RDX:RAX ÷ operand
;
; Quotient stored in RAX
; Remainder stored in RDX
;--------------------------------------------------------------------------------------------------

QuadWordDivisionExampleA:
    ; RAX contains the complete dividend.
    mov rax, qword [qDividend6]

    ; Clear RDX before division.
    xor rdx, rdx

    div qword [qDivisor6]

    ; 306,600,000,000 ÷ 1,000,000
    ;
    ; Quotient  = 306,600
    ; Remainder = 0

    mov qword [qQuotient6], rax
    mov qword [qRemainder6], rdx

;--------------------------------------------------------------------------------------------------
; Example 7: 64-Bit Division (Dividend DOES NOT Fit Entirely in A Register)
;
; RDX:RAX ÷ operand
;
; Quotient stored in RAX
; Remainder stored in RDX
;--------------------------------------------------------------------------------------------------

QuadWordDivisionExampleB:
    ; Assume dqDividend7 already contains a 128-bit dividend.
    ; (Right now it is an uninitialized buffer, but pretend it has a value.)

    ; This example demonstrates the mechanics of loading a 128-bit dividend into RDX:RAX.

    ; The dividend no longer fits entirely within RAX.
    ; Load the lower 64 bits first.

    mov rax, qword [dqDividend7]

    ; Load the upper 64 bits next.
    mov rdx, qword [dqDividend7 + 8]

    ; Do NOT clear RDX. RDX contains the upper 64 bits of the dividend.

    div qword [qDivisor7]

    mov qword [qQuotient7], rax
    mov qword [qRemainder7], rdx

Exit:

    mov rax, 60
    mov rdi, 0
    syscall