	INCLUDE "R800Time.asm"

name:
	db "INIR b=3$"

SETUP: MACRO
	ENDM

REFERENCE: MACRO
	ld hl,WRITEMEM
	ld c,00H
	ld b,3
	ENDM

TEST: MACRO
	ld hl,WRITEMEM
	ld c,00H
	ld b,3
	inir
	ENDM
