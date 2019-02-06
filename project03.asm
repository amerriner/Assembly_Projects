TITLE Signed Integer accumulation  (project03.asm)

; Author: Ashley Merriner
; Course / Project ID:  CS270 Project#03       Date: 10/16/18
; Description: This program repeatedly asks the user to enter a number between -100 and -1, 
; and then adds the numbers together until the user enters a non-negative number. 
; Then this program will calculate the average of the negative numbers and display
; the average to the user, along with the sum, the number of numbers inputted, 
; and a parting message.

INCLUDE Irvine32.inc

UPPER_LIMIT = -1
LOWER_LIMIT = -100
MAX_STRING = 20

.data

userName	BYTE   MAX_STRING+1 DUP (?)
sum			SDWORD 0		
average		SDWORD 0
count		SDWORD 0
intro		BYTE   "Signed Integer Accumulation by Ashley Merriner", 0
askName		BYTE   "Please enter your name: ", 0
greet		BYTE   "Hello, ", 0
excl		BYTE   "!", 0
instruct	BYTE   "This program will prompt you for a negative number, then add and average those numbers for you.", 0
askNum		BYTE   "Please enter a negative number between -1 and -100: ", 0
userNum		SDWORD ?
wrong		BYTE   "You chose a number outside the correct range.", 0
displaySum  BYTE   "The sum of your numbers is: ", 0
displayAv	BYTE   "The average of your numbers is: ", 0
disCount1	BYTE   "You entered ", 0
disCount2	BYTE   " numbers.", 0
noNum		BYTE   "You did not enter any numbers.", 0
goodBye		BYTE   "Thank you for playing, ", 0



.code
main PROC

; displayTitle: displays the name of the programmer and title of the program
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf

; getUserData: ask user for name, display a greeting
	mov		edx, OFFSET askName
	call	WriteString

	mov		edx, OFFSET userName
	mov		ecx, MAX_STRING
	call	ReadString
	call	CrLf

	mov		edx, OFFSET greet
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET excl
	call	WriteString
	call	CrLf

; instructionSet: explain the program to the user
	mov		edx, OFFSET instruct
	call	WriteString
	call	CrLf

; numberPrompt: repeatedly ask user for a number. If number not in range, repeat. If number non-negative, exit.
; Also, add numbers together and count how many numbers entered. 
numberPrompt:	
	mov		edx, OFFSET askNum
	call	WriteString
	call	ReadInt
	cmp		eax, LOWER_LIMIT  
	jl		outsideBounds  ; if number is lower than -100, jump to outsideBounds
	cmp		eax, UPPER_LIMIT
	jg		calculate   ; if number is greater than -1, user wants to quit, move forward in program

	mov		userNum, eax
	mov		eax, sum
	add		eax, userNum
	mov		sum, eax
	mov		eax, count
	inc		eax
	mov		count, eax
	jmp		numberPrompt

outsideBounds: ; if number is lower than -100
	mov		edx, OFFSET wrong
	call	WriteString
	call	CrLf
	jmp		numberPrompt

; calc: Calculate the average of the numbers entered
calculate: 
	; if no numbers are entered, move to label noNumbers to display that message
	mov		eax, count
	cmp		eax, 0
	je		noNumbers

	mov		eax, sum
	cdq		; change to quadword
	mov		ebx, count
	idiv	ebx
	mov		average, eax
	jmp		display

; display: show the average, sum, and how many numbers were entered, as well as a parting message
display:
	; display the sum of the user entered numbers
	mov		edx, OFFSET displaySum
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf
	; display the average of the user entered numbers
	mov		edx, OFFSET displayAv
	call	WriteString
	mov		eax, average
	call	WriteInt
	call	CrLf
	; display how many numbers the user entered
	mov		edx, OFFSET disCount1
	call	WriteString
	mov		eax, count
	call	WriteDec  ; use WriteDec so no positive sign displayed
	mov		edx, OFFSET disCount2
	call	WriteString
	call	CrLf
	jmp		goodbyeUser

noNumbers: ; if user entered no numbers 
	mov		edx, OFFSET noNum
	call	WriteString
	call	CrLf
	jmp		goodbyeUser

goodbyeUser:
	; say goodbye to user
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET excl
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP


END main
