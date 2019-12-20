
; Program		: CLKTD6XE/CMD
; Version		:
; Date First Version	:
; Compiling Date & Time	:
; Listing Date & Time	: ___ __, ____  -  __:__
; Author		: GmEsoft
; Purpose		: Load Host Clock in Emulated System (Europe)
; System		: TRS-80 Model 4 + Keil Emulator Extensions
;			  TRSDOS 6.X
; Compiler		: MRAS


START:	LD	HL,TITLE
	LD	A,0AH
	RST	28H
	LD	HL,ENDTIM
	IN	A,(68H)
	CALL	WRITE2		;secs
	IN	A,(69H)
	CALL	WRITE2		;mins
	IN	A,(6AH)
	CALL	WRITE2		;hours
	LD	HL,CMDTIM
	LD	A,19H
	RST	28H		;exec 'TIME ../../..'
	LD	HL,ENDDAT
	IN	A,(6BH)
	AND	7
	OR	80H
	CALL	WRITE2		;year
	IN	A,(6DH)
	CALL	WRITE2		;day
	IN	A,(6CH)
	CALL	WRITE2		;month
	LD	HL,CMDDAT
	LD	A,18H
	RST	28H		;exit with exec 'DATE ../../..'

WRITE2:	LD	B,A
	AND	0FH
	ADD	A,30H
	DEC	HL
	LD	(HL),A
	LD	A,B
	SRL	A
	SRL	A
	SRL	A
	SRL	A
	ADD	A,30H
	DEC	HL
	LD	(HL),A
	DEC	HL
	RET

CMDDAT:	DB	'DATE 00/00/00'
ENDDAT:	DB	0DH

CMDTIM:	DB	'TIME 00:00:00'
ENDTIM:	DB	0DH

TITLE:	DB	'TRS-80 Emulator Clock Set Utility for TRSDOS 6.x (DD/MM/YY) - Clock set!'
	DB	0DH

	END	START
