TITLE Program 6A     (proj6A.asm)

; Author: Ashley Merriner
; Course / Project ID    CS 271 proj 6A             Date: 11/27/18
; Description: This program creates two macros, getString and displayString, 
; and two procedures, ReadVal and WriteVal,
; that uses 10 user-entered integers to find their sum and average
; by reading them as a string and then converting the ASCII characters to their number,
; and then back again.  

INCLUDE Irvine32.inc

MAXSIZE = 10

getString MACRO text, buffer
	push	ecx
	push	edx
	mov		edx, text
	call	WriteString
	mov		edx, buffer
	mov		ecx, 25
	call	ReadString
	pop		edx
	pop		ecx
ENDM

displayString MACRO buffer
	push	edx
	mov		edx, buffer
	call	WriteString
	pop		edx
ENDM

.data
intro		BYTE	"PROGRAMMING ASSIGNMENT 6A: Designing and implementing low-level I/O procedures.", 0
proName		BYTE	"Written By: Ashley Merriner", 0
instruct1	BYTE	"Please provide 10 unsigned integers.", 0
instruct2	BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instruct3	BYTE	"After you have finished inputting the raw numbers, I will display a list of the integers, their sum, and their average value.", 0
enterNum	BYTE	"Please enter an unsigned number: ", 0
wrongNum	BYTE	"ERROR: You did not enter an unsigned number or your number was too big.", 0
againNum	BYTE	"Please try again.", 0
listNums	BYTE	"You entered the following numbers: ",0
sumNums		BYTE	"The sum of those numbers is: ", 0
avNums		BYTE	"The average of those numbers is: ", 0
gBye		BYTE	"Thanks for playing!", 0
numString	DWORD	MAXSIZE DUP(?)
charString	BYTE	25 DUP(?)
numToString	BYTE	25 DUP(?)
sum			DWORD	0
average		DWORD	0
spaces		BYTE	", ", 0

.code
main PROC
	displayString	OFFSET intro
	call			CrLf
	displayString	OFFSET proName
	call			CrLf
	displayString	OFFSET instruct1
	call			CrLf
	displayString	OFFSET instruct2
	call			CrLf
	displayString	OFFSET instruct3
	call			CrLf
	call			CrLf
	mov			edi, OFFSET numString
	mov			esi, OFFSET charString
	mov			ecx, MAXSIZE
getNums:
	mov			eax, esi
	mov			ebx, edi
	push		ebx				;+20 numString
	push		eax				;+16 charString
	push		OFFSET enterNum ;+12
	push		OFFSET wrongNum ;+8
	call		ReadVal
	add			edi, 4
	loop		getNums
	call		CrLf
	mov			ecx, MAXSIZE
	mov			esi, OFFSET numString

	displayString	OFFSET listNums
	call		CrLf
showNums:								; display list of numbers while counting sum---can't do arithmetic on strings
	mov			eax, [esi]
	add			sum, eax
	push		eax						;numString user int +12
	push		OFFSET numToString		;+8
	call		WriteVal
	displayString	OFFSET spaces
	add			esi, 4
	loop		showNums
	call		CrLf
	displayString	OFFSET sumNums
	mov			eax, sum				
	push		eax						; +12
	push		OFFSET numToString		; +8
	call		WriteVal				; convert sum to string, write string with WriteVal Proc
	call		CrLf
	call		CrLf
	mov			edx, 0					; find average
	mov			ebx, MAXSIZE
	div			ebx
	mov			average, eax
	displayString	OFFSET avNums					
	push		eax						; +12
	push		OFFSET numToString		; +8
	call		WriteVal				; convert average to string, write string with WriteVal Proc
	call		CrLf
	call		CrLf
	
	displayString  OFFSET gBye
	call		CrLf
	exit	; exit to operating system
main ENDP

; Procedure that converts a string into an unsigned int 
; Receives: 1.address to array of characters 2.the address to the string that gives instructions to enter numbers 3. address to the string that tells if a user entered the wrong number 
; returns: filled array with user-inputted numbers
; preconditions: none
; registers changed: none, all pushed and popped back off
ReadVal		PROC
	push			ebp
	mov				ebp, esp		; set up stack
	pushad							; hold all registers
getData:
	mov				edi, [ebp+20]		;  pointer to numString
	mov				edx, [ebp+12]		; enterNum
	mov				esi, [ebp+16]		; pointer to charString
	mov				ebx, esi		
	getString		edx, ebx

	mov				ecx, eax		
	mov				eax, 0				; clear eax
	mov				ebx, 10				; multiply by 10
	mov				edx, 0				; x = 0, initialize accumulator

convertString:
	lodsb
	cmp				al, 47				; must be within ASCII digits range (48-57)
	jle				invalidInput
	cmp				al, 58
	jge				invalidInput
	
	sub				al, 48				; convert to int, lodsb loads string byte into al
	push			eax					; hold value in al 
	mov				eax, edx			; add accumulator to eax so can multiply
	mul				ebx					; multiply by ten
	jc				invalidInput
	mov				edx, eax			; make accumulator equal to current number	
	pop				eax					; get value in al back

	push			ecx					; hold counter for loop
	movsx			ecx, al				; movsx to easily transfer byte-sized number to 32-bit register
	add				edx, ecx			; add al to accumulator
	
	pop				ecx					; get back counter
	loop			convertString		; if more digits
	jmp				finished

invalidInput:
	push			edx			
	mov				edx, [ebp+8]		; wrongNum
	displayString	edx
	call			CrLf
	pop				edx
	jmp				getData				; reloop to get valid input, don't save number

finished:
	mov			[edi], edx				; move value into numString
	popad								; return to main with correct registers
	pop			ebp

	ret			16								; clean up stack
ReadVal		ENDP


; Procedure that first converts the array's integer into a string, then stores the string and displays it
; Receives: 1.address to string array 2.address to the integer being converted
; returns: a converted string array of the integer
; preconditions: array must be clear, and integer must be greater than 0 and able to fit in a 32 bit register
; registers changed: none, all pushed and popped back off
WriteVal	PROC
	push		ebp
	mov			ebp, esp
	pushad

	mov			eax, [ebp+12]				; user int to be converted
	mov			edi, [ebp+8]				; array to hold converted string
	push		0							; create endpoint for null-terminated string
	mov			ebx, 10						; divide by 10 instead of multiply...go backwards in formula
	
divideString:
	mov			edx, 0						; clear remainder for division
	div			ebx				
	add			edx, 48						; take remainder and convert to ASCII character (separates bytes to store individually in array)
	push		edx							; store newly converted character. Will be backwards, so push first, pop into array after finished converting
	cmp			eax, 0						; check if there is more of the digit to convert
	je			finishConversion			; if quotient is zero (no more digits), move on
	jmp			divideString				; else, continue loop
	
finishConversion: 							; pop value to reverse backwards-held string
	pop			[edi]						; mov character into string array
	mov			eax, [edi]					; check if that character is the null termination
	inc			edi							; move edi pointer forward to next digit
	cmp			eax, 0						; see if endpoint of string
	jne			finishConversion			; keep popping elements into array if not at end
	mov			ebx, [ebp+8]				; go back to beginning of array, all characters 
	displayString	ebx						; call macro to display
	popad
	pop			ebp
	ret			8							; clear stack
WriteVal	ENDP

END main
