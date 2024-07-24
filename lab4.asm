
.ORIG x3000
    
; Name: Vidmahi Sistla
; Date: 04 / 07 / 2024
; Lab #4
;

; BLOCK 1
; Register R0 is loaded with m[x4000].
; This will serve as the pointer to the head node of the linked list.
;  

	LDI R0, PTR1
    BR  BLOCK2

PTR1 .FILL x4000

    
; BLOCK 2
; 
; In this block you will prompt the user for the Building Abbreviation and Room Number 
; by printing on the monitor the string “Type the room to be reserved and press Enter: ” 
; and wait for the user to input a string followed by <Enter> (ASCII: x0A). 
; (Assume that there is no case where the user input exceeds the maximum number of characters).

BLOCK2:  
    LEA R0, PROMPT
    PUTS
        
    LEA R1, USERINPUT
        
LOOP:
    AND R2, R2, #0
    
; Check if the user inputs an Enter, whose ASCII code is x0A.
; If it is not Enter, then store the character at the reserved block of memory labeled USERINPUT
; The reserved block of memory is 11 locations (maximum of 10 characters, and null terminator).
; In this block you must also display each character that the user types.

    ADD R2, R2, x0A
    GETC
    OUT
    
    STR R0, R1, #0
    ADD R1, R1, #1
    
    NOT R0, R0     
    ADD R0, R0, #1
    ADD R2, R0, R2
    
    BRnp LOOP

    ADD R1, R1, #-1
    STR R2, R1, #0

    BR BLOCK3


PROMPT  .STRINGZ    "Type the room to be reserved and press Enter: "     
USERINPUT   .BLKW   xB

; Block 3: In this block you will check if there is a match between the entered 
; user string with an entry in the linked list.
; Your program must search the list of currently available rooms to find a match for the 
; entered Building Abbreviation and Room Number. The list stores all the currently available rooms. 
; You will find a match only if the room is in the list. It is possible to not find a match in the list. 

; If your program finds a match, then it must print out “<Building Abbreviation and Room Number> 
; is currently available!” (eg., “GSB 2.126 is currently available!”)

; Note that if there is a match, it must branch to DONE.
; If there is no match, it must branch to BLOCK4

BLOCK3:
    LD R0, PTR1
    LDR R1, R0, #0
    
    BRz DOESNT_MATCH
    
    LDR R0, R1, #0
    LEA R4, USERINPUT
    
    BR TRAVERSE_LIST
    
INNER_LOOP:
    LDR R1, R0, #0
    ADD R0, R0, #1
    LDR R2, R0, #0

    BRz TRAVERSE_LIST

COMPARE:
    LDR R5, R4, #0
    LDR R3, R2, #0
    
    BRz MATCHING
    
    NOT R5, R5
    ADD R5, R5, #1
    ADD R3, R3, R5
    
    BRnp TRAVERSE_LIST
    
    ADD R4, R4, #1
    ADD R2, R2, #1
    
    BR COMPARE

    ADD R0, R0, #1
    ADD R4, R4, #1
    
    BR INNER_LOOP
    
TRAVERSE_LIST:
    LEA R4, USERINPUT
    ADD R0, R1, #0
    ADD R0, R0, #0
    
    BRnp INNER_LOOP
    BRz DOESNT_MATCH


MATCHLIST  .STRINGZ    " is currently available!"

; Block 4: You will enter this block only if there was no match with the linked list. 
; In this block you must print out “<Building Abbreviation and Room Number> is NOT currently available.” 
; (eg., “GSB 2.126 is NOT currently available.”).
;

MATCHING:
    LEA R0, USERINPUT
    PUTS
    
    LEA R0, MATCHLIST
    PUTS
    
    BR DONE

DOESNT_MATCH:
    LEA R0, USERINPUT
    PUTS
    
    LEA R0, NOMATCHTLIST
    PUTS


NOMATCHTLIST  .STRINGZ    " is NOT currently available."

DONE:
    HALT


    .END
