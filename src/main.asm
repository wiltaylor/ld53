.include "header.inc"
.include "gamemode.inc"
.include "consts.inc"
.include "nes.inc"
.include "input.inc"
.include "graphics.inc"
.include "mainscreen.inc"
.include "game.inc"

.segment "ZEROPAGE"
r1: .res 1
r2: .res 1
r3: .res 1
r4: .res 1

videoUpdated: .res 1
mainLoopPtr: .res 2
nmiPtr: .res 2

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

    ;;Setting up intro music
    ldx #<IntroMusic
    ldy #>IntroMusic
    lda #1 ; NTSC
    jsr famistudio_init

    jsr init_main_screen
    
MainLoop:
    jsr famistudio_update 
    jsr ReadControllers

    jmp (mainLoopPtr)

endMainLoop:
    waitForVBlank
    jmp MainLoop
NMI:   
    PUSH_REGS
    jmp (nmiPtr)

endNMI:
    setVblankFlag
    PULL_REGS
    rti

IRQ:
    rti 

PaletteData:
.byte $0F,$10,$2d,$27, $0F,$21,$11,$27, $0F,$26,$16,$27, $0F,$09,$30,$27 ; Background palette
.byte $0F,$16,$21,$10, $0F,$0F,$20,$27, $0F,$2D,$38,$18, $0F,$0F,$1A,$32 ; Sprite palette

IntroMusic:
    .include "song1.s"

.segment "CHARS"
.incbin "assets/tiles/main.chr"

.segment "VECTORS"
.word NMI
.word RESET
.word IRQ

