; Name: Vidmahi Sistla
; Date: 04 / 17 / 2024
; Lab #5
;

; BLOCK 1
; OPERATING SYSTEM CODE

.ORIG x500
        
        LD R0, VEC  ; VEC contains x1080 which is the address in the interrupt vector table that needs to contains the startung address of the ISR.
        LD R1, ISR  ; ISR contains the starting address of the ISR.
        ; (1) Initialize interrupt vector table with the starting address of ISR.
        STR R1, R0, #0


        ; (2) Set bit 14 of KBSR. [To Enable Interrupt]
        LD  R2, MASK
        LDI R3, KBSRPTR
        
        NOT R3, R3
        AND R3, R2, R3
        NOT R3, R3
        
        STI R3, KBSRPTR
        
    

        ; (3) Set up system stack to enter user space. So that PC can return to the main user program at x3000.
	      ;     R6 is the Stack Pointer. Remember to Push PC and PSR in the right order. Hint: Refer State Graph
        LD  R3, PSR
        LD  R4, PC
        LD  R6, PC
        
        ADD R6, R6, #-1
        STR R3, R6, #0
        ADD R6, R6, #-1
        STR R4, R6, #0
        
        
        ; (4) Enter user Program.
        RTI
        
VEC     	.FILL x0180
ISR     	.FILL x1700
KBSRPTR		.FILL xFE00
MASK    	.FILL xBFFF
PSR     	.FILL x8002
PC      	.FILL x3000
ENABLEBIT   	.FILL   x4000

.END


; BLOCK 2
; INTERRUPT SERVICE ROUTINE

.ORIG x1700

; Callee save

ST R0, SAVER0
ST R1, SAVER1
ST R2, SAVER2
ST R3, SAVER3
ST R4, SAVER4
ST R5, SAVER5
ST R7, SAVER7

; CHECK THE KIND OF CHARACTER TYPED AND PRINT THE APPROPRIATE PROMPT

;AND R0, R0, #0
LD R0, KBDR
LDR R0, R0, #0

LD R2, ASCII_LowerX
ADD R4, R2, R0
BRz STOP
LD R2, ASCII_UpperX
ADD R4, R2, R0
BRz STOP

Next:
LD R2, ASCII_NUM
ADD R4, R2, R0
BRn Is_Not_Correct
BRz NUMBER
LD R2, ASCII_NUM_LIMIT
ADD R4, R2, R0
BRnz NUMBER

LD R2, ASCII_UC
ADD R4, R2, R0
BRn Is_Not_Correct
BRz LETTER
LD R2, ASCII_UC_LIMIT
ADD R4, R2, R0
BRnz LETTER

LD R2, ASCII_LC
ADD R4, R2, R0
BRn Is_Not_Correct
BRz LETTER
LD R2, ASCII_LC_LIMIT
ADD R4, R0, R2
BRnz LETTER
BRp Is_Not_Correct

STOP:
    LEA R4, STRING4
    LDR, R0, R4, #0

NUMBER_POLLING:
    ;AND R2, R2, #0
    LDI R2, DSR
    BRzp NUMBER_POLLING
    STI R0 DDR
    ADD R4, R4, #1
    LDR R0, R4, #0
    BRnp NUMBER_POLLING
    ; BR LAST
HALT

NUMBER:
    ;AND R4, R4, #0
    LEA R4, STRING2
    LDR R0, R4, #0

POLLING2:
    AND R2, R2, #0
    LDI R2, DSR
    BRzp POLLING2
    STI R0 DDR
    ADD R4, R4, #1
    LDR R0, R4, #0
    BRnp POLLING2

BR LAST


Is_Not_Correct:
    LEA R4, STRING3
    LDR R0, R4, #0

POLLING3:
    ;AND R2, R2, #0
    LDI R2, DSR
    BRzp POLLING3
    STI R0 DDR
    ADD R4, R4, #1
    LDR R0, R4, #0
    BRnp POLLING3

BR LAST

LETTER:
    LEA R4, STRING1
    LDR R0, R4, #0

LETTER_POLLING:
    LDI R2, DSR
    BRzp LETTER_POLLING
    STI R0, DDR
    ADD R4, R4, #1
    LDR R0, R4, #0
    BRnp LETTER_POLLING

    
LAST: 
    LD R0, SAVER0
    LD R1, SAVER1
    LD R2, SAVER2
    LD R3, SAVER3 
    LD R4, SAVER4
    LD R5, SAVER5
    LD R7, SAVER7

RTI



MEM .FILL x4000

ASCII_NUM .FILL x-30
ASCII_LC  .FILL x-61
ASCII_UC  .FILL x-41

ASCII_LC_LIMIT .FILL x-7A
ASCII_UC_LIMIT .FILL x-5A
ASCII_NUM_LIMIT .FILL x-39

ASCII_LowerX .FILL x-78
ASCII_UpperX .FILL x-58

KBSR2 .FILL xFE00
KBDR  .FILL xFE02
DSR   .FILL xFE04
DDR   .FILL xFE06

SAVER0 .BLKW x1
SAVER1 .BLKW x1
SAVER2 .BLKW x1
SAVER3 .BLKW x1
SAVER4 .BLKW x1
SAVER5 .BLKW x1
SAVER7 .BLKW x1

STRING1 .STRINGZ "\nUser has entered a letter of the alphabet!\n"
STRING2 .STRINGZ "\nUser has entered a decimal digit!\n"
STRING3 .STRINGZ "\nERROR: User input is invalid!\n"
STRING4 .STRINGZ "\n---------- User has Exit the Program ----------\n"

.END




; BLOCK 3
; USER PROGRAM

.ORIG x3000

UPPER_LOOP  LD  R1, COUNT
            LEA R0, MESSAGE
            PUTS
            ;LD  R1, COUNT
            
LOOP_MAIN   ADD R1, R1, #-1
            BRNP LOOP_MAIN
            
            BRZ  UPPER_LOOP
            
            
            

; MAIN USER PROGRAM
; PRINT THE MESSAGE "Enter a character…" WITH A DELAY LOGIC





COUNT .FILL xFFFF
MESSAGE .STRINGZ  "Enter a character…\n"

.END