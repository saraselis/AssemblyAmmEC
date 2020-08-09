#INCLUDE P16F628A.INC 

; ENTRADA: RBO, RB1
; SAIDA: RB3 E RB4
; TRIS: 0 -> SAIDA, 1 -> ENTRADA
; TRISA: 11111100 (ffh) -> porta de saida (analisa pelo ultimo digito q e o)
; TRISB: 11100111 (E7H) -> porta de entrada (analisa pelo ultimo digito q e 1)

; CHAveS: SOLTA -> 0, ACIONADA -> 1

                ORG     000H

                BSF    STATUS, RP0         ; Muda p; Banco 1 da RAM
                MOVLW   0FCH                ; W = 252
                MOVWF   TRISA               ; ?
                MOVLW   B'11100111'         ; W = 231
                MOVWF   TRISB               ; ?
                BCF     STATUS, RP0         ; Volta p/ Banco 0 da RAM 

                BSF     PORTA, 0            ; Led apaga (Ra0)
                BSF     PORTB, 1            ; Led apaga (Ra1)    
        
                ; chave 1
VOLTA:          BTFSS   PORTB, 0            ; CHAVE FOI PRESSICONADA?
                BCF     PORTA, 0            ; lED aCEND (RA0)
                
                BTFSC   PORTB, 0            ; CHAVE FOI SOLTA?
                BSF     PORTA, 0            ; apaga led ra0

; chave 2
                BTFSS   PORTB, 1            ; CHAVE FOI PRESSICONADA?
                BCF     PORTA, 1            ; lED aCEND (RA0)

                BTFSC   PORTB, 1           ; CHAVE FOI SOLTA?
                BSF     PORTA, 1            ; apaga (rb1)

                GOTO    VOLTA

                END