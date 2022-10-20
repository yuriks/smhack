asar 1.90
lorom

!FREE_SPACE = $8BF760

; End of "Ship fly-in" cinematic before Ceres
org $8BBE5F
    ; Skip directly to "Flying towards Zebes" cinematic
    LDA #$C699 ; Was $BFDA

org $8BCAFE
    ; Set "reload gamestate"
    LDA #$0022 ; Escaped Ceres
    JMP hijack
warnpc $8BCB05
org !FREE_SPACE
hijack:
    STA $7ED914
    ; Save current slot to SRAM
    LDA $0952
    JSL $818000
    RTS
