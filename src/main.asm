;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The NES 2.0 header 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.segment "HEADER"
;.org $7FF0
;.byte $4E,$45,$53,$1A  ; 4 bytes N E S \n
;.byte $02 ; How many 16KB of prg we will use (=32KB)
;.byte $01 ; How many 8k of char rom we will use
;.byte %00000001  ; Vert mirroring and no battery, mapper 0
;.byte %00001000  ; mapper 0, ines 2.0 header and a regular nes.
;.byte %00000000  ; mapper 0 and no sub mapper
;.byte %00010010  ; $02 for prg-rom size and $01 for char rom size.
;.byte %00000000  ; 0 for prg-ram size
;.byte %00000000  ; 0 for prg-ram and eeprom size
;.byte %00000000  ; 0 for chr-ram and eeprom size
;.byte %00000000  ; NTSC NES timing mode.
;.byte %00000000  ; 0 for extended system types
;.byte $01 ; Regular nes controller attached

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

;; Endless loop
loop:
    jmp loop

NMI:
    rti

IRQ:
    rti 

.segment "VECTORS"
.word NMI
.word RESET
.word IRQ

