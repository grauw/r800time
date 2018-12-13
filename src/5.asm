	INCLUDE "R800Time.asm"

name:
	db "CPIR bc=3$"

SETUP: MACRO
	ld hl,READMEM
	ld de,READMEM + 1
	ld bc,255
	ld (hl),0
	ldir
	ENDM

REFERENCE: MACRO
	ld a,1
	ld hl,READMEM
	ld bc,3
	ENDM

TEST: MACRO
	ld a,1
	ld hl,READMEM
	ld bc,3
	cpir
	ENDM
