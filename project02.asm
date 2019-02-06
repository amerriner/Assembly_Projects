TITLE Fibonacci Sequence    (project02.asm)

; Author: Ashley Merriner
; Course / Project ID     CS271   #02            Date: 10/5/2018
; Description: This program receives a number from the user, validates the input, and then calculates the Fibonacci terms for that number.

INCLUDE Irvine32.inc

; (insert constant definitions here)
UPPER_LIMIT = 46  ; cannot input a larger number
LOWER_LIMIT	= 1	; cannot input a lower number
MAX_STRING = 20 ; largest username allowed

.data
userName	BYTE	MAX_STRING+1 DUP (?)  ; array to contain string
userNum		DWORD	?
openPhrase	BYTE	"Fibonacci Sequence  by  Ashley Merriner",0
greet		BYTE	"Hello, ", 0
namePrompt	BYTE	"Please enter your name:", 0
numPrompt	BYTE	"Please choose the number of Fibonacci terms you want displayed, from 1 to 46: ", 0
invalid		BYTE	"You have chosen a number outside the 1-46 range.", 0
lastNum		DWORD	0                     ; these 3 numbers
presNum		DWORD	1                     ; track and store the 
temp		DWORD	?                     ; quantities for Fib sequence
space		BYTE	"      ", 0
count		DWORD	2                     ; tracks number of terms printed
cert		BYTE	"Results confirmed by Ashley Merriner.", 0
goodbye		BYTE	"Goodbye, ", 0
exclaim		BYTE	"!", 0
amazing		BYTE	"Something amazing!!!", 0
.code
main PROC

; introduction: introduce self and program
	mov		edx, OFFSET openPhrase
	call	WriteString
	call	CrLf

; userInstructions: ask user to enter name, store userName and print greeting	
	mov		edx, OFFSET namePrompt
	call	WriteString
	call	ReadString
	call	CrLf

	mov		edx, OFFSET userName
	mov		ecx, MAX_STRING            ; max number of characters allowed for userName
	call	ReadString

	mov		edx, OFFSET greet          ;  greet user, include stored userName
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET exclaim
	call	WriteString
	call	CrLf

; getUserData: begin fibonacci commands
askNum:		                          ; loop to validate user input
	mov		edx, OFFSET numPrompt
	call	WriteString
	call	ReadInt
	cmp		eax, UPPER_LIMIT          ; compare user input and UPPER_LIMIT
	jg		invalidInput              ; if input is greater than constant UPPER_LIMIT, jump to invalidInput 
	cmp		eax, LOWER_LIMIT		  ; comp input and LOWER_LIMIT
	jl		invalidInput			  ; if input is less than constant LOWER_LIMIT, jump to invalidInput
	mov		userNum, eax              ; else, store input in userNum
	call	CrLf

; displayFibs: show as many terms in Fibonacci sequence as user input
mov		eax, presNum                  ; show first 1 of sequence
call	WriteDec
mov		edx, OFFSET space
call	WriteString
mov		ecx, userNum                  ; how many loops to complete
dec		ecx                           ; minus one to account for 1 already printed
fibLoop:
	mov		eax, presNum
	add		eax, lastNum
	call	WriteDec
	mov		temp, eax                 ; calculate and store new values to get next fibonacci term on next loop
	mov		eax, presNum
	mov		lastNum, eax
	mov		eax, temp
	mov		presNum, eax
	call	WriteString
	mov		eax, count
	cmp		eax, 5                    ; if 5 terms have been shown, jump to newLine
	jge		newLine
	loopBack:
		inc		eax                   ; continue loop
		mov		count, eax
		loop	fibLoop
	
	jmp		quit
	newLine:                          ; if 5 terms have been printed, start a new line
		call	CrLf
		mov		eax, 0
		mov		count, eax            ; reset count
		jmp		loopBack
	

invalidInput:	                      ; if input is greater than 46 or less than 1
	mov		edx, OFFSET invalid
	call	WriteString
	call	CrLf
	jmp		askNum                    ; repeat validation loop

; farewell: end of program, including certification and goodbye to user with userName
quit:   
	call	CrLf
	call	CrLf
	mov		edx, OFFSET cert
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET exclaim
	call	WriteString
	call	CrLf
	
	exit	; exit to operating system

main ENDP


END main
