asar 1.90
lorom
dpbase 0
optimize dp always
optimize address ram

RAM0791 = $7E0791
RAM0911 = $7E0911
RAM0915 = $7E0915
RAM099C = $7E099C

sub_80A3AB = $80A3AB

org $82E310
; Rewrite vanilla door alignment routine. Uses exponential easing to align door
; instead of always moving 1 px per frame.
sub_82E310:
	PEA $8F00 : PLB : PLB  ; DB = $8F

	SEP #$10

	LDA RAM0791
	BIT #$0002
	BNE .vertical

	LDA RAM0915 : TAX
	BEQ .next
	JSR addAdjust
	STA RAM0915
	BRA .return

.vertical:
	LDA RAM0911 : TAX
	BEQ .next
	JSR addAdjust
	STA RAM0911
	BRA .return

.next:
	LDA #$E353
	STA RAM099C
.return:
	REP #$10
	JSL sub_80A3AB
	RTS

warnpc $82E353
padbyte $DB : pad $82E353


; Free Space
org $82F70F
; Params:
;   Call with x flag set
;   X - Lower byte of scroll coordinate
; Returns:
;   Adds adjustment directly to A register
addAdjust:
	CPX.b #$10
	BMI +
	; 2 + 3 cycles (1 + 3 bytes)
	CLC : ADC.w #-3
	RTS
+
	CPX.b #$08
	BMI +
	; 2 + 2 cycles (1 + 1 bytes)
	DEC #2
	RTS
+
	CPX.b #$0
	BMI +
	DEC
	RTS
+
	CPX.b #-$08
	BMI +
	INC
	RTS
+
	CPX.b #-$10
	BMI +
	INC #2
	RTS
+
	CLC : ADC.w #3
	RTS

