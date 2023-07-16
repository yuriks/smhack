asar 1.90
lorom

org $81B14B
	; Replaces bottom part of pause tilemap in the post-hexmap screen
	incbin "gfx/hexmap_controls_tilemap.tbl"

org $B6E000
	; Extended pause screen graphics. SMART seems able to somewhat work
	; just directly extending the pausemap.gfx file, but this is not
	; supported, so to be safe it's being included via asm.
	incbin "gfx/pausemap_extended.gfx"

org $E08000
	; Originally at B6E000
	; Address used in MapOverhaul asm
	incbin "gfx/pause_tilemap.tbl"
	incbin "gfx/equipment_tilemap.tbl"
