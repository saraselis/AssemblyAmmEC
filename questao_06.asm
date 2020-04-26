#INCLUDE P16F628A.INC				; diretiva do compilador

__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF

; VC(t) = 3T + 15	->	(1 + 2)T + 15  [equacao final do grupo F]

; ------- Declarando registradores -------
T	EQU	20H							; Define T
VC	EQU	21H							; Define VC 

; ------- Inicio -------
		ORG		000H				; definindo a origem
		GOTO 	INICIO				; vai para a main do programa

; ------- Main -------
INICIO:
		CALL	TESTA
		GOTO	FIM					; se C=0 (chama subrotina de fim), se C=1 essa instrucao e pulada

		CALL	POLINOMIO			; chama subrotina para calcular o polinomio
		GOTO	FIM					; chama subrotina de finalizacao apos calcular o polinomio

; ------- Subrotinas -------
TESTA:
		MOVFW	T					; W=T 
		SUBLW	.10					; 10-T, se T <= 10, flag C=1
		BTFSS	STATUS, C			; testa se a flag c esta setada
		RETURN

POLINOMIO:
		BCF		STATUS, C			; limpando os registradores
		MOVFW	T
		RLF		T, F				; realizando shift left para obter 2T
		ADDWF	T, W				; somando T + 2T, W=3T
		ADDLW   .15					; W = 3T + 20
		MOVWF	VC					; VC = W, VC = 3T + 20
		RETURN


FIM:	GOTO	FIM
		
		END