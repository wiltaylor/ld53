.segment "HEADER"
.byte $4E,$45,$53,$1A  ; 4 bytes N E S \n
.byte $02 ; How many 16KB of prg we will use (=32KB)
.byte $01 ; How many 8k of char rom we will use
.byte %00000000  ; Hoz mirroring and no battery, mapper 0
.byte %00000000  ; mapper 0, playchoicem, iNes 2.0
.byte $00 ; No PRG-RAM
.byte $00 ; NTSC Format TV
.byte $00 ; No PRG-RAM
.byte $00,$00,$00,$00,$00 ; Unused padding to complete 16 bytes of header