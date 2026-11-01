org $8000
db	$55, $aa
dw	$00
dw	$00
dw	$00
dw	$00
dw	start

start:
;	Silence the SGM audio
	ld b, 3			; Loop counter (3 channels: A, B, and C)
	ld c, 8			; Start with Register 8 (Channel A Amplitude)
SgmLoop:
	ld a, c			; Move register index (8, 9, or 10) to Accumulator
	out ($50), a	; Send to SGM Address Port
	xor a			; Clear Accumulator (A = 0)
	out ($51), a	; Send 0 to SGM Data Port
	inc c			; Move to next register (9 = Chan B, 10 = Chan C)
	djnz SgmLoop	; Decrement B and loop if B > 0

; Silence the PSG audio
IinitPsgAudio:
	ld a, $9F		; Latch Channel 0, Volume Register, 0xF (Mute)
	out ($FF), a

	ld a, $BF		; Latch Channel 1, Volume Register, 0xF (Mute)
	out ($FF), a

	ld a, $DF		; Latch Channel 2, Volume Register, 0xF (Mute)
	out ($FF), a

	ld a, $FF		; Latch Channel 3 (Noise), Volume Register, 0xF (Mute)
	out ($FF), a
	
ResetVDP:
    ; -------------------------------------------------------------------------
    ; 1. Clear VDP Register 0 (Mode Bits)
    ;    Default: 0x00 (Configures structural Graphics I Mode)
    ; -------------------------------------------------------------------------
    ld	a, 0x00              ; Value to write
    out	($a1), a
    ld	a, 0x80              ; Bit 7 + Register 0
    out	($a1), a

    ; -------------------------------------------------------------------------
    ; 2. Clear VDP Register 1 (Blank Screen, Disable Interrupts, 8x8 Sprites)
    ;    Default: 0x00 
    ; -------------------------------------------------------------------------
    ld	a, 0x00              ; Value to write
    out	($a1), a
    ld	a, 0x81              ; Bit 7 + Register 1
    out	($a1), a

    ; -------------------------------------------------------------------------
    ; 3. Flush Internal 14-bit Address Latch & Status Flags
    ;    Reading the status port resets the internal multi-byte toggle phase
    ;    and clears the transient F, C, and 5S flags.
    ; -------------------------------------------------------------------------
    in	a, ($a1)
	
;	Move reset loop into 1k internal Coleco ram
    ld	hl, loop	; Load source address into HL
    ld	de, $6200	; Load destination address into DE
    ld	bc, 100		; Load number of bytes to copy into BC
    ldir			; Copy block of memory
	jp	$6200		; Execute reset loop
loop:
	ld	a,($8442)	; Is the cart finished loading?
	ld	b, 10		; Loop counter (3 channels: A, B, and C)
loop1:
	nop
	djnz loop1		; Decrement B and loop if B > 0
	cp	-1			; -1 = not done
	jr	z, loop		; Try again (wait until loaded)
	ld	a,($8443)	; Let the PiColeco know you are reseting
	ld	b, 100		; Loop counter (3 channels: A, B, and C)
loop2:
	nop
	djnz loop2		; Decrement B and loop if B > 0
	jp	0			; Reset (Execute form location zero like power-up

