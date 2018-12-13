	INCLUDE "R800Time.asm"

name:
	db "LDIR bc=1$"

SETUP: MACRO
	ENDM

REFERENCE: MACRO
	ld hl,READMEM
	ld de,WRITEMEM
	ld bc,1
	ENDM

TEST: MACRO
	ld hl,READMEM
	ld de,WRITEMEM
	ld bc,1
	ldir
	ENDM
