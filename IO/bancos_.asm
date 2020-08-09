
list        p=16f85a            ; micro PIC16F84A

; ------- Arquivos incluídos no projeto ----
#include    <p16f84a.inc>       ; inclui o danado

; ------- Fuse Bits -------
__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF & _BOREN_OFF & _LVP_OFF & CPD_OFF & MCLRE_ON

; ---- paginacoes
    #define     bank0   bcf     STATUS, RP0             ; cria mnemonico para o banco 0
    #degine     bank1   bsf     STATUS, RP0             ; cria mnemonico para banco 1

; ---- reset
    org     H'0000'
    goto    inicio                                      ; vai p lavel inicio

; ---- vetor de interrupcao
    org     H'0004'
    retfie                                              ; interrupcoes apontam para 0004


inicio: 
    bank0                                               ; mncon está no banco 0
    movlw       H'07'                                   ; 
    movwf       CMCON                                   ;

    end                                                 ; fim do programa