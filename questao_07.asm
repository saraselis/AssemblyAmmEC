; ------- Enunciado -------
	; condicao		a<60
	; operacao 1	b = b - c
	; operacao 2 	A = b*2

#INCLUDE P16F628A.INC				; diretiva do compilador

__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF

; ------- Declarando registradores -------
A	EQU	20H
Be	EQU	21H
Ce	EQU	22H

; ------- Inicio -------
		ORG		000H				; definindo a origem
		GOTO 	FUNCAO				; vai para a main do programa

; ------- Main ------- clrf X
FUNCAO:
		; A = B + C
		MOVFW	Ce					; W=C
		ADDWF	Be, W				; W = Be + W(Ce)
		MOVWF	A					; A = W

		GOTO	CONDICAO
		
CONDICAO:
		; A < 60
		MOVLW	.60					; W = 60
		SUBWF	A, W				; W = A - 60, Se A<60: C->0, A=60: C->1, A>60: C->1
		BTFSC	STATUS, C			; testa se a flag C=0
		GOTO	OPERACAO_2			; C=0, (A < 60) vai para subrotina operacao_1
		GOTO	OPERACAO_1			; C=1, (A >= 60)vai para subrotina operacao_2

OPERACAO_1:
		; B = B - C
		MOVFW	Ce					; W=C
		SUBWF	Be, W				; W = B - W (C)
		MOVWF	Be					; B = W (B - C)	
		GOTO	FIM					; encerra o programa

OPERACAO_2:
		; A = B * 2
		BCF		STATUS, C			; limpando os registradores
		MOVFW	Be					; W = Be
		RLF		Be, F				; W = Be * 2
		MOVF	Be, W				; A = W (Be*2)
		MOVWf	A
		GOTO	FIM					; encerra o programa

FIM:	GOTO	FIM

		END				