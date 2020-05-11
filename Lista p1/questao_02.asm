; ------- Enunciado -------

#INCLUDE P16F628A.INC								; diretiva do compilador

__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF

; ------- Declarando registradores -------
FLAGS		EQU		45H
VALOR		EQU		35H

; ------- Inicio -------
		ORG		000H
		GOTO	MAIN

MAIN:
		CLRF	FLAGS								; garante q FLAGS � igual a zero
		MOVLW	035H 

		ANDLW	5EH 								; Mascara do AND zerando os bits: 0, 5, 7.
		IORLW	16H 								; Mascara do OR setando os bits: 1, 2, 4.
		XORLW	48H 								; Mascara do XOR setando os bits: 3, 6 q sao os bits a serem invertidos
		
		MOVWF	VALOR
		MOVLW	0F5H  								; carregando W com o limite superior
		SUBWF	VALOR, VALOR						; Valor - Limite superior.
		BTFSC	STATUS, C 							; testa a flag Carry e ve se houve "vai 1".
		CALL	FLAG								; Caso 1 no Carry, executa a subrotina FLAG.
				
FIM:	GOTO	FIM
		END

FLAG:	
		MOVF	FLAGS, W 							; Setando o valor do bit 1 para FLAGS.
		IORLW	004H
		MOVWF	FLAGS
		RETURN