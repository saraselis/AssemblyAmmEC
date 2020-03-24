; Desenvolva um programa que coloque o valor 3AH na posição de memória 25H, 
; o valor 45 na posição
; 26H e transfira o valor contido em 27H para 30H. O programa deve ser salvo com
; a extensão .ASM 


#INCLUDE P16F628A.INC

        ORG 000H

        MOVLW   3AH     ; Colocando o valor em W
        MOVWF   25H     ; Colocar o valor de W na posição
    
        MOVLW   .45     ; colocando 45 na posição 26H
        MOVWF   26H     

        MOVLW   27H     ; Movendo o valor de 27h para w e dps para 30h(posicao)
        MOVWF   30H

FIM:    GOTO    FIM
        END