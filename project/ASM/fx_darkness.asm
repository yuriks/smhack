asar 1.90
lorom
optimize address ram

org $83AC18+$E
dw fx_darkness ; FX type $E

org $8880B2
    ; Color Math register value for blending config $0C
    ; Originally $A2, this additionally enables CM for BG1 and OBJ
    LDA #$B3

org $88EE32 ; Free space

; Current FX Y position, used as pointer to color table
fx_ypos = $7E1962
fx_timer = $7E1980

; FX type $E - Animated Darkness
; Code based on FX type $24: firefleas
fx_darkness:
    PHP
    REP #$30

    ; Create empty HDMA table (first entry is 00)
    LDA #$0000
    STA $7E9E00

    ; Spawns an HDMA object. This uses an empty table so it's only used for the pre-instruction
    JSL $888435 ; Spawn HDMA object
    db $00 ; Direct 8-bit write
    db $00 ; Unused
    dw .hdma_instructions

    ; Load initial table from "Liquid" settings
    LDX $1978 ; FX Y position (surfacestart in SMART)
    LDA.l .patterns_list,X ; This code is run with DB=$83 so need to use .l here
    STA fx_ypos
    LDA #$0001
    STA fx_timer

    PLP
    RTL

.hdma_instructions:
    dw $8655 : db $7E ; HDMA table bank = $7E
    dw $8570 : dl .pre_instruction ; Set pre-instruction
-   dw $0001, $9E00 ; HDMA table addr = $7E:9E00
    dw $85EC, - ; Loop

.pre_instruction:
    PHP
    REP #$30

    ; TODO Overwrite layer blending config?
    ; Set layer blending config to $0C
    LDA $1986
    AND #$FF00
    ORA #$000C
    STA $1986

    DEC fx_timer
    BNE .ret ; Wait until timer is 0

    PHX
    LDX fx_ypos ; Load current table ptr

.load_table_line:
    ; Read timer byte
    LDA $0000,X
    INX
    AND #$00FF
    BNE +
    ; Timer $00 = goto
    LDA $0000,X
    TAX
    BRA .load_table_line

+   STA fx_timer
    LDA $0000,X
    STA $74 ; Value 1/2 for colormath color
    LDA $0001,X
    STA $75 ; Value 2/3 for colormath color
    INX #3

    STX fx_ypos
    PLX
.ret:
    PLP
    RTL

.patterns_list:
    dw .table1 ; $00

macro tbl_color(delay, r, g, b)
    db <delay>, <r>|$20, <g>|$40, <b>|$80
endmacro

macro tbl_gray(delay, i)
    %tbl_color(<delay>, <i>, <i>, <i>)
endmacro

macro tbl_goto(target)
    db $00
    dw <target>
endmacro

.table1:
    %tbl_gray(15, $00)
    %tbl_gray(15, $01)
    %tbl_gray(15, $02)
    %tbl_gray(15, $03)
    %tbl_gray(20, $04)
    %tbl_gray(10, $03)
    %tbl_gray(10, $02)
    %tbl_gray(10, $01)
    %tbl_goto(.table1)
