.enum GAME_MODE 
    START_SCREEN = 0
    GAME = 1
    GAME_OVER = 2
.endenum

.macro setGameMode mode 
    ; Update game mode variable
    lda #mode
    sta gameMode

    ; Set game mode changed flag so game mode can handle any init code.
    lda #1
    sta gameModeChanged
.endmacro