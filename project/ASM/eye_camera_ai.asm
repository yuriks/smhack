asar 1.90
lorom

; Vanilla eye states:
; $90F1 - AI State: Waiting for Samus
; $912E - AI State: Acquired Samus, opening eye (20 frame timeout in $0FB0) -> $9160
; $9160 - AI State: Tracking Samus (updates facing position using angle) -> $91CE
; $91CE - AI State: Losing track of Samus (20 frame timeout in $0FB0) -> $90F1

org $A89140
	; Hook into "Samus is nearby" codepath
	; original: A9 60 91  LDA #$9160
	jsr acquired_hijack
warnpc $A89143

org $A891A2
	; Hook into "Update sprite angle" codepath
	; original AD F6 0A  LDA $0AF6
	brl update_hijack
update_hijack_original_return:
warnpc $A891A5
update_hijack_dormant_return = $A89174

org $A891D5
	jsr dormant_hijack
warnpc $A891D8

; Free Space
org $A8F9BE
; Inputs:
;   X - Enemy Index
acquired_hijack:
	; Initialize counter
	lda.w #240
	sta $0FB0,x

	; Hooked instruction
	lda #$9160
	rts


update_hijack:
	dec $0FB0,x
	bne .return

.go_dormant:
	lda.w #1
	sta $0FAA,x  ; Set "activated" flag
	brl update_hijack_dormant_return

.return:
	; Hooked instruction
	lda $0AF6
	brl update_hijack_original_return


dormant_hijack:
	lda $0FAA,x  ; Check if eye was "activated"
	beq .not_activated

	lda $0FB4,x  ; Parameter 1
	xba : and #$00FF
	beq .no_plms
	sta $00

	lda.w #40  ; Last PLM's index
	sec : sbc $00
	asl

	phx : tax
	lda #$FFFF
	sta $1E6D  ; Trigger tourian grey door

.next_plm:
	sta $1D77,x  ; Trigger gate PLMs
	inx #2 : cpx #$0050 : bne .next_plm

	plx

.no_plms
	lda #$91DC  ; RTL stub
	rts

.not_activated:
	; Hooked instruction
	lda #$90F1
	rts
