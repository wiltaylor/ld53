.segment "ZEROPAGE"
textPointer: .res 2
SprPtr:         .res 2

.segment "CODE"
.proc loadPalette
    ;;Loading pallette into memory
    PPU_SETADDR $3F00
    ldy #0
:    
    lda PaletteData,y
    sta PPU_DATA
    iny
    cpy #32
    bne :-
    rts
.endproc

.proc DisablePPU
    ;; Disable PPU Rendering
    lda #%00000000
    sta PPU_CTRL
    sta PPU_MASK
    rts
.endproc

.proc EnablePPU
    ;; Enable PPU Rendering again
    lda #%10001000
    sta PPU_CTRL
    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    lda #%00011110
    sta PPU_MASK
    rts
.endproc

.proc ClearBackGround
    PPU_SETADDR PPU_NAMETABLE_0

    ldx #0
    ldy #0
OuterLoop:
InnerLoop:
    lda #$ff
    sta PPU_DATA
    inx
    cpx #32
    bne InnerLoop
    iny
    cpy #30
    bne OuterLoop
    rts
.endproc

.macro setVblankFlag
    lda #1
    sta videoUpdated
.endmacro

.macro waitForVBlank
:
    lda videoUpdated
    beq :-

    ;Clear flag for next frame
    lda #0
    sta videoUpdated
.endmacro

.macro RepeatTile tile, qty
    ldx qty 
:   PPU_SENDDATA #tile
    dex
    cpx #0
    bne :-
.endmacro

.macro SelectAttributeEntry tbl, xpos, ypos
    attr_tile = ypos * 8 + xpos

    if tbl == 0
        PPU_SETADDR attr_tile + $23C0
    else
        PPU_SETADDR attr_tile + $27C0
    endif
.endmacro

.macro PrintText videopos, addr
    PPU_SETADDR videopos
    ldy #0;
loop:
    lda addr,y
    beq exit
    cmp #32 ; ascii space
    beq space
    SEC
    SBC #65  ; Subtracting position in ascii table plus numbers
    sta PPU_DATA
nextchar:
    iny
    jmp loop

space:
    lda #$ff
    sta PPU_DATA
    jmp nextchar

exit:    
.endmacro

.macro DMAOAM
    lda #$02
    sta PPU_OAM_DMA      
.endmacro

.macro resetOAMPtr
    lda #$02
    sta SprPtr+1
    lda #$00
    sta SprPtr
.endmacro

.proc WriteSprite
    lda r2  ;; Y
    sta (SprPtr),y
    iny 
    lda r3  ;; Tile
    sta (SprPtr),y
    iny 
    lda r4  ;; Attributes
    sta (SprPtr),y
    iny 
    lda r1
    sta (SprPtr),y
    iny
.endproc