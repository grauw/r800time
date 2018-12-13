;
; R800 instruction speed test program
;
BDOS: equ 5H
_CONIN: equ 1H
_CONOUT: equ 2H
_STROUT: equ 9H
_CONST: equ 0BH
VDP_PORT_0: equ 98H
VDP_PORT_1: equ 99H
VDP_PORT_2: equ 9AH
VDP_PORT_3: equ 9BH
VDP_READ: equ 00000000B
VDP_WRITE: equ 01000000B
VDP_REGISTER: equ 10000000B
VDP_MIRROR_0: equ 0F3DFH
READMEM: equ 4000H
WRITEMEM: equ 8000H

ALIGN: MACRO ?boundary
	ds ?boundary - 1 - ($ + ?boundary - 1) % ?boundary
	ENDM

	org 100H

Main:
	ld de,instructions1
	ld c,_STROUT
	call BDOS
	ld de,name
	ld c,_STROUT
	call BDOS
	ld de,instructions2
	ld c,_STROUT
	call BDOS
	di
	;
	SETUP
	;
	ld a,(38H)
	ld (originalISR),a
	ld hl,(38H + 1)
	ld (originalISR + 1),hl
	ld a,0C3H
	ld (38H),a
	ld a,(VDP_MIRROR_0 + 0)
	and 11001111B
	or 00010000B
	out (VDP_PORT_1),a  ; enable IE1 (line ints)
	ld a,0 | VDP_REGISTER
	out (VDP_PORT_1),a
	ld a,(VDP_MIRROR_0 + 1)
	and 11011111B
	out (VDP_PORT_1),a  ; disable IE0 (vblank ints)
	ld a,1 | VDP_REGISTER
	out (VDP_PORT_1),a
	in a,(VDP_PORT_1)  ; clear vblank interrupt flag
	ld a,7 | 128
	out (VDP_PORT_1),a  ; indirect I/O to the colour register
	ld a,17 | VDP_REGISTER
	out (VDP_PORT_1),a
	ld a,64
	out (VDP_PORT_1),a  ; int on line 96
	ld a,19 | VDP_REGISTER
	out (VDP_PORT_1),a
	ld a,1
	out (VDP_PORT_1),a  ; status register 1
	ld a,15 | VDP_REGISTER
	out (VDP_PORT_1),a
	ld a,058H
	out (0AAH),a  ; select cursors / space keyboard matrix row
WaitLoop:
	call PrintTestStep
	call SetFirstInt
	halt
	call SetSecondInt
	halt
	di
	in a,(0A9H)
	cp 0FFH
	jr nz,KeyPressed
	xor a
	ld (keyCounter),a
	jr WaitLoop
KeyPressed:
	push af
	ld a,(keyCounter)
	inc a
	ld (keyCounter),a
	dec a
	and 3
	jr nz,PopAndNext
	ld a,(keyCounter)
	srl a
	srl a
	jr z,DoKey
	cp 4
	jr nc,DoKey
PopAndNext:
	pop af
	jr WaitLoop
DoKey:
	pop af
	bit 6,a
	jr z,Decrement1
	bit 5,a
	jr z,Increment1
	bit 4,a
	jr z,Decrement2
	bit 7,a
	jr z,Increment2
	bit 0,a
	jr z,Quit
	jr WaitLoop

Decrement1:
	ld a,(referenceStep)
	dec a
	and 7FH
	ld (referenceStep),a
	jr WaitLoop
Increment1:
	ld a,(referenceStep)
	inc a
	and 7FH
	ld (referenceStep),a
	jr WaitLoop
Decrement2:
	ld a,(testStep)
	dec a
	and 7FH
	ld (testStep),a
	jr WaitLoop
Increment2:
	ld a,(testStep)
	inc a
	and 7FH
	ld (testStep),a
	jr WaitLoop
Quit:
	ld a,(originalISR)
	ld (38H),a
	ld hl,(originalISR + 1)
	ld (38H + 1),hl
	ld a,(VDP_MIRROR_0 + 0)
	out (VDP_PORT_1),a  ; restore IE1 (line ints)
	ld a,0 | VDP_REGISTER
	out (VDP_PORT_1),a
	ld a,(VDP_MIRROR_0 + 1)
	out (VDP_PORT_1),a  ; restore IE0 (vblank ints)
	ld a,1 | VDP_REGISTER
	out (VDP_PORT_1),a
	ld a,0
	out (VDP_PORT_1),a  ; status register 0
	ld a,15 | VDP_REGISTER
	out (VDP_PORT_1),a
	ei
	halt
	halt
	halt
	halt
	ld c,_CONST
	call BDOS
	and a
	jp z,0
	ld c,_CONIN
	call BDOS
	jp 0

SetFirstInt:
	di
	ld a,32
	out (VDP_PORT_1),a  ; int on line 96
	ld a,19 | VDP_REGISTER
	out (VDP_PORT_1),a
	ld hl,FirstInterrupt
	ld (38H + 1),hl
	ei
	ret

SetSecondInt:
	di
	ld a,96
	out (VDP_PORT_1),a  ; int on line 96
	ld a,19 | VDP_REGISTER
	out (VDP_PORT_1),a
	ld hl,SecondInterrupt
	ld (38H + 1),hl
	ei
	ret

PrintTestStep:
	ld a,0
	out (VDP_PORT_1),a
	ld a,VDP_WRITE
	out (VDP_PORT_1),a
	ld a,(testStep)
	call PrintHexA
	ld a,"-"
	out (98H),a
	ld a,(referenceStep)
	call PrintHexA
	ld a,"="
	out (98H),a
	ld a,(referenceStep)
	ld b,a
	ld a,(testStep)
	sub b
	call PrintHexA
	ret

PrintHexA:
	push af
	srl a
	srl a
	srl a
	srl a
	cp 10
	ccf
	adc a,"0"
	daa
	out (98H),a
	pop af
	and 0FH
	cp 10
	ccf
	adc a,"0"
	daa
	out (98H),a
	ret

;
keyCounter:
	db 0
originalISR:
	ds 3
instructions1:
	db 12,"         cycles",13,10,"$"
instructions2:
	db 13,10,10,"Reference:",13,10,10,10,10,10,10
	db 13,10,10,"Test:",13,10,10,10,10,10,10
	db 13,10,"Match up the reference with the test."
	db 13,10,"- Up/down to adjust reference"
	db 13,10,"- Space to quit$"

;
	ALIGN 100H
FirstInterrupt:
	ld b,90
	djnz $
	ld a,32
FirstInterrupt_Loop:
	push af
	ld a,0F6H
	out (VDP_PORT_3),a
	jp Reference
FirstInterrupt_Return:
	ld b,82
	djnz $
	ld a,(VDP_MIRROR_0 + 7)
	out (VDP_PORT_3),a
	pop af
	dec a
	jp nz,FirstInterrupt_Loop
	in a,(VDP_PORT_1)  ; clear interrupt flag
	ei
	ret

;
	ALIGN 100H
Reference:
	jr $ + 2 + 40H
referenceStep: equ $ - 1
	REPT 127
	nop
	ENDM
	;
	REFERENCE
	;
	jp FirstInterrupt_Return

;
	ALIGN 100H
SecondInterrupt:
	ld b,90
	djnz $
	ld a,32
SecondInterrupt_Loop:
	push af
	ld a,0F6H
	out (VDP_PORT_3),a
	jp Test
SecondInterrupt_Return:
	ld b,82
	djnz $
	ld a,(VDP_MIRROR_0 + 7)
	out (VDP_PORT_3),a
	pop af
	dec a
	jp nz,SecondInterrupt_Loop
	in a,(VDP_PORT_1)  ; clear interrupt flag
	ei
	ret

;
	ALIGN 100H
Test:
	jr $ + 2 + 40H
testStep: equ $ - 1
	REPT 127
	nop
	ENDM
	;
	TEST
	;
	jp SecondInterrupt_Return
