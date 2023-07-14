asar 1.90
lorom
dpbase 0
optimize dp always
optimize address ram

bg1_xpos = $7E0911
bg1_ypos = $7E0915
bg3_xpos = $7ECADC
bg3_ypos = $7ECADE

fx_yoff = $7E1914
fx_xoff = $7E1920
fx_xspeed = $7E1938

org $88D992
    dw -$0A00, $0A00, -$0700, $0700

; Set vertical speed of  FX $08 (Rain) to -1 instead of -4 so it's more horizontal and sand-like
org $88D9B3
    LDA fx_yoff,X
    CLC : ADC #$FF00
    STA fx_yoff,X

    XBA
    AND #$00FF
    ;CLC : ADC bg1_ypos
    STA bg3_ypos

    LDA fx_xoff,X
    CLC : ADC fx_xspeed,X
    STA fx_xoff,X

    XBA
    AND #$00FF
    ;CLC : ADC bg1_xpos
    STA bg3_xpos

    PLB
    RTL
warnpc $88DA11

