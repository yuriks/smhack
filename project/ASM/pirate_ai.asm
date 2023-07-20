asar 1.90
lorom

; Makes ninja pirate vulnerability flash conditional to LN/golden pirates.

org $B2F53E
	; Y is saved before this (even though it's not clobbered by the
	; original function), so it's safe to use
	jsr palette_change_hijack
warnpc $B2F541

; Free Space
org $B2FEAA
; Inputs:
;   X - Enemy Index
;   A - Palette value to set
palette_change_hijack:
	ldy $0F78,x  ; Enemy IDs
	cpy #$F593  ; Lower Norfair Ninja Pirate id
	bne .return
	sta $0F96,x
.return:
	rts
