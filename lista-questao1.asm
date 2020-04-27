#INCLUDE P16F628A.INC


VALOR		EQU		35H
M1			EQU		25H

			ORG		000H

			MOVLW	035H

			ANDLW	5EH ; Mascara do AND zerando os bits: 0, 5, 7.
			IORLW	16H ; Mascara do OR setando os bits: 1, 2, 4.
			XORLW	48H ; Mascara do XOR setando os bits: 3, 6 q sao os bits a serem invertidos

			
			MOVWF	VALOR
			MOVLW	0B1H ; carregando o valor de K1 no W

			XORWF	VALOR ; XOR de VALOR e K1 para ver se sao iguais

			MOVLW	0FFH
			ADDWF	VALOR ; VALOR + FFH para verificar se o retorno do XOR é 0
						  ; Se o XOR retorna 0, sao iguais. Se retornar 1, sao diferentes

			BTFSC	STATUS, C ; verificar se flag carry foi setada, ou seja, se houve 'vai um'
                              ; Se C=1 entao zera a posicao M1
			CLRF	M1

FIM:		GOTO	FIM

			END