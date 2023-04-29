;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The NES 2.0 header 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "HEADER"
.org $7FF0
.byte $4E,$45,$53,$1A  ; 4 bytes N E S \n
.byte $02 ; How many 16KB of prg we will use (=32KB)
.byte $01 ; How many 8k of char rom we will use
.byte %00000001  ; Vert mirroring and no battery, mapper 0
.byte %00001000  ; mapper 0, ines 2.0 header and a regular nes.
.byte %00000000  ; mapper 0 and no sub mapper
.byte %00010010  ; $02 for prg-rom size and $01 for char rom size.
.byte %00000000  ; 0 for prg-ram size
.byte %00000000  ; 0 for prg-ram and eeprom size
.byte %00000000  ; 0 for chr-ram and eeprom size
.byte %00000000  ; NTSC NES timing mode.
.byte %00000000  ; 0 for extended system types
.byte $01 ; Regular nes controller attached

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRG-ROM code - located at $8000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "CODE"
.org $8000

RESET:
    ;; Disable interrupts
    sei

    ;; Set stack pointer
    cld
    ldx #$FF
    txs

    ;; Clear zero page
    ldx #0
    lda #0
MemClear:
    sta $0, x ; Clearing memory at offset x
    dex
    bne MemClear

NMI:
    rti

IRQ:
    rti 

.segment "VECTORS"
.org $FFFA
.word NMI
.word RESET
.word IRQ

