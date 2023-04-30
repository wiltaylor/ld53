;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The iNES header (contains total of 16 bytes with flags at $7FF0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "HEADER"
.org $7FF0
.byte $4E,$45,$53,$1A  ; 4 bytes N E S \n
.byte $02 ; How many 16KB of prg we will use (=32KB)
.byte $01 ; How many 8k of char rom we will use
.byte %00000000  ; Hoz mirroring and no battery, mapper 0
.byte %00000000  ; mapper 0, playchoicem, iNes 2.0
.byte $00 ; No PRG-RAM
.byte $00 ; NTSC Format TV
.byte $00 ; No PRG-RAM
.byte $00,$00,$00,$00,$00 ; Unused padding to complete 16 bytes of header

.enum GAME_MODE 
    START_SCREEN = 0
    GAME = 1
    GAME_OVER = 2
.endenum

.include "consts.inc"
.include "nes.inc"

.segment "ZEROPAGE"
textPtr: .res 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRG-ROM code - located at $8000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "CODE"

; FamiStudio config.
;FAMISTUDIO_CFG_EXTERNAL       = 1
;FAMISTUDIO_CFG_DPCM_SUPPORT   = 1
;FAMISTUDIO_CFG_SFX_SUPPORT    = 1 
;FAMISTUDIO_CFG_SFX_STREAMS    = 2
;FAMISTUDIO_CFG_EQUALIZER      = 1
;FAMISTUDIO_USE_VOLUME_TRACK   = 1
;FAMISTUDIO_USE_PITCH_TRACK    = 1
;FAMISTUDIO_USE_SLIDE_NOTES    = 1
;FAMISTUDIO_USE_VIBRATO        = 1
;FAMISTUDIO_USE_ARPEGGIO       = 1
;FAMISTUDIO_CFG_SMOOTH_VIBRATO = 1
;FAMISTUDIO_USE_RELEASE_NOTES  = 1
;FAMISTUDIO_DPCM_OFF           = $e000

;.define FAMISTUDIO_CA65_ZP_SEGMENT   ZEROPAGE
;.define FAMISTUDIO_CA65_RAM_SEGMENT  BSS
;.define FAMISTUDIO_CA65_CODE_SEGMENT CODE

;.include "audioengine.inc"

.org $8000
RESET:
    INIT_NES
    
    jsr ClearBackGround   
    jsr loadPalette  

    jsr LoadText

    jsr EnablePPU

lda #0
sta PPU_SCROLL           ; Disable scroll in X
sta PPU_SCROLL           ; Disable scroll in Y

LoopForever:
ldy #0
ldx #0
lda #0
    jmp LoopForever          ; Force an infinite execution loop

NMI:
    rti

IRQ:
    rti 

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

.segment "CHARS"
.incbin "assets/tiles/main.chr"

.segment "VECTORS"
.word NMI
.word RESET
.word IRQ

