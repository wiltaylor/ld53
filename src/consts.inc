;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants for PPU registers mapped from addresses $2000 to $2007
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PPU_CTRL    = $2000
PPU_MASK    = $2001
PPU_STATUS  = $2002
OAM_ADDR    = $2003
OAM_DATA    = $2004
PPU_SCROLL  = $2005
PPU_ADDR    = $2006
PPU_DATA    = $2007
PPU_OAM_DMA = $4014

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Controller ports and buttons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
JOYPAD1       = $4016
JOYPAD2       = $4017

BUTTON_A      = $80          ; 10000000
BUTTON_B      = $40          ; 01000000
BUTTON_SELECT = $20          ; 00100000
BUTTON_START  = $10          ; 00010000
BUTTON_UP     = $08          ; 00001000
BUTTON_DOWN   = $04          ; 00000100
BUTTON_LEFT   = $02          ; 00000010
BUTTON_RIGHT  = $01          ; 00000001


; Sound related
APU_REGISTER      = $4000
APU_SQUARE1       = $4000
APU_SQUARE2       = $4004
APU_TRIANGLE      = $4008
APU_NOISE         = $400C
APU_DELTA         = $4010
APU_MASTERCTRL    = $4015
APU_FRAMECOUNTER  = $4017


;; PPU Memory Address Locations
PPU_BG_PALLETTES = $3F00
PPU_NAMETABLE_0  = $2000
PPU_NAMETABLE_1  = $2800



;; Tile Values
TILE_EMPTY = $FF
TILE_ROAD_LEFT = $FE 
TILE_ROAD_RIGHT = $FD
TILE_ROAD_SIDE_LEFT = $FC
TILE_ROAD_SIDE_RIGHT = $FB
TILE_GRASS = $E7

TILE_FOOTPATH_LEFT_TOP = $EA
TILE_FOOTPATH_LEFT_BOTTOM = $FA
TILE_FOOTPATH_RIGHT_TOP = $E9
TILE_FOOTPATH_RIGHT_BOTTOM = $F9
TILE_FOOTPATH_MIDDLE_TOP = $E8
TILE_FOOTPATH_MIDDLE_BOTTOM = $F8

TILE_HOUSE_LEFT_TOP = $D2
TILE_HOUSE_RIGHT_TOP = $D0
TILE_HOUSE_LEFT_BOTTOM = $F2
TILE_HOUSE_RIGHT_BOTTOM = $F0
TILE_HOUSE_LEFT_MIDDLE = $E2
TILE_HOUSE_RIGHT_MIDDLE = $E0
TILE_HOUSE_MIDDLE_TOP = $D1
TILE_HOUSE_MIDDLE_BOTTOM = $F1
TILE_HOUSE_MIDDLE = $E1
TILE_HOUSE_DIAGONAL_LEFT = $B0
TILE_HOUSE_DIAGONAL_RIGHT = $B1

TILE_FENCE = $C8