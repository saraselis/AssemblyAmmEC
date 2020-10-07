; Dados da questao


; -------  Processador utilizado -------
#INCLUDE P16F628A.INC 


; ------- Cristal e CM  -------
; Cristal => 3,2 MHz
; CM = 4 / 3,2MHz = 1,25 useg


; ------- Inputs e Outputs  -------
#DEFINE		 LED         	PORTA, 0   							 ; saida
#DEFINE     	SINAL1      PORTA, 1
#DEFINE     	SINAL2      PORTA, 2
#DEFINE     	CH_PA       	PORTB, 1
#DEFINE     	CH_PF       	PORTB, 2
#DEFINE     	RL1         	PORTB, 3   							 ; saida
#DEFINE     	RL2         	PORTB, 4    						 ; saida
#DEFINE     	RL3         	PORTB, 5    						 ; saida


; ------- Registradores de uso geral  -------
#DEFINE		LIGA_LED		BCF    	LED					; mnemonico - liga o led
#DEFINE		DESL_LED		BSF    	LED					; mnemonico - desliga o led

; ------- Bancos de memoria  -------
#DEFINE	    	BANK0      		BCF     	STATUS, RP0			; mnemonico - banco 0		
#DEFINE		BANK1      		BSF     	STATUS, RP0			; mnemonico - banco 1


; ------- Variaveis  -------


; ------- Contadores  -------
CONTA1       	EQU         20H
CONTA2       	EQU         21H
CONTA3       	EQU         22H


; ------- Definindo origem  -------
		ORG          		000H
	  	GOTO 	 	INICIO


; ------- Setando as entradas e saidas  -------
INICIO:
            	BANK1
            	MOVLW        	B'11111110'
            	MOVWF        	TRISA 
            	MOVLW        	B'11000111'
            	MOVWF        	TRISB
            	BANK0


; ------- Sub-rotinas  -------
VOLTA:      
	   	BSF         		LED 
            	BCF         		RL1
            	BCF         		RL2
            	BCF         		RL3
            	CALL        		LP_200MS


TST_S1:
            	BTFSS       		SINAL1
            	GOTO        		TST_S2


           	BSF         		RL1 
            	CALL        		LP_2SEG
            	BCF         		RL1


TST_S2:
            	BTFSS       		SINAL2
            	GOTO        		TST_S1

            	BTFSC       		CH_PA                      					 ; portao aberto?
            	GOTO        		ABRIR


; fechar
            	BSF         		RL2                        					 ; aciona rele q fecha
            	BCF         		LED                        					 ; liga led
ESPERA1:
            	btfss       		CH_PF                       					 ; portao totalmente fechado?
            	GOTO        		VOLTA

            	BTFSC       		SINAL2
            	GOTO        		VOLTA

            	GOTO        		ESPERA1


ABRIR:       
            	BSF         		RL3                        					 ; aciona rele q fecha
            	BCF         		LED                         					 ; liga led
ESPERA2:
            	BTFSS       		CH_PA                      					 ; portao totalmente fechado?
            	GOTO        		VOLTA

            	BTFSC       		SINAL2
            	GOTO        		VOLTA

            	GOTO        		ESPERA2


; ------- Loops -------

LP_2SEG:
            	MOVLW       	.10                    						 ; 10 x  200mseg = 2s
            	MOVWF       	CONTA3

LOOP1:      
            	CALL        		LP_200MS               					 ; 200 x 1 mseg = 200 mseg
            	DECFSZ      	CONTA3, F
            	GOTO        		LOOP1

LP_200MS:
            	MOVLW       	.200                   						 ; 4 x 200 x 1,25u = 1mseg
            	MOVWF     	CONTA2

LP_1MS:   
            	MOVLW       	.200
            	MOVWF       	CONTA1

LOOP:       
            	NOP
            	DECFSZ      	CONTA1, F
            	GOTO        		LOOP

	         DECFSZ      	CONTA2, F
            	GOTO        		LP_1MS
            	RETURN  


		END
