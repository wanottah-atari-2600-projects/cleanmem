
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; code revision 1
;; 2023.11.12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; set the processor type target for the assembly file
    processor 6502

    ; start a segment of code here
    seg code

    ; set the memory address location where the code will begin
    ; start of cartridge ROM
    org $F000

StartCartridge:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; basic housekeeping required at the beginning of program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; disable interrupts
    sei

    ; disable the BCD (binary coded decimal) math mode
    cld

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; initialise the SP (stack pointer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; load the x register with the hex value #$FF (decimal 255)
    ldx #$FF

    ; transfer the value of the x register to the stack pointer register
    txs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; program starts here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clear the page zero region ($00 to $FF)
;; $00 - $7F TIA registers
;; $80 - $FF RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; load the accumalator with the hex value #$0 (decimal 0)
    ; initialises the current memory location
    lda #$0
                            
    ; load the x register with the hex value #$FF (decimal 255)
    ; memory location offset
    ldx #$FF  

    ; store the value of the accumalator at memory address 
    ; $0 + the value of the x register
    sta $0,x                
                                      
ClearMemoryLoop:
                            
    ; subract 1 from the x register
    dex                     

    ; store the value of the accumalator at memory address 
    ; $0 + the value of the x register
    sta $0,x                

    ; if the x register is not equal to 0 (z-flag is not set)
    ; branch back to ClearMemoryLoop
    bne ClearMemoryLoop     
                                
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; program ends here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EndCartridge:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; basic housekeeping required at the end of program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fill the ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; set the memory address location for end of program housekeeping
    ; end of cartridge ROM
    org $FFFC

    ; reset vector
    ; add two bytes for the reset vector: $FFFC and $FFFD
    ; start address of program
    .word StartCartridge  
                            
    ; interrupt vector
    ; add another two bytes for the interrupt vector: $FFFE and $FFFF
    ; unused by the 2600
    .word StartCartridge    
                              