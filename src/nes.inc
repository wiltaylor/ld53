;; Get NES into a good known state.
.macro INIT_NES
    ;; Disable interupts
    sei
    ;; disable decimal mode (not supported by NES CPU)
    cld

    ;; Set stack pointer to FF
    ldx #$FF
    txs

    ;; Clear x to zero and disable Rendering
    inx                      
    stx PPU_CTRL             
    stx PPU_MASK             

    ;; Disable APU from trigginer IRQ
    stx APU_DELTA                
    lda #$40
    sta APU_FRAMECOUNTER

    ;; Wait for first vblank. 
    ;; We need to do at least 2 before real hardware becomes stable.
    bit PPU_STATUS
Wait1stVBlank:
    bit PPU_STATUS
    bpl Wait1stVBlank

    txa

;; Zero out ram in all BSS pages.
;; This will also kill a heap of time before the nes becomes ready.
ClearRAM:
    sta $0000,x 
    sta $0100,x 

    lda #$FF
    sta $0200,x

    lda #0
    sta $0300,x
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne ClearRAM

;; Now wait for 2nd vblank when the system is ready.
Wait2ndVBlank: 
    bit PPU_STATUS
    bpl Wait2ndVBlank
.endmacro

.macro PPU_SETADDR addr
    bit PPU_STATUS
    lda #>addr
    sta PPU_ADDR
    lda #<addr
    sta PPU_ADDR
.endmacro

.macro PPU_SENDDATA data
    lda data 
    sta PPU_DATA
.endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macro to push and preserv registers A, X, Y, and status flags on the Stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.macro PUSH_REGS
    pha                      ; Push A to the stack
    txa
    pha                      ; Push X to the stack
    tya
    pha                      ; Push Y to the stack
    php                      ; Push Processor Status flags to the stack
.endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macro to pull and restore registers A,X,Y, and status flags from the Stack.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.macro PULL_REGS
    plp                      ; Restore the the status flags from the stack
    pla                      ; Restore the old value of X from the stack
    tay
    pla                      ; Restore the old value of X from the stack
    tax
    pla                      ; Pull A from the stack
.endmacro
