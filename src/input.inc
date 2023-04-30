.segment "CODE"
.proc ReadControllers
    ldx #5
    stx $07
    ;Clear the buttons variable to 1 so it will carry at the end of our loop
    lda #1                   
    sta Buttons
    ; Set 1 to read from controller.
    sta JOYPAD1    

    ;; Set controller port back to 0 so we can read changes          
    lda #0                     
    sta JOYPAD1             
LoopButtons:
    ;; Pulling controller data 1 bit at a time from shift register.
    lda JOYPAD1
    lsr a 
    rol Buttons
    ;; First 1 we put into variable will carry when we get to the end.              
    bcc LoopButtons
    rts
.endproc