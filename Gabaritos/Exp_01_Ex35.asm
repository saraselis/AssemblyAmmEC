#INCLUDE P16F628A.INC

		ORG		000H

		CLRF	26H			; Zera a posicao 26H
		MOVF	25H,W		; Transfere o conteudo de 25H p/ W
							; A instrucao MOVF afeta a flag Z
							; Se o conteudo de 25H for igual 0 -> flag Z = 1
							; Se o conteudo de 25H for diferente de 0 -> flag Z = 0
		BTFSC	STATUS,Z	; Verifica o valor da flag Z apos a operacao
		GOTO	FIM			; Se a flag estiver setada, [25h] = 0 e encerra

		ADDLW	.37			; Caso contrario, soma o conteudo de 25H com a constante 37
		MOVWF	26H			; Salvando o resultado em 26H

FIM:	GOTO	FIM

		END
