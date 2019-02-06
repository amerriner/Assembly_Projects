TITLE Composite numbers     (project04.asm)

; Author: Ashley Merriner
; Course / Project ID    CS271 project#4      Date: 10/25/18
; Description: This program uses procedures and sub-procedures to list composite numbers in a user
; generated range.

INCLUDE Irvine32.inc

; (insert constant definitions here)
UPPER_LIMIT = 400
LOWER_LIMIT = 1

.data

compNum		DWORD	4			; number currently being checked if composite
userNum		DWORD	?			
numOfNums	DWORD	0			; keep track of how many numbers are in a row
intro		BYTE	"Composite Numbers              Programmed by Ashley Merriner", 0
instruct	BYTE	"How many composite numbers would you like to see? I will accept any number between 1 and 400! ", 0
outOfRange	BYTE	"You chose a number out of range. Please enter another number between 1 and 400: ",0
goodBye		BYTE	"Thank you for playing! Goodbye :) ",0
spaces		BYTE	"   ",0

.code

; Main procedure to implement program
; receives: none
; returns: exits program
; preconditions: none
; registers changed: none
main PROC

	call	introduction
	call	getUserData
	call	showComposites
	call	farewell

	exit	; exit to operating system
main ENDP

		
; Procedure that introduces the program and programmer
; Receives: intro is a global variable
; returns: none
; preconditions: none
; registers changed: edx
introduction PROC
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introduction ENDP

; Procedure that asks user how many composite numbers to display
; Receives: instruct is a global variable
; returns: global variable userNum now contains user-entered number
; preconditions: none
; registers changed: edx, eax
getUserData  PROC						 
	mov		edx, OFFSET instruct
	call	WriteString
	call	validate					 ; call sub-procedure to make sure user enters number within range
	call	CrLf
	ret
getUserData  ENDP

; Procedure that displays composite numbers based on number user entered
; Receives: global variables userNum, numOfNums, compNum, spaces
; Returns: none
; preconditions: 1 <= userNum <= 400
; registers changed: eax, ebx, ecx, edx
showComposites PROC
	
	mov		ecx, userNum				   ; start loop counter
	display:
		mov		eax, numOfNums			   ; keep track of how many numbers are on each line
		cmp		eax, 10
		jge		newLine			

		compositeTrue:
			call	isComposite			   ; call subprocedure to check if number is a composite 
			cmp		eax, 1				   ; boolean value to check composite status of compNum
			jne		tryAgain			   ; if it is not a composite, move to next number
			mov		eax, compNum		   ; else, display number
			call	WriteDec
			mov		edx, OFFSET spaces
			call	WriteString
			jmp		loopAgain

		newLine:							; if line already has 10 numbers, jump to next line
			call	CrLf
			mov		numOfNums, 0			; reset to zero for new line
			jmp		compositeTrue

		tryAgain:
			inc		compNum				   ; move to next number and retry composite check
			jmp		compositeTrue

		loopAgain:
			inc		compNum				   ; increment number
			inc		numOfNums			   ; record there is another number in the line
			loop	display				   ; loop
	
	call	CrLf
	ret
showComposites ENDP

; Procedure that says goodbye to user
; Receives: global variable goodbye
; Returns: none
; preconditions: program has ran correctly
; registers changed: edx
farewell PROC						
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf
	ret
farewell ENDP

; Procedure that checks that user number is within range
; receives: global variables userNum, outofRange and constants UPPER_LIMIT and LOWER_LIMIT
; returns: none
; preconditions: user enters number
; registers changed: eax, edx
validate PROC						   	   
	isCorrect:
		call	ReadInt
		cmp		eax, UPPER_LIMIT
		jg		notCorrect
		cmp		eax, LOWER_LIMIT
		jl		notCorrect
		mov		userNum, eax
		jmp		goBack

	notCorrect:
		mov		edx, OFFSET outOfRange
		call	WriteString
		jmp		isCorrect
	goBack:
		ret
validate ENDP

; Procedure to check if next number is a composite number
; receives: global variable compNum
; returns: boolean check in eax that number is composite
; preconditions: compNum >= 0
; registers changed: eax, ebx, edx
isComposite PROC

	; algorithms to check for prime number (6n + 1 and 6n - 1, respectively)
	mov		eax, compNum
	inc		eax
	cdq
	mov		ebx, 6
	div		ebx
	cmp		edx, 0
	je		primeNum					   ; if the remainder is 0, the number satisfies prime number requirement, report false (not composite) to parent procedure

	mov		eax, compNum
	dec		eax
	cdq	
	mov		ebx, 6
	div		ebx
	cmp		edx, 0
	je		primeNum					   ; same as above

	mov		eax, 1						   ; else, report true
	jmp		again

	primeNum:							   ; report false
		mov		eax, 0
		jmp		again
	
	again:								   ; return to parent procedure
		ret

isComposite ENDP
END main
