#INCLUDE P16F628A.INC

		ORG		000H

		MOVLW	1EH
		XORWF	30H,W	; Testa se 30H contem 1EH
		BTFSS	STATUS,Z
		GOTO	NAO_CONTEM

		MOVFW	30H		; Pega o conteudo de 30H
		ADDWF	31H,W	; Soma com o conteudo de 31H
		MOVWF	32H		; E salva o resultado em 32H
		GOTO	FIM

NAO_CONTEM:
		MOVFW	30H
		SUBWF	31H,F	; Subtrai o conteudo de 30H de 31H, salvando o resultado em 31H

FIM:	GOTO	FIM		

		END
