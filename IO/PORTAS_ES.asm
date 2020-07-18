#INCLUDE P16F628A.INC 

; ENTRADA: RBO, RB1, RB2
; SAIDA: RA0, RA1, RB3 E RB4
; TRIS: 0 -> SAIDA, 1 -> ENTRADA
; TRISA: 11111100 (FCH) -> porta de saida (analisa pelo ultimo digito q e o)
; TRISB: 11100111 (E7H) -> porta de entrada (analisa pelo ultimo digito q e 1)

; CHAveS: SOLTA -> 0, ACIONADA -> 1

            ORG     000H

            BSRF    STATUS, RP0         ; Muda p; Banco 1 da RAM
            MOVLW   0FCH                ; W = 252
            MOVWF   TRISA               ; ?
            MOVLW   B'11100111'         ; W = 231
            MOVWF   TRISB               ; ?
            BCF     STATUS, RP0         ; Volta p/ Banco 0 da RAM 

            BSRF    PORTA, 0            ; Led apaga (Ra0)
