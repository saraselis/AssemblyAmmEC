
list        p=16f85a            ; micro PIC16F84A

; ------- Arquivos incluídos no projeto ----
#include    <p16f84a.inc>       ; inclui o danado

; ------- Fuse Bits -------
__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF

; ------- Paginacao de memoria (troca dos bancos de memoria) ------
#define     bank0       bcf STATUS, RP0     ; cria mnemonio p o banco 0, zerando o rp0
#define     bank1       bsf STATUS, RP0     ; cria mnemonico para o banco 1, setando o rp0
; banco 1 = 80h-ffh
; banco 0 = 00h-7fh

; ------- Entradas -------
#define     botao1      PORTB, RB0          ; botao1 ligado em RB0

; ------- Saidas -------
#define     led1        PORTB, RB7          ; led1 ligado em rb7   

; ------- Vetor de REset -------
            org         H'0000'             ; Origem no endereçõ 00000hd e memoria
            goto        inicio              ; Desvia do vetor de interrupcao

; ------- Vetor de interrupcao -------
            org         H'0004'             ; Todas as interrupcoes apontam p ca
            retfie                          ; retorna de uma interrupcao

; ------- Programca principal
inicio:
            bank1                           ; seleciona o banco 1 de mem
            movlw       H'7F'               ; W = B'01111111' apenas o rb7 é saida, representado pelo bit setado em 0
            movwf       TRISB               ; TRISB = 7f
            bank0                           ; FIM, por padrao ficamos no banco zero
                                            ; deixar setado como entrada qnd n estiver utilizando
                                            ; isso vai evitar que eles queimem já q vão estar sempre em alta impedancia
    