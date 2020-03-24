#INCLUDE P16F628A.INC

		ORG		000H

		MOVLW	3AH		; Carrega W com a constante 3AH
		MOVWF	25H		; Transfere o valor de W para a posicao de memoria 25H
		MOVLW	.45		; Carrega W com a constante decimal 45 (2DH em hexadecimal)
		MOVWF	26H		; Transfere o valor de W para a posicao 26H
		MOVFW	27H		; Transfere o conteudo da posicao de memoria 27H para W
		MOVWF	30H		; Transfere o valor de W para a posicao 30H

		CLRF	31H		; Supoe que nao havera estouro na soma
		MOVFW	25H		; Transfere o conteudo da posicao 25H para W
		ADDWF	28H,W	; Soma com o conteudo de 28H, colocando o resultado em W
		MOVWF	30H		; Salva o resultado da soma em 30H
		BTFSC	STATUS,C ; Testa se soma excedeu a capacidade do registrador (flag C = 1)
		INCF	31H,F	; Se houve, incrementa (soma 1) conteudo de 31H

FIM:	GOTO	FIM

		END
