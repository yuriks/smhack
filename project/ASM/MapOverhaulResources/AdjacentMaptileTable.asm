
;---------------------------------------------------------------------------------------------------
;|x|                                    ADJACENT MAPTILE TABLE                                   |x|
;---------------------------------------------------------------------------------------------------
{
;These 4 tables determine which maptiles have the special ability to revealed adjacent tiles in the current map
;when samus enters the position in which the maptile is located.
;One table represents a direction in which the adjacent maptile will be revealed.
;The values are sorted by the maptile ID in bits.
;Only one adjacent tile can be revealed per maptile.
;If you specify multiple directions for the same maptile, only the maptile with the direction of the highest priority is taken.
;Priority goes as followed: uncover tile above > uncover tile below > uncover tile left > uncover tile right.
ORG $90AB78
SetMaptileAboveTable:
	DB $00, $00, $00, $00, $00, $A5, $00, $00	;tile $00 - $3F | One byte represents 8 maptiles
	DB $00, $00, $00, $00, $00, $00, $00, $00	;tile $40 - $7F | The left bit (MSB) represents the first tile of the value (tile 0)
	DB $00, $00, $00, $00, $00, $00, $00, $00	;tile $80 - $BF | The right bit (LSB) represents the last tile of the 8 (tile 7)
	DB $00, $00, $00, $00, $00, $00, $00, $00	;tile $C0 - $FF

SetMaptileBelowTable:
	DB $00, $00, $00, $00, $00, $5A, $00, $00
	DB $00, $00, $00, $00, $00, $00, $00, $00
	DB $00, $00, $00, $00, $00, $00, $00, $00
	DB $00, $00, $00, $00, $00, $00, $00, $00

SetMaptileLeftSideTable:
	DB $00, $00, $00, $00, $00, $00, $00, $00
	DB $00, $00, $00, $00, $00, $00, $00, $00
	DB $00, $00, $00, $00, $00, $00, $00, $00
	DB $00, $00, $00, $00, $00, $00, $00, $00

SetMaptileRightSideTable:
	DB $00, $00, $00, $00, $00, $00, $00, $00
	DB $00, $00, $00, $00, $00, $00, $00, $00
	DB $00, $00, $00, $00, $00, $00, $00, $00
	DB $00, $00, $00, $00, $00, $00, $00, $00
}
