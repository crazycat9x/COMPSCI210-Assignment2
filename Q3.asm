; Program to count occurrences of a character in a file.
; Character to be input from the keyboard.
; Result to be displayed on the monitor.
; Program only works if no more than 9 occurrences are found.
; 
;
; Initialization
;
		.ORIG	x3000
		AND	R2, R2, #0			; R2 is counter, initially 0
		LD	R3, PTR				; R3 is pointer to characters
		GETC					; R0 gets character input
		LDR	R1, R3, #0			; R1 gets first character
;
; Test character for end of file
;
TEST	ADD	R4, R1, #-10		; Test for end of line (ASCII xA)
		BRz	OUTPUT				; If done, prepare the outpu
;
; Test character for match.  If a match, increment count.
;
		NOT	R1, R1
		ADD	R1, R1, R0			; If match, R1 = xFFFF
		NOT	R1, R1				; If match, R1 = x0000
		BRnp	CAP				; If no match, test for capital ones
		ADD	R2, R2, #1
        BRnzp GETCHAR
;
; Test if match case
;
CAP 	LD	R5, VALUE			; Load 32 into R5
		ADD R1, R1, R5			; If match R1 = x0000
		BRnp	GETCHAR	
		ADD	R2, R2, #1
;	
; Get next character from file.
;
GETCHAR	ADD	R3, R3, #1			; Point to next character.
		LDR	R1, R3, #0			; R1 gets next char to test
		BRnzp	TEST
;
; Output the count.
;
OUTPUT	OUT
        AND R6, R6, #0

LOOP    ADD R2, R2, #-10		; Decrease most significant digit by 1
        BRn     PRE				; If all significant digit are deducted go to calculate least significant digit
        ADD R6, R6, #1			; Add 1 to most significant digit
        BRz     FINAL			; Go straight to output if there are no least significant digit
        BRnzp   LOOP			; Redo the loop

PRE     ADD R2, R2, #10			; Calculate least significant digit

FINAL   LD	R0, ASCII			; Load the ASCII template
		ADD	R0, R0, R6			; Convert most significant digit to ASCII
        OUT						; Most significant digit is displayed
        LD  R0, ASCII			; Load the ASCII template
        ADD R0, R0, R2			; Convert least significant digit to ASCII
		OUT						; Least significant digit is displayed.
		HALT					; Halt machine
;
; Storage for pointer and ASCII template
;
ASCII	.FILL	x0030
PTR		.FILL	x4000
VALUE	.FILL	#32
		.END