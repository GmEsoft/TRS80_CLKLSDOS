
; Program		: CLKTD6XE/CMD
; Version		:
; Date First Version	:
; Compiling Date & Time	:
; Listing Date & Time	: ___ __, ____  -  __:__
; Author		: GmEsoft
; Purpose		: Load Host Clock in Emulated System (Europe)
; System		: TRS-80 Model 4 + Keil Emulator Extensions
;			  LS-DOS 6.3+
; Compiler		: MRAS

SVDATE	EQU	00A0H		;user storage area (debug save area)
DATE$	EQU	0033H		;date storage area
SFLAG$	EQU	007CH		;System Flags

@KEYIN	EQU	0009H
@DSPLY	EQU	000AH
@CMNDI	EQU	0018H
@CMNDR	EQU	0019H

;-----	Break into SIMZ80 debugger
$BREAK	MACRO
;	DB	0EDH,0F5H
	ENDM

	ORG	3000H
START:
	LD	HL,TITLE
	LD	A,@DSPLY
	RST	28H		;Display Title

	$BREAK
	IN	A,(6DH)		;check month from emulator clock
	DEC	A
	CP	12
	JR	NC,MANUAL	;jump to manual entry if no emulator clock
;	JR	MANUAL		;test

	LD	HL,ENDDAT	;pointer to end of "DATE DD/MM/YY" string
	IN	A,(6BH)		;get year
	CALL	WRITE2		;write year
	IN	A,(6DH)		;get month (!)
	CALL	WRITE2		;write month
	IN	A,(6CH)		;get day
	CALL	WRITE2		;write day
	LD	HL,CMDDAT	;exec DATE DD/MM/YY
	LD	A,@CMNDR
	RST	28H		;and return here

	LD	HL,ENDTIM	;pointer to end of "TIME HH:MM:SS" string
	IN	A,(68H)		;get secs
	CALL	WRITE2		;write secs
	IN	A,(69H)		;get mins
	CALL	WRITE2		;write mins
	IN	A,(6AH)		;get hours
	CALL	WRITE2		;write hours
	LD	HL,CMDTIM	;exec TIME HH:MM:SS
	LD	A,@CMNDI
	RST	28H             ;and exit

MANUAL
	LD	HL,NOSIM	;"No emulator found"
	LD	A,@DSPLY
	RST	28H		;display message
	$BREAK
	LD	A,(DATE$+2)	;check on currency of date
	DEC	A
	CP	12
	JR	C,DATEOK	;skip asking date if date is current

	LD	HL,SVDATE	;check saved date (in debug save area)
	LD	B,3		;compute checksum
	XOR	A
GETCKS	ADD	A,(HL)
	INC	HL
	DJNZ	GETCKS
	CP	(HL)		;compare with stored checksum
	JR	NZ,DATEIN	;ask date if no match

	LD	A,(SVDATE+2)	;check month
	DEC	A
	CP	12		;between 1 and 12 ?
	JR	NC,DATEIN	;ask date if saved date is not current
	LD	HL,SVDATE	;restore date
	LD	DE,DATE$
	LD	BC,3
	LDIR
	JR	DATEOK		;date OK, display it and ask time

DATEIN	LD	HL,IDATE	;prompt for date
	LD	A,@DSPLY
	RST	28H
	$BREAK
	LD	HL,SFLAG$	;get system flags
	LD	A,(HL)		;and save
	RES	5,(HL)		;temp disable JCL
	PUSH	AF
	LD	HL,CMDDAT+5	;input date
	LD	B,8
	LD	A,@KEYIN
	RST	28H
	$BREAK
	POP	AF
	LD	(SFLAG$),A	;restore system flags
	LD	A,B
	OR	A		;re-ask date if no date entered
	JR	Z,DATEIN
	LD	HL,CMDDAT	;exec DATE DD/MM/YY
	LD	A,@CMNDR
	RST	28H
	$BREAK
	JR	NZ,DATEIN	;re-ask if not ok

	LD	HL,DATE$	;save date to debug save area
	LD	DE,SVDATE
	LD	BC,3
	PUSH	DE
	LDIR
	POP	HL
	LD	B,3		;compute checksum
	XOR	A
PUTCKS	ADD	A,(HL)
	INC	HL
	DJNZ	PUTCKS
	LD	(HL),A		;save checksum
	XOR	A
	JR	TIMEIN		;ask time

DATEOK	LD	A,0DH		;display date
	LD	(CMDDAT+4),A
	LD	HL,CMDDAT	;exec DATE
	LD	A,@CMNDR
	RST	28H
	$BREAK

TIMEIN	LD	HL,ITIME	;Prompt for time
	LD	A,@DSPLY
	RST	28H
	$BREAK
	LD	HL,SFLAG$	;System Flags
	LD	A,(HL)		;save old flags
	RES	5,(HL)		;temp disable JCL
	PUSH	AF
	LD	HL,CMDTIM+5	;input time
	LD	B,8
	LD	A,@KEYIN
	RST	28H
	$BREAK
	POP	AF
	LD	(SFLAG$),A	;restore system flags
	LD	A,B
	OR	A
	JR	Z,DONE		;exit if no time entered
	LD	HL,CMDTIM	;exec TIME HH:MM:SS
	LD	A,@CMNDR
	RST	28H
	$BREAK
	JR	NZ,TIMEIN	;re-ask time if not OK

DONE
	$BREAK
	RET			;end program

;-----	Write backwards BCD date/time element in A @ HL
WRITE2	LD	B,A
	AND	0FH
	ADD	A,30H
	DEC	HL
	LD	(HL),A		;write low nibble
	LD	A,B
	SRL	A
	SRL	A
	SRL	A
	SRL	A
	ADD	A,30H
	DEC	HL
	LD	(HL),A		;write high nibble
	DEC	HL
	RET

CMDDAT	DB	'DATE 00/00/00'
ENDDAT	DB	0DH
CMDTIM	DB	'TIME 00:00:00'
ENDTIM	DB	0DH
TITLE	DB	'TRS-80 Emulator Clock Set Utility for LS-DOS 6.3+ Int. (DD/MM/YY)',0DH
NOSIM	DB	'No emulator found.',0DH
IDATE	DB	'Date DD/MM/YY ? ',03H
ITIME	DB	'Time HH:MM:SS ? ',03H


	END	START

