#INCLUDE P16F628A.INC
;Usar o Xor para veriricar se tem valor x na posicao x

VALOR1	EQU	30H
VALOR2	EQU	32H
VALOR3	EQU	31H

		ORG		00H
	
		MOVLW	1EH
		XORWF	VALOR1,W
		BTFSS	STATUS,Z 
;tanto faz set ou clear
		GOTO	SUBTRAI

		MOVFW	VALOR1
		ADDWF	VALOR2,W
		MOVWF 	VALOR3
		GOTO	FIM

SUBTRAI:MOVFW	VALOR1
		SUBWF	VALOR2, F

FIM:	GOTO	FIM

		END