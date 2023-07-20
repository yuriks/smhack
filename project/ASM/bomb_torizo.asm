asar 1.90
lorom
dpbase 0
optimize dp always
optimize address ram

plmIds = $7E1C37
plmTimers = $7E1D77

org $84D33B
; Pre-instruction - wake PLM if Samus has bombs
sub_84D33B:
	jsr checkItemCollected
	nop : nop : nop
	bcc $13

; Free Space
org $84EFD3
; Params:
;   X - PLM index
; Returns:
;   Carry set if activated
checkItemCollected:
	lda plmIds-2,x  ; Check next PLM slot
	beq .activate
	clc
	rts

.activate:
	; Activate PLM in next-next slot
	inc plmTimers-4,x
	sec
	rts
