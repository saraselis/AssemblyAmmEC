#INCLUDE P16F628A.INC

		ORG		000H

		MOVLW	67H		; Carrega W com a constante 67H
		ANDWF	2AH,W	; Efetua operacao AND com o conteudo de 2AH, colocando o resultado em W
		MOVWF	2BH		; Slava o resultado em 2BH
		COMF	2BH,F	; Inverte o conteudo de 2BH (/AND = NAND)
		MOVFW	2AH		; Transfere o conteudo da posicao de memoria 2AH para W
		ANDWF	2BH,F	; Efetua operacao AND com o conteudo de 2BH, colocando o resultado em 2BH
		MOVLW	67H		; Carrega W novamente com a constante 67H
		IORWF	2BH,W	; Efetua operacao OR com o conteudo de 2BH, colocando o resultado em W
		ANDLW	67H		; E em seguida uma operacao AND com a constante 67H
		MOVWF	2BH		; Salvando o resultado em 2BH

FIM:	GOTO	FIM

		END
