.segment "ZEROPAGE"
roadLine: .res 1
houseLine: .res 1
playerX: .res 1
playerY: .res 1

.segment "CODE"
DeliveryMsg:
    .byte "DELIVERED ", $00

.proc render_house_row
    lda houseLine
    beq bottom
    cmp #3
    bne middle
        PPU_SENDDATA #TILE_HOUSE_RIGHT_TOP
        PPU_SENDDATA #TILE_HOUSE_MIDDLE_TOP
        PPU_SENDDATA #TILE_HOUSE_MIDDLE_TOP
        PPU_SENDDATA #TILE_HOUSE_LEFT_TOP
        jmp end_house
    middle:
        PPU_SENDDATA #TILE_HOUSE_RIGHT_MIDDLE

        lda houseLine
        cmp #2
        bne bottom_middle
            PPU_SENDDATA #TILE_HOUSE_DIAGONAL_LEFT
            PPU_SENDDATA #TILE_HOUSE_DIAGONAL_RIGHT
            jmp end_middle

        bottom_middle:
            PPU_SENDDATA #TILE_HOUSE_DIAGONAL_RIGHT
            PPU_SENDDATA #TILE_HOUSE_DIAGONAL_LEFT

        end_middle:
            PPU_SENDDATA #TILE_HOUSE_LEFT_MIDDLE
        jmp end_house
    bottom:
        PPU_SENDDATA #TILE_HOUSE_RIGHT_BOTTOM
        PPU_SENDDATA #TILE_HOUSE_MIDDLE_BOTTOM
        PPU_SENDDATA #TILE_HOUSE_MIDDLE_BOTTOM
        PPU_SENDDATA #TILE_HOUSE_LEFT_BOTTOM
    end_house:
    rts
.endproc

.proc render_yard_row
    lda houseLine
    cmp #3
    bne grass
    RepeatTile TILE_FENCE, #$04
    jmp end_grass
grass:
    RepeatTile TILE_GRASS, #$04
end_grass:
    rts
.endproc

.proc render_footpath_row
    lda roadLine
    bne bottom
        PPU_SENDDATA #TILE_FOOTPATH_RIGHT_TOP
        PPU_SENDDATA #TILE_FOOTPATH_MIDDLE_TOP
        PPU_SENDDATA #TILE_FOOTPATH_LEFT_TOP
        jmp end_footpath
bottom:
        PPU_SENDDATA #TILE_FOOTPATH_RIGHT_BOTTOM
        PPU_SENDDATA #TILE_FOOTPATH_MIDDLE_BOTTOM 
        PPU_SENDDATA #TILE_FOOTPATH_LEFT_BOTTOM
end_footpath:
    rts
.endproc

.proc render_road_row
    PPU_SENDDATA #TILE_ROAD_SIDE_LEFT

    lda roadLine
    bne noline
        RepeatTile TILE_EMPTY, #$03
        PPU_SENDDATA #TILE_ROAD_LEFT
        PPU_SENDDATA #TILE_ROAD_RIGHT
        RepeatTile TILE_EMPTY, #$03

        jmp end_road 
noline:   
    RepeatTile TILE_EMPTY, #$08

end_road:
    PPU_SENDDATA #TILE_ROAD_SIDE_RIGHT
    rts
.endproc

.proc render_row
    dec roadLine
    dec houseLine

    jsr render_house_row
    jsr render_yard_row
    jsr render_footpath_row
    jsr render_road_row
    jsr render_footpath_row
    jsr render_yard_row
    jsr render_house_row

    lda roadLine
    bne skiproadline
        lda #02
        sta roadLine
    skiproadline:

    lda houseLine
    bne endline
        lda #04
        sta houseLine

endline:
    rts
.endproc

.proc set_attribute_row
    ;; House
    PPU_SENDDATA #%10101010
    
    ;; Yard
    PPU_SENDDATA #%11111111
    
    ;; Side walk
    PPU_SENDDATA #%00000000

    ;; Road
    PPU_SENDDATA #%11111111
    PPU_SENDDATA #%11111111

    ;; Side walk
    PPU_SENDDATA #%00000000
    
    ;; Yard
    PPU_SENDDATA #%11111111
    
    ;; House
    PPU_SENDDATA #%10101010

    rts
.endproc

.proc draw_player
    ldy 0
    lda playerX
    sta r1
    lda playerY
    sta r2
    lda #0
    sta r3
    lda #%00000000
    sta r4
    jsr WriteSprite

    lda playerX
    clc
    adc #8
    sta r1
    lda playerY
    sta r2
    lda #1
    sta r3
    jsr WriteSprite

    lda playerX
    sta r1
    lda playerY
    clc
    adc #8
    sta r2
    lda #$10
    sta r3
    jsr WriteSprite

    lda playerX
    clc 
    adc #8
    sta r1
    lda playerY
    clc
    adc #8
    sta r2
    lda #$11
    sta r3
    jsr WriteSprite

    lda playerX
    sta r1
    lda playerY
    clc
    adc #16
    sta r2
    lda #$20
    sta r3
    jsr WriteSprite

    lda playerX
    clc 
    adc #8
    sta r1
    lda playerY
    clc
    adc #16
    sta r2
    lda #$21
    sta r3
    jsr WriteSprite

    rts
.endproc

.proc init_game
    SetPointer nmi_game, nmiPtr
    SetPointer loop_game, mainLoopPtr
    resetOAMPtr
    
    jsr famistudio_music_stop

    jsr DisablePPU
    jsr ClearBackGround

    lda #100
    sta playerX
    lda #100
    sta playerY

    lda #4
    sta houseLine
    lda #1
    sta roadLine

    PPU_SETADDR PPU_NAMETABLE_0
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row

    PPU_SETADDR PPU_NAMETABLE_1
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row
    jsr render_row



    PPU_SETADDR $23C0
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row

    PPU_SETADDR $2BC0
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row
    jsr set_attribute_row

    jsr EnablePPU
    rts
.endproc

.proc loop_game
    jsr draw_player

    lda Buttons
    and #BUTTON_LEFT
    beq :+
        lda playerX
        sec
        sbc #1
        sta playerX
    :

    lda Buttons
    and #BUTTON_RIGHT
    beq :+
        lda playerX
        clc
        adc #1
        sta playerX
    :

    lda Buttons
    and #BUTTON_UP
    beq :+
        lda playerY
        sec
        sbc #1
        sta playerY
    :

    lda Buttons
    and #BUTTON_DOWN
    beq :+
        lda playerY
        clc
        adc #1
        sta playerY
    :

    jmp endMainLoop
.endproc

.proc nmi_game
    DMAOAM
    jmp endNMI
.endproc