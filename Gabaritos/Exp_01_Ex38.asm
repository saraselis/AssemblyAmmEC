#INCLUDE P16F628A.INC

DADO	EQU	20H		; Valor a ser verificado
FLAGS	EQU	21H		; Guarda as flags de uso do programa (definidas pelo programa)
CONTA1	EQU	22H		; Contador de bits iguais a 1
NUMBITS	EQU	23H		; Contador dos 8 bits de DADO

		ORG		000H

		CLRF	FLAGS	; Zera todas as flags, ou seja, os 8 bits de FLAGS
		CLRF	CONTA1	; Zera o contador de bit iguais a 1
		MOVLW	8		; 8 bits em DADO
		MOVWF	NUMBITS
LOOP:	RRF		DADO,F	; Rotaciona bit para a flag C
		BTFSC	STATUS,C ; Verifica se o bit rotacionado eh igual a 1
		INCF	CONTA,F	; Incrementa contador de bits iguais a 1
		DECFSZ	NUMBITS,F ; Verifica se os 8 bits ja foram rotacionados
		GOTO	LOOP
		
		BTFSC	CONTA,0	; Testa se CONTA eh par
		GOTO	FIM

		BSF		FLAGS,7	; Se for, seta o bit 7 de FLAGS indicando a paridade impar

FIM:	GOTO	FIM		

		END
