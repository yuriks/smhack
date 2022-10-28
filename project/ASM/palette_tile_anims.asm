asar 1.90
lorom
optimize address ram

org $83AC46

;;; $AC46: Area specific palette FX object list pointers ;;;
dw area0_pals, area1_pals, area2_pals, area3_pals, area4_pals, area5_pals, area6_pals, area7_pals
;;; $AC56: Area specific animated tiles object list pointers ;;;
dw area0_tile, area1_tile, area2_tile, area3_tile, area4_tile, area5_tile, area6_tile, area7_tile

;;; $AC66: Area specific palette FX and animated tiles object lists ;;;

; Palette FX are offset into bank $8D:
; $8D:F745 - Nothing
; $8D:F749 - Grey out Tourian statue - Draygon
; $8D:F74D - Grey out Tourian statue - Kraid
; $8D:F751 - Grey out Tourian statue - Ridley
; $8D:F755 - Grey out Tourian statue - Phantoon
; $8D:F759 
; $8D:F75D 
; $8D:F761 - Norfair 1 / Tourian 1
; $8D:F765 - Crateria 1 - lightning
; $8D:F769 
; $8D:F76D - Wrecked Ship 1 - green lights
; $8D:F771 
; $8D:F775 - Brinstar 1 - blue background spores
; $8D:F779 - Brinstar 8 - Spore Spawn blue background spores
; $8D:F77D - Brinstar 2 - red background glow
; $8D:F781 - Crateria 80h / Brinstar 4 - beacon flashing
; $8D:F785 - Norfair 2
; $8D:F789 - Norfair 4
; $8D:F78D - Norfair 8
; $8D:F791 - Norfair 10h
; $8D:F795 - Maridia 1 - sand pits
; $8D:F799 - Maridia 2 - sand falls
; $8D:F79D - Maridia 4 - background waterfalls
; $8D:F7A1 - Tourian 2 - glowing arkanoid blocks and red orbs
; $8D:F7A5 - Tourian 4 - unused clone of Tourian 2

; $8D:FFC9 - Tourian 8 - shutter red flashing
; $8D:FFCD - Tourian 10h - background red flashing
; $8D:FFD1 - Tourian 20h - general level red flashing
; $8D:FFD5 - Tourian 40h - red flashing arkanoid blocks and red orbs
; $8D:FFD9 - Crateria 8 - old Tourian red flashing
; $8D:FFDD - Crateria 10h - old Tourian background railings flash orange
; $8D:FFE1 - Crateria 20h - old Tourian background panels flash yellow
; $8D:FFE5 - Crateria 2 - upper Crateria red flashing
; $8D:FFE9 - Crateria 4 - yellow lightning
; $8D:FFED - Crateria 40h - slightly modifies an unnoticeable pixel in a CRE block


; Animated tiles are offsets into bank $87:
; $87:824B - Nothing
; $87:8251 - Vertical spikes
; $87:8257 - Horizontal spikes
; $87:825D - Crateria lake
; $87:8263 - Unused: Crateria lava
; $87:8269 - Unused: Crateria lava
; $87:826F - Wrecked Ship screen
; $87:8275 - Wrecked Ship treadmill (rightwards)
; $87:827B - Wrecked Ship treadmill (leftwards)
; $87:8281 - Brinstar mouth
; $87:8287 - Maridia sand ceiling
; $87:828D - Maridia sand falling


; Crateria
area0_pals: dw $F76D, ws_glow_purple_dark, $F745, $F745, $F745, $F745, $F745, $F745 ; Palette FX
area0_tile: dw $8257, $8251, $825D, $8263, $824B, $824B, $824B, $824B ; Animated tiles

; Brinstar
area1_pals: dw $F745, $F745, $F745, $F745, $F745, $F745, $F745, $F745 ; Palette FX
area1_tile: dw $8257, $8251, $8281, $824B, $824B, $824B, $824B, $824B ; Animated tiles

; Norfair
area2_pals: dw $F745, $F745, $F745, $F745, $F745, $F745, $F745, $F745 ; Palette FX
area2_tile: dw $8257, $8251, $824B, $824B, $824B, $824B, $824B, $824B ; Animated tiles

; Wrecked Ship
area3_pals: dw $F745, $F745, $F745, $F745, $F745, $F745, $F745, $F745 ; Palette FX
area3_tile: dw $8257, $8251, $8275, $827B, $826F, $824B, $824B, $824B ; Animated tiles

; Maridia
area4_pals: dw $F745, $F745, $F745, $F745, $F745, $F745, $F745, $F745 ; Palette FX
area4_tile: dw $8257, $8251, $8287, $828D, $824B, $824B, $824B, $824B ; Animated tiles

; Tourian
area5_pals: dw $F745, $F745, $F745, $F745, $F745, $F745, $F745, $F745 ; Palette FX
area5_tile: dw $8257, $8251, $824B, $824B, $824B, $824B, $824B, $824B ; Animated tiles

; Ceres
area6_pals: dw $F745, $F745, $F745, $F745, $F745, $F745, $F745, $F745 ; Palette FX
area6_tile: dw $8257, $8251, $824B, $824B, $824B, $824B, $824B, $824B ; Animated tiles

; Debug
area7_pals: dw $F745, $F745, $F745, $F745, $F745, $F745, $F745, $F745 ; Palette FX
area7_tile: dw $8257, $8251, $824B, $824B, $824B, $824B, $824B, $824B ; Animated tiles


macro color_step(timer, ...)
    dw <timer>
    !i #= 0
    while !i < sizeof(...)
        dw <...[!i]>
        !i #= !i+1
    endwhile
    dw $C595 ; Sleep object
endmacro

org $8DEAE2
;;; $EAE2: Instruction list - palette FX object $F76D/$F771 (Wrecked Ship 1) ;;;
; Green lights (BG1/2 palette 4 colours Ch..Dh)
; Used by most Wrecked Ship rooms in powered on state
dw $C655, $0098  ; Palette FX object colour index = 98h
%color_step(15, $70FB, $7A7D)
%color_step(15, $6CFA, $765C)
%color_step(15, $68D9, $723B)
%color_step(15, $60B7, $6A39)
%color_step(20, $5CB6, $6618) ; low point
%color_step(10, $60B7, $6A39)
%color_step(10, $68D9, $723B)
%color_step(10, $6CFA, $765C)
dw $C61E,$EAE6   ; Go to $EAE6
warnpc $8DEB2A

; Overwrites all the escape-related Palette FX. Oh well.
org $8DF7A9

; Wrecked Ship tileset - Purple glow (Dark Room version)
ws_glow_purple_dark:
    dw $C685, .instrs

; Adjusts the color step to counter subtraction in color math
; Adjustments and timings must match table1 in fx_darkness.asm
function adjust(c, i) = (c+(i|i<<5|i<<10))
macro adjust_step(timer, c1, c2, i)
    %color_step(<timer>, adjust(<c1>, <i>), adjust(<c2>, <i>))
endmacro

.instrs:
    dw $C655, $0098  ; Palette FX object colour index = 98h
    %adjust_step(15, $70FB, $7A7D, 0)
    %adjust_step(15, $6CFA, $765C, 1)
    %adjust_step(15, $68D9, $723B, 2)
    %adjust_step(15, $60B7, $6A39, 3)
    %adjust_step(20, $5CB6, $6618, 4) ; low point
    %adjust_step(10, $60B7, $6A39, 3)
    %adjust_step(10, $68D9, $723B, 2)
    %adjust_step(10, $6CFA, $765C, 1)
    dw $C61E, .instrs ; Loop
