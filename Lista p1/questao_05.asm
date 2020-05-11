; Fosc = 5Mhz entao CM = 0,8useg
; 0,8useg = 0.0008mseg

#INCLUDE P16F628A.INC                                ; diretiva do compilador

__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF


; ------- Declarando registradores -------

K1			EQU		28H                             ; Define K1
K2			EQU		27H                             ; Define K2
ALFA		EQU		26H	  
BETA		EQU		25H	  
X			EQU		24H                             ; Define X
M			EQU		23H                             ; Define M
CONT     	EQU		20H                             ; Define CONT
CONT2       EQU     29H
POINTER		EQU		21H                             ; Define POINTER
REPEAT		EQU		22H                             ; Define REPEAT


; ------- Inicio -------

		ORG		000H				                ; definindo a origem
		MOVLW   05H
		MOVFW   CONT2
		GOTO 	INICIO				                ; vai para a main do programa


; ------- Main -------

INICIO:		MOVLW	0FFH
			MOVWF	REPEAT
			
			CLRF	POINTER
			MOVLW	4AH
			MOVWF	FSR

			MOVLW	16H
			MOVWF	CONT
			
			MOVLW	0ABH
			MOVWF	K1

			MOVLW	67H
			MOVWF	K2

			MOVLW	15H
			MOVWF	X

			MOVLW	0D4H
			MOVWF	ALFA

			MOVLW   0FFH			
			XORWF   ALFA,W  
			MOVWF   BETA                        ; BETA ficou como 2BH

			CALL	GET_MEM
			
FIM:		GOTO	FIM

           ; ------- Subrotinas -------

CIFRA:		XORWF	K1, W                   	; K1 xor X.
			MOVWF	X
			SWAPF	X, W                    	; SWAP(X xor K1).
			
			ADDWF	BETA, W                 	; SWAP(X xor K1) + BETA.
			XORWF	K2, W                   	; SWAP(X xor K1) + BETA xor K2.
			MOVWF	X
			SWAPF	X, W	                    ; SWAP(SWAP(X xor K1) + BETA xor K2).

			MOVWF	M	                    	; M = SWAP(SWAP(X xor K1) + BETA xor K2).

			RETURN

GET_MEM:	MOVFW 	INDF

			CALL	CIFRA		
			CALL	PARADA
			CALL	GET_X

			INCF	POINTER, F        ; vai de 4AH e vai ate 5BH 
			INCF	FSR, F
			DECFSZ	CONT, F          ; CONTADOR COMEÇA EM 16H E DECREMENTA
			GOTO	GET_MEM
			RETURN

GET_X:		SWAPF	M, W	      ; SWAP(M xor K1) + ALFA xor K2
			MOVWF	X
			XORWF	K2, W	       ; SWAP(M xor K1) + ALFA
			ADDWF	ALFA, W	       ; SWAP(M xor K1)
			MOVWF	M
			SWAPF	M, W	       ; M xor K1
			XORWF	K1, W

			MOVWF	X
			RETURN

PARADA:		NOP                 ; TEMPO = 5 * (5 * REPET (255) * CM (0,0008)) = 5.1s
 			NOP
			DECFSZ	REPEAT, F
			GOTO	PARADA
			
			DECFSZ	CONT2, F
			GOTO	REPETE_PARADA

			RETURN

REPETE_PARADA: 
			MOVLW 0FFH
		    MOVWF REPEAT
			GOTO  PARADA

			END

; T = 4 x K1 x CM
;