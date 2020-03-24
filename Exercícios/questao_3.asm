#INCLUDE P16F628A.INC
;comentario

VALOR EQU 20H
	   ORG 000H

	  MOVLW B'01001111' ; Mascara para zerar bits D7, D5, e D4  
	  ANDWF VALOR, F

	  MOVLW B'01001001' ; Mascara para setar bits D6, D3 e D0
	  IORWF VALOR, F ; ou na posição e valor

	  MOVLW B'00000110' ; Mascara para inverter bits D2 e D1
	  XORWF VALOR, F ; or na posição e valor

       ;saber se na posicao tem aquele valor (usar o xor e na hora da comporação se não der 0, tem algo naquela posição)
	 MOVLW 49H
	 XORWF VALOR, W
	 BTFSS STATUS, Z
	 GOTO NAO_49H
	
	CLRF 25H
TEM_49H: GOTO	TEM_49H

NAO_49H: MOVLW		0FFH
		  MOVWF		25H
FIM:	  GOTO		FIM	 


		END ;apenas uma diretriz para o compilador não é uma instrução assembly

; amarelinho reseta o processador
; o primeiro azulzinho roda td 
; colchetes são rotinhas



; COMPILAR. PROJECT-> QUICKBUILD NOMEDOTREM.ASM
; SIMULAR. DEBUGGER -> select tool -> 4-MPLAB SIM
;View-> file register

;view -> especial function registers
