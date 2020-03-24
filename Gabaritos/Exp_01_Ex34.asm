#INCLUDE P16F628A.INC

		ORG		000H

		MOVLW	B'01001111'	; Carrega em W uma mascara para zerar os bits D7, D5 e D4
		ANDWF	20H,F		; Zera os bits indicados na mascara
		MOVLW	B'01001001'	; Carrega em W uma mascara para setar os bits D6, D3 e D0
		IORWF	20H,F		; Seta os bits indicados na mascara
		MOVLW	B'00000110'	; Carrega em W uma mascara para inverter os bits D1 e D2
		XORWF	20H,F		; Inverte os bits indicados na mascara

		MOVLW	49H			; Carrega W com a constante a ser testada
		XORWF	20H,W		; Apos uma operacao XOR com dois valores iguais, o resultado e zero
							; Coloca o resultado em W para nao afetar o conteudo de 20H
		BTFSS	STATUS,Z	; Testa se o resultado da operacao anterior deu zero (flag Z = 1)
		GOTO	DIFERE

		CLRF	25H			; Se [20H] contem 49H, entao zera a posicao 25H
		GOTO	FIM

DIFERE:	MOVLW	0FFH		; Caso contrario, coloca FFH nessa posicao
		MOVWF	25H

FIM:	GOTO	FIM

		END
