#INCLUDE P16F628A.INC
;comentario

VALOR EQU 20H
	   ORG 000H

		CLRF 25H
		MOVLW 	B'01001111' ; Mascara para zerar bits D7, D5, e D4  
		ANDWF 	VALOR, W
		IORWF		B'01001001' ; ou na posi��o e valor
		XORWF 	B'00000110' ; or na posi��o e valor
		MOVWF 	VALOR
		
		  ;saber se na posicao tem aquele valor (usar o xor e na hora da compora��o se n�o der 0, tem algo naquela posi��o)
		XORLW 		49H
		BTFSS 		STATUS, Z
		DECF 		25H, F

FIM: 	GOTO	FIM

		END ;apenas uma diretriz para o compilador n�o � uma instru��o assembly


