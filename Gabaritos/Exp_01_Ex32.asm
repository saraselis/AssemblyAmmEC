#INCLUDE P16F628A.INC

		ORG		000H

		MOVLW	3AH		; Carrega W com a constante 3AH
		MOVWF	25H		; Transfere o valor de W para a posicao de memoria 25H
		MOVLW	.45		; Carrega W com a constante decimal 45 (2DH em hexadecimal)
		MOVWF	26H		; Transfere o valor de W para a posicao 26H
		MOVFW	27H		; Transfere o conteudo da posicao de memoria 27H para W
		MOVWF	30H		; Transfere o valor de W para a posicao 30H

		MOVFW	25H		; Transfere o conteudo da posicao 25H para W
		ADDWF	28H,W	; Soma com o conteudo de 28H, colocando o resultado em W
		MOVWF	30H		; Salva o resultado da soma em 30H
		BTFSS	STATUS,C ; Testa se soma excedeu a capacidade do registrador (flag C = 1)
		GOTO	RESULT_OK

		MOVLW	1		; Se excedeu, coloca 1 em 31H
		MOVWF	31H
		GOTO	FIM

RESULT_OK:
		CLRF	31H		; Se nao excedeu, zera o conteudo de 31H

FIM:	GOTO	FIM

		END
