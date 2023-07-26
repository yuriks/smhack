asar 1.90
lorom

; Fix "Morph Ball (Chozo)" PLM so it actually gives you morph instead of
; springball.
org $84E8CE
	dw $0004
