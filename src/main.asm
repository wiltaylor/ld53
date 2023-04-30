.include "header.inc"
.include "gamemode.inc"
.include "consts.inc"
.include "nes.inc"

.segment "ZEROPAGE"
Buttons: .res 1
PrevButtons:    .res 1
gameMode: .res 1
gameModeChanged: .res 1
videoUpdated: .res 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRG-ROM code - located at $8000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "CODE"

; FamiStudio config.
FAMISTUDIO_CFG_EXTERNAL       = 1
FAMISTUDIO_CFG_DPCM_SUPPORT   = 1
FAMISTUDIO_CFG_SFX_SUPPORT    = 1 
FAMISTUDIO_CFG_SFX_STREAMS    = 2
FAMISTUDIO_CFG_EQUALIZER      = 1
FAMISTUDIO_USE_VOLUME_TRACK   = 0
FAMISTUDIO_USE_PITCH_TRACK    = 1
FAMISTUDIO_USE_SLIDE_NOTES    = 1
FAMISTUDIO_USE_VIBRATO        = 1
FAMISTUDIO_USE_ARPEGGIO       = 1
FAMISTUDIO_CFG_SMOOTH_VIBRATO = 1
FAMISTUDIO_USE_RELEASE_NOTES  = 1
FAMISTUDIO_DPCM_OFF           = $e000

.define FAMISTUDIO_CA65_ZP_SEGMENT   ZEROPAGE
.define FAMISTUDIO_CA65_RAM_SEGMENT  BSS
.define FAMISTUDIO_CA65_CODE_SEGMENT CODE

.include "audioengine.inc"

RESET: 
    INIT_NES

    setGameMode GAME_MODE::START_SCREEN

    ldx #<IntroMusic
    ldy #>IntroMusic
    lda #1 ; NTSC

    jsr famistudio_init

    lda #0
    jsr famistudio_music_play
    
    jsr ClearBackGround   
    jsr loadPalette  

    jsr LoadText

    jsr EnablePPU

lda #0
sta PPU_SCROLL           ; Disable scroll in X
sta PPU_SCROLL           ; Disable scroll in Y

MainLoop:
    jsr famistudio_update 
    jsr ReadControllers

    lda Buttons
    and #BUTTON_START
    beq :+
        jsr famistudio_music_stop
        setGameMode GAME_MODE::GAME_OVER
:

waitForVBlank:
    lda videoUpdated
    beq waitForVBlank
    lda #0
    sta videoUpdated

    jmp MainLoop          ; Force an infinite execution loop

NMI:   
    PUSH_REGS

    lda #1
    sta videoUpdated

    PULL_REGS
    rti

IRQ:
    rti 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Routine to read controller state and store it inside "Buttons" in RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.proc ReadControllers
    lda #1                   ; A = 1
    sta Buttons              ; Buttons = 1
    sta JOYPAD1              ; Set Latch=1 to begin 'Input'/collection mode
    lsr                      ; A = 0
    sta JOYPAD1              ; Set Latch=0 to begin 'Output' mode
LoopButtons:
    lda JOYPAD1              ; This reads a bit from the controller data line and inverts its value,
                             ; And also sends a signal to the Clock line to shift the bits
    lsr                      ; We shift-right to place that 1-bit we just read into the Carry flag
    rol Buttons              ; Rotate bits left, placing the Carry value into the 1st bit of 'Buttons' in RAM
    bcc LoopButtons          ; Loop until Carry is set (from that initial 1 we loaded inside Buttons)
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

.proc EnablePPU
    ;; Enable PPU Rendering again
    lda #%10000000
    sta PPU_CTRL
    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    lda #%00011110
    sta PPU_MASK
    rts
.endproc

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Subroutine to load text in the nametable until it finds a 0-terminator
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.proc LoadText
    PPU_SETADDR $21CA
    ldy #0;
loop:
    lda StartMsg,y
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
    
    rts                      ; Return from subroutine
.endproc

PaletteData:
.byte $0F,$10,$2d,$27, $0F,$21,$11,$27, $0F,$37,$3D,$27, $0F,$0F,$3D,$27 ; Background palette
.byte $0F,$0F,$2D,$10, $0F,$0F,$20,$27, $0F,$2D,$38,$18, $0F,$0F,$1A,$32 ; Sprite palette

StartMsg:
    .byte "PRESS START", $00

IntroMusic:
    .include "song1.s"

.segment "CHARS"
.incbin "assets/tiles/main.chr"

.segment "VECTORS"
.word NMI
.word RESET
.word IRQ

