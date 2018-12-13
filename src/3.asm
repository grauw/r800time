	INCLUDE "R800Time.asm"

name:
	db "LDIR bc=3$"

SETUP: MACRO
	ENDM

REFERENCE: MACRO
	ld hl,READMEM
	ld de,WRITEMEM
	ld bc,3
	ENDM

TEST: MACRO
	ld hl,READMEM
	ld de,WRITEMEM
	ld bc,3
	ldir
	ENDM
