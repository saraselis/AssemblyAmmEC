#INCLUDE P16F628A.INC								; diretiva do compilador

__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF

; ------- Enunciado -------

	; Telefone a ser verificado
	; 20h a 27h

	; Telefones bloqueados
	; Primeiro 30h-37h
	; Segundo 38h-3fh
	; Terceiro 40h-47h
	; Quarto 48h-4Fh
	; Quinto 50h-57h
	; Sexto 58h-5fh

; ------- Declarando registradores -------

NUMERO				EQU	28H							; tamanho telefone
QTD_NUM_BLOQ		EQU	29H							; quantidade contas
NUM_BLOQ_ATUAL	EQU	68H						
FLAG				EQU 69H							; Flag a ser ativada caso o numero n
													; seja um num bloqueado 

; ------- Inicio -------
		ORG			000H							; definindo a origem
		GOTO		INICIO

; ------- Main -------
INICIO:	
		MOVLW		.8				 				; W = 8
		MOVWF		NUMERO							; NUMERO = 8
		MOVLW		.6								; w = 6
		MOVWF		QTD_NUM_BLOQ					; QTD_NUM_BLOQ = 6
		MOVLW		28H								; W = 28H
		MOVWF		NUM_BLOQ_ATUAL					; NUM_BLOQ_ATUAL = 28H

RANGE_NUM_BLOQ:	
		; Define o range dos numeros telefonicos bloqueados
		MOVFW		NUM_BLOQ_ATUAL 					; W = Contas = 28h
		MOVWF		FSR								; FSR = Conta3 = 28h
		MOVLW		.8								; W = 8
		ADDWF		FSR, F 							; W = W (8) + 28H = 30
		CALL 		PERCORRE_NUMERO								;  

		DECFSZ 		QTD_NUM_BLOQ, F					; QTD_NUM_BLOQ = QTD_NUM_BLOQ - 1 
		GOTO 		RANGE_NUM_BLOQ
		GOTO 		FIM
			
PERCORRE_NUMERO:
		; percorrer todas as posicoes do numero
		MOVFW		INDF							; W = INDF
		XORWF		20H, W							; 20H X INDF (W = 30H)
		BTFSS		STATUS, Z
 		RETURN

		INCF 		FSR, F							; 30H + 1
		MOVFW		INDF							; W  = 31H
		XORWF		21H, W							; 21h X 31H (W)
		BTFSS		STATUS, Z	
 		RETURN 

		INCF 		FSR, F							; 32H
		MOVFW		INDF							; W  = 32H
		XORWF		22H, W							; 22h X 32H (W)
		BTFSS		STATUS, Z
 		RETURN 	

		INCF 		FSR, F							; 33H
		MOVFW		INDF							; W = 33H
		XORWF		23H, W							;23H X 33H (W)
		BTFSS		STATUS, Z	
 		RETURN 	

		INCF 		FSR, F							; 34H
		MOVFW		INDF							; W = 34H
		XORWF		24H, W							; 24H X 34H (W)
		BTFSS		STATUS, Z
 		RETURN 	

		INCF 		FSR, F 							; 35H
		MOVFW		INDF							; W = 35H
		XORWF		25H, W							; 25H X 35H (W)
		BTFSS		STATUS, Z
 		RETURN 	

		INCF 		FSR, F							; 36H
		MOVFW		INDF							; W = 36H
		XORWF		26H, W							; 26H X 36H (W)
		BTFSS		STATUS, Z
 		RETURN 	

		INCF 		FSR, F							; 37H
		MOVFW		INDF							; W = 37H
		XORWF		27H, W							; 27H X 37H (W)
		BTFSS		STATUS, Z
 		RETURN 		
		
		BSF 		FLAG, 7							; Colocando 1 no bit 7 da flag		; 
		GOTO 		FIM								; encerrando pois nenhum dos numeros e igual
	
FIM: 	GOTO 		FIM
		END 