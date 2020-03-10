#INCLUDE P16F628A.INC
;comentario

VALOR EQU 20H
	   ORG 000H

		CLRF 25H
		MOVLW 	B'01001111' ; Mascara para zerar bits D7, D5, e D4  
		ANDWF 	VALOR, W
		IORWF		B'01001001' ; ou na posição e valor
		XORWF 	B'00000110' ; or na posição e valor
		MOVWF 	VALOR
		
		  ;saber se na posicao tem aquele valor (usar o xor e na hora da comporação se não der 0, tem algo naquela posição)
		XORLW 		49H
		BTFSS 		STATUS, Z
		DECF 		25H, F

FIM: 	GOTO	FIM

		END ;apenas uma diretriz para o compilador não é uma instrução assembly

; amarelinho reseta o processador
; o primeiro azulzinho roda td 
; colchetes são rotinhas



; COMPILAR. PROJECT-> QUICKBUILD NOMEDOTREM.ASM
; SIMULAR. DEBUGGER -> select tool -> 4-MPLAB SIM
;View-> file register

;view -> especial function registers
