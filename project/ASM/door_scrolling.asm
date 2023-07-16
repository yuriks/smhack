asar 1.90
lorom

org $809803
	; Move start of door transition IRQ/DMA down 16 lines, to avoid
	; non-centered doors flickering during the transition.
	ldy.w #$00B0  ; Vanilla is A0h
