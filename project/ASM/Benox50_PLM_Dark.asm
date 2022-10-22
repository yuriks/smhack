lorom

!patch_ram = $FA00

;;;;;;;;;;;;;;;; HDMA asm by Benox50 ;;;;;;;;;;;;;;;;;

;;;;;; INFO:
;Add the PLM files for either Smile or Smart in their respective spot, follow folder architecture




;;; Darkness PLM Header
org $84F017
	DW #PLM_Dark_Init, #PLM_Dark_Inst


; FREE SPACE ; bank $84
org $84F030
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; This PLM let you darken the room in a smooth way when going deeper in it
;;;;;;;; Brightness Gradient PLM ;;;;;;;; Work with mostly any FX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Benox50
{
;; PLM settings, XX YZ ;;
; Height of PLM in room define when it starts to darken
; XX = Darkness bands size
; Y = Parallax divisor, 0 = follow cam not localised
; Z = How much darkness bands (cant more than F anyway)

PLM_Dark_Inst:
	;DW $874E : DB $04 ;Init timer
	;DW $86C1, #PLM_Dark_Pre ;Set run code
	DW $86B4 ;Sleep
PLM_Dark_Pre:
	;DEC $1D77,x : BNE +
	;STX $07E7 ;Save PLM index for HDMA to know (room asm ram)
	;JSR $86CA ;Clear run code
+
PLM_Dark_Init:
	STY $07E7 ;Save PLM index for HDMA to know (room asm ram)
	JSL HDMA_Dark_Init ;Spawn HDMA
	RTS
}





; FREE SPACE ; bank $88
org $88F800
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Brightness Gradient PLM ;;; Work with mostly any FX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; use room asm RAM: $07E7
{
HDMA_Dark_Init: ; <- Called by PLM Initiation
print " HDMA_Dark_Init : ", pc
	PHB : PHX : PHY
	JSR HDMA_Dark_TabSet
;Deactivate some stuff that create troubles, first water distorsion (make place for this HDMA too)
	LDA $196E : CMP #$0006 : BNE +
	LDA $197E : BIT #$0002 : BEQ +
	STZ $18B6 ;Normally where HDMA water BG2 distorsion is
+;;Launch HDMA
	JSL $888435 : DB $00,$00 : DW #HDMA_Dark_Inst ;Direct 1 reg writes once, brightness
	PLY : PLX : PLB
	RTL

HDMA_Dark_Inst:
	DW $8655 : DB $7F ;HDMA table is in this bank 
	DW $864C : DW $FA02 ;HDMA table is at this address
	DW $8570 : DL #HDMA_Dark_Pre ;Set HDMA run code
	DW $8682 ;Sleep


;;; Pre-Instruction
HDMA_Dark_Pre:
print " HDMA_Dark_Pre : ", pc
;; Setup
	REP #$30
	PHX : PHY
	LDX $07E7 : TXY ;Retreive gradient PLM index
	JSL $848290 ;Calculate PLM block co-ordinates
	LDA $1C2B : ASL #4 : STA $1C2B ;Conv PLM PosY to pixels
	LDA $1DC7,y : AND #$00F0 : BNE + ;;Decide if the gradient is localised in the room or if it follow the cam
;Follow the cam, get PLM pos in a screen only n invert that
	LDA $1C2B
	EOR #$FFFF : INC : AND #$00FF
	BRA HDMA_Dark_Pre3
+;Localised, Get how much we are inside the gradient
	LDA $0915 : ADC #$0100 ;Offset screen scroll to bottom
	SBC $1C2B : BPL HDMA_Dark_Pre2 ;Difference to PLM PosY, not reached does nothing
HDMA_Dark_Pre_End:
	PLY : PLX
	RTL
HDMA_Dark_Pre2:
;Reached, use difference to calculate how much gradient has scrolled
	STA $4204 ;Conv back to pixels as Dividend
	SEP #$30
	LDA $1DC7,y : AND #$F0 : LSR #4 : STA $4206 ;As Divisor
	REP #$30
	PHA : PLA : PHA : PLA ;Cyc waste :d
	LDA $4214
HDMA_Dark_Pre3:
	STA $16 ;Save our calculated scroll distance
	JSR HDMA_Dark_TabSet ;Reset setup table before we modify it
	LDA #$0070 : STA $18 ;We know top scanlines width
	TDC : TAX ;Init index
;; Scroll the gradient up to the proper distance, First reduce the top 2 HDMA scanlines
	INC : STA $1C ;1 of width is minimum for a HDMA scanline (why we call next routine alot, cause we cant stack more than 1 of width under HUD, will create a line)
	JSR HDMA_Dark_TabUp : BCS HDMA_Dark_Pre_End ;Scroll Top scanline 1
	LDA #$0052 : STA $18 ;Cause scanline is under HUD, we subtract by HUD width
	LDA #$001E : STA $1C ;Put this scanline at bottom of HUD (cause dont want dark HUD)
	TDC : INC : JSR HDMA_Dark_TabUp : BCS HDMA_Dark_Pre_End ;Scroll Top scanline 2
;Gradient must scroll past the top
	LDA $1DC8,y : AND #$00FF : STA $18 ;We know gradient bands width
	TDC : INC : STA $1C
	LDA #$0010 : JSR HDMA_Dark_TabUp
;;At end, darken the stacked HDMA entries under the HUD to fill the screen without cuts
	PEA $887F : PLB
	LDA $FA02,x : AND #$FF00 : STA $16 ;Last entry "cleared to 1 scanline", use its brightness value as target
	DEX #2 ;To skip first entry of HDMA tab (cause its the HUD width)
-;Loop all previous entries (which are above), set em to the target brightness value
	LDA $FA04,x : AND #$00FF : ORA $16 : STA $FA04,x
	DEX #2 : BNE -
	PLB : JMP HDMA_Dark_Pre_End



;;; Scroll/update HDMA table in RAM, [X] = table offset, [A] = How many entries to process
;Logic reduces the scanlines of HDMA entries (pushing the effect up) to a set target, once an entry reach target then it does the next, and that until distance is depleted
HDMA_Dark_TabUp:
print " HDMA_Dark_TabUp : ", pc
	PEA $887F : PLB
	STA $1A
	LDA $16
--; Loop each entries in table
	CMP $18 : BPL +++ ;Run out of scroll distance on this entry scanline count?
	LDA $FA02,x : BNE + ;Hit terminator? (Gradient reached max top)
-
	DEX #2 : BRA ++ ;When terminator, [X] to last entry instead of terminator
+
	SEC : SBC $16 : STA $FA02,x ;Then set this entry scanline count to remainder n finish
++
	PLB : SEC : RTS ;When exiting, [X] index to last affected entry
+++;Keep going
	LDA $FA02,x : BEQ - ;Hit terminator?
	AND #$FF00 : ORA $1C : STA $FA02,x ;"Clear" entry scanline count (move to screen top)
	LDA $16 : SEC : SBC $18 : INC : STA $16 ;Update scroll distance, also must include that off by 1 somewhere
	INX #2 : DEC $1A : BNE -- ;Loop next entry n check if we ran out of entries
	PLB : CLC : RTS


;;; Construct HDMA table in RAM
HDMA_Dark_TabSet:
	LDA $1DC7,y : AND #$000F : DEC : STA $1A ;Get num of darkness bands from PLM as max entries to loop
	LDA $1DC8,y : AND #$00FF : ORA #$0E00 ;Get darkness bands size from PLM + append full bright value, in [A] as our starter entry
	PEA $887F : PLB
	LDX #$0F70 : STX $FA02 : STX $FA04 ;Setup first 2 scanlines, position gradient just at bottom of screen
	LDX #$0000
;LOOP to setup the brightness gradient table, start from darkest to brightest
-	STA $FA06,x
	SEC : SBC #$0100 ;Remove 1 brightness in [A] while keeping set scanline count
	INX #2 : DEC $1A : BPL -
	STZ $FA06,x ;Write table terminator
	PLB : RTS
}
