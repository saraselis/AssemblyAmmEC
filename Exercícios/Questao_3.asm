#INCLUDE P16F628A.INC
;comentario

VALOR EQU 20H
	   ORG 000H

	  MOVLW B'01001111' ; Mascara para zerar bits D7, D5, e D4  
	  ANDWF VALOR, F

	  MOVLW B'01001001' ; Mascara para setar bits D6, D3 e D0
	  IORWF VALOR, F ; ou na posi��o e valor

	  MOVLW B'00000110' ; Mascara para inverter bits D2 e D1
	  XORWF VALOR, F ; or na posi��o e valor

       ;saber se na posicao tem aquele valor (usar o xor e na hora da compora��o se n�o der 0, tem algo naquela posi��o)
	 MOVLW 49H
	 XORWF VALOR, W
	 BTFSS STATUS, Z
	 GOTO NAO_49H
	
	CLRF 25H
TEM_49H: GOTO	TEM_49H

NAO_49H: MOVLW		0FFH
		  MOVWF		25H
FIM:	  GOTO		FIM	 


		END ;apenas uma diretriz para o compilador n�o � uma instru��o assembly
