TITLE Example of ASM                (asmExample.ASM)

; This program locates the cursor and displays the
; system time. It uses two Win32 API structures.
; Last update: 6/30/2005

INCLUDE Irvine32.inc

; Redefine external symbols for convenience
; Redifinition is necessary for using stdcall in .model directive 
; using "start" is because for linking to WinDbg.  added by Huang
 
main          EQU start@0

Str_nextWord PROTO,
	pString:PTR BYTE, 									; pointer to string
	delimiter:BYTE 										; delimiter to find
.data
	testStr BYTE "ABC\DE\FGHIJK\LM",0
	
.code
main PROC	
	call Clrscr
	mov edx, OFFSET testStr 							; display string
	call WriteString
	call Crlf



; Loop through the string, replace each delimiter, and
; display the remaining string.


	mov esi, OFFSET testStr
L1: INVOKE Str_nextword, esi, '\'   					;look for delimiter
	jnz Exit_prog 										; quit if not found 
	mov esi, edi 										; point to next substring
	mov edx, edi										; WriteString從pString開始印
	call WriteString 									; display remainder of string
	call Crlf
	jmp L1												
Exit_prog:
	call WaitMsg
exit
main ENDP


Str_nextWord PROC,
		pString:PTR BYTE, 									; pointer to string
		delimiter:BYTE 										; delimiter to find
	
	INVOKE Str_length, pString							;eax=pString的長度
	mov ecx, eax										;ecx=eax=pString的長度
	mov edi, pString  									;edi=開始尋找位置
	mov al, delimiter									;al=想找的字元
	repne scasb
	
	ret
Str_nextWord ENDP
END main