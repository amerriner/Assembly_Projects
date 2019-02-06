TITLE  Introduction and Integer Arithmetic    (project01.asm)

; Author: Ashley Merriner
; Course / Project ID: CS 271 proj#1      Date: 9/26/18
; Description: This project introduces the program and completes integer arithmetic of user chosen numbers, including addition, subtraction, multiplication, and division

INCLUDE Irvine32.inc

; Constant definition
PLAY_AGAIN = 1

.data
; variable definition
intro_1		BYTE  "Introduction and Integer Arithmetic    by: Ashley Merriner", 0
intro_2		BYTE  "Enter two numbers to find their sum, difference, product, quotient, and remainder.", 0
intro_3		BYTE  "First number: ", 0
intro_4		BYTE  "Second number: ", 0
plus		BYTE  " + ", 0
minus		BYTE  " - ", 0 
mult		BYTE  " x ", 0
divide		BYTE  " ", 246, " ",0     ;ascii key
remain		BYTE  " remainder ", 0
equals		BYTE  " = ", 0
firstNum	DWORD ?           ; first number user chooses   
secondNum	DWORD ?           ; second number user chooses
result		DWORD ?			  ; result
remainder	DWORD ?			  ; remainder from division
wrongInput	BYTE  "Your first number must be greater than your second!", 0
playAgain	BYTE  "Would you like to play again? Press 1 for yes or literally anything else to quit: " , 0
ec_1		BYTE  "**EC: Program repeats until user chooses to quit", 0
ec_2		BYTE  "**EC: Program validates the second number to be less than the first", 0
goodBye		BYTE  "Thanks for playing! Goodbye!", 0

.code
main PROC

; Display name and program title
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec_1		; extra print statements for extra credit
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec_2
	call	WriteString
	call	CrLf
	call	CrLf

	; Loop for user to keep playing
	again:
	; Display instructions for user
		mov		edx, OFFSET intro_2
		call	WriteString
		call	CrLf
		call	CrLf

	; Prompt user to enter two numbers
		mov		edx, OFFSET intro_3
		call	WriteString			; ask for first number
		call	ReadInt				; user's first number input
		mov		firstNum, eax		; store first number in variable
		mov		edx, OFFSET intro_4
		call	WriteString			; ask for second number
		call	ReadInt				; user's second number input
		mov		secondNum, eax		; store second number in variable
		call	CrLf

	; Make sure first number is greater than the second
		mov		eax, firstNum
		cmp		eax, secondNum
		jle		incorrect

	; Calculate the sum and display
		;	add
		mov		eax, firstNum
		add		eax, secondNum
		mov		result, eax

		;	display code
		mov		eax, firstNum
		call	WriteDec
		mov		edx, OFFSET plus
		call	WriteString
		mov		eax, secondNum
		call	WriteDec
		mov		edx, OFFSET equals
		call	WriteString
		mov		eax, result
		call	WriteDec
		call	CrLf

	; Calculate the difference and display
		;	subtract
		mov		eax, firstNum
		sub		eax, secondNum
		mov		result, eax

		;	display
		mov		eax, firstNum
		call	WriteDec
		mov		edx, OFFSET minus
		call	WriteString
		mov		eax, secondNum
		call	WriteDec
		mov		edx, OFFSET equals
		call	WriteString
		mov		eax, result
		call	WriteDec
		call	CrLf

	; Calculate the product and display
		;	multiply
		mov		eax, firstNum
		mov		ebx, secondNum
		mul		ebx
		mov		result, eax

		;	display
		mov		eax, firstNum
		call	WriteDec
		mov		edx, OFFSET mult
		call	WriteString
		mov		eax, secondNum
		call	WriteDec
		mov		edx, OFFSET equals
		call	WriteString
		mov		eax, result
		call	WriteDec
		call	CrLf

	; Calculate the quotient and remainder and display
		;	divide
		mov		eax, firstNum
		cdq		; converts to quadword
		mov		ebx, secondNum
		div		ebx
		mov		result, eax
		mov		remainder, edx

		;	display
		mov		eax, firstNum
		call	WriteDec
		mov		edx, OFFSET divide
		call	WriteString
		mov		eax, secondNum
		call	WriteDec
		mov		edx, OFFSET equals
		call	WriteString
		mov		eax, result
		call	WriteDec
		mov		edx, OFFSET remain
		call	WriteString
		mov		eax, remainder
		call	WriteDec
		call	CrLf
		call	CrLf
		jmp		theEnd  ; jump to prompt asking user if they want to play again

	incorrect: 
	; lable if second number is greater or equal than the first
		mov		edx, OFFSET wrongInput
		call	WriteString
		call	CrLf
		call	CrLf

	theEnd:
	; ask user if they want to play again
		mov		edx, OFFSET playAgain
		call	WriteString
		call	ReadInt
		call	CrLf
		call	CrLf
		cmp		eax, PLAY_AGAIN	; compare user input to constant PLAY_AGAIN
		je		again			; jump back to lable AGAIN if eax == constant PLAY_AGAIN

; Display a terminating message.
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main
