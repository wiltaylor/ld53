.segment "CODE"
StartMsg:
    .byte "PRESS START", $00

.proc init_main_screen
    SetPointer nmi_main_screen, nmiPtr
    SetPointer loop_main_screen, mainLoopPtr

    ;; Play intro song
    lda #0
    jsr famistudio_music_play

    jsr ClearBackGround   
    jsr loadPalette  

    ;; Load intro press start text    
    PrintText $21CA, StartMsg

    jsr EnablePPU

    lda #0
    sta PPU_SCROLL           ; Disable scroll in X
    sta PPU_SCROLL           ; Disable scroll in Y

    rts
.endproc

.proc loop_main_screen 
    lda Buttons
    and #BUTTON_START
    beq :+
        jsr init_game
    :

    jmp endMainLoop
.endproc

.proc nmi_main_screen
    jmp endNMI
.endproc