#INCLUDE P16F628A.INC

FLAGS		EQU		45H
VALOR		EQU		35H

			ORG		000H
		
			CLRF	FLAGS ; garante q FLAGS é igual a zero
			MOVLW	035H ;

			ANDLW	5EH ; Mascara do AND zerando os bits: 0, 5, 7.
			IORLW	16H ; Mascara do OR setando os bits: 1, 2, 4.
			XORLW	48H ; Mascara do XOR setando os bits: 3, 6 q sao os bits a serem invertidos
			
			MOVWF	VALOR
			MOVLW	0F5H  ; carregando W com o limite superior
			SUBWF	VALOR, VALOR ; Valor - Limite superior.
			BTFSC	STATUS, C ;  testa a flag Carry e ve se houve "vai 1".
			CALL	FLAG	; Caso 1 no Carry, executa a subrotina FLAG.
							

FIM:		GOTO	FIM


FLAG:		MOVF	FLAGS, W ; Setando o valor do bit 1 para FLAGS.
			IORLW	004H
			MOVWF	FLAGS
			RETURN

			END