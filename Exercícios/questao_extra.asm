; ------- Dados da questao  -------
; 6MHz -> CM: 666, 6666x10-9 nanoseg       0,6666 useg

; Para 5KHZ ->    	Tempo     	= 1/f 		= 1/5KHZ 	= 200useg
; 			Tempo/2 	= 100useg
;			Tmr0       	= 100useg/0,6666useg = 150,01 = 150  

; Para 1KHZ ->	Tempo	= 1/f		= 1/1KZ    	= 1mseg
;			Tempo/2	= 0,5mseg
;			Tmr0		= 0.5mseg/0,6666useg	= 750,07 = 750
	; Prescaler de 4 ->	Tmr0		= 0,5meg/(4x0,6666useg) = 187,51 = 188

; -------  Processador utilizado -------
#INCLUDE P16F628A.INC 

; ------- Inputs e Outputs  -------
#DEFINE		 LED_VD         	PORTB, 5   							 ; saida
#DEFINE		 LED_VM         	PORTB, 6   							 ; saida
#DEFINE		 AF	         	PORTA, 1   							 ; saida
#DEFINE		 LUZ	         	PORTB, 2   							 ; saida
#DEFINE		 RELE	         	PORTA, 0   							 ; saida
#DEFINE 		SENSOR		PORTA, 2
; ------- Registradores de uso geral  -------


; ------- Bancos de memoria  -------
#DEFINE	    	BANK0      		BCF     	STATUS, RP0				; mnemonico - banco 0		
#DEFINE		BANK1      		BSF     	STATUS, RP0				; mnemonico - banco 1

; ------- Contadores  -------
CONTA1       	EQU         	20H
CONTA2       	EQU         	21H
CONTA3       	EQU         	22H
CONTA4       	EQU         	23H
CONTA5		EQU		24H

; ------- Variaveis  -------
FLAGS    		EQU           25H
SALVA_W  		EQU           26H
SALVA_S  		EQU           27H
CONTADOR	EQU		28H

; ------- Definindo origem  -------
		ORG          		000H
	  	GOTO 	 	INICIO


; ------- Salvando o contexto da interrupcao -------
		ORG        		004H

	        	MOVWF           	SALVA_W                					 ; Salva o conteudo de w
	        	SWAPF           	STATUS, 	W						 ; Salva o conteudo do status sem alterar a flag z
	        	MOVWF           	SALVA_S							 ; PS: esse valor esta com os nibbles invertidos

; ------- Tratamento da interrupcao -------
		BTFSS           	INTCON, 	INTF            				; Interrupcao foi externa?
        		GOTO            	INT_TMR							; 0 - nao foi externa 
        		BSF             	FLAGS,	0               					; 1 - foi externa
        		BSF             	FLAGS, 	1                					; Zerando as Flags		 
        		MOVLW           	.30								; ? 
        		MOVWF           	LP_10SEG							; Vai para o Loop de 10 segundos
        
        		BCF            	INTCON, 	INTF           				;  Zera o bit que gerou a interrupcao externa
       													; Se a interrupco nao foi externa, trata como interna
        		GOTO         	FIMINT

INT_TMR: 
                BCF    			INTCON, 	T0IF                    			; Zera flag de interrupcao do timer 0
                BTFSS   		FLAGS, 	1
                GOTO    		VER_SENSOR
                MOVLW   		.100
                MOVWF  		TMR0                            				; Recarregar o timer
                ;MOVLW   		B'0000000'
                ;XOR     		PORTB, 	F                      				; 
                GOTO 			FIMINT

FIMINT: 
                SWAPF           	SALVA_S, W              					; Desinverter o valor dos nibbles, recupera o valor do status
                MOVWF   		STATUS                  					; Recupera o valor do Status
                SWAPF    		SALVA_W, 	F         
                SWAPF   		SALVA_W, W              					; Recupera o valor de status
                RETFIE 

; ------- Setando as entradas e saidas  -------
INICIO:
            	BANK1										; Vai para o banco 1 de memoria
            	MOVLW        	B'11111000'						; RA0, RA1, RA2 como saidas 
            	MOVWF        	TRISA 
            	MOVLW        	B'10011011'						; RB2, RB5, RB6 como saidas
            	MOVWF        	TRISB
		
		MOVLW    		B'11000001'						; Int externa por borda de subida, prescaler de 1:4
               	MOVWF    		OPTION_REG

                	MOVLW    		B'10110000'
                	MOVWF    		INTCON
            	BANK0										; Volta para o banco 0 de memoria

VOLTA:	
		BCF 			LED_VM							; Liga led vermelho
		BCF			LUZ 								; Desligar sinal luminoso
		BCF			RELE								; Desligar Rele
		BCF			AF								; Desligar Auto Falante

		BCF			FLAGS, 0							; Zerando as Flags
		BCf			FLAGS, 1							; Zerando as Flags									

; ------- Sub-rotinas  -------

VER_SENSOR:
		BTFSC		FLAGS, 1							; O sensor foi violado?
		GOTO		VIOLADO							; 1 - Vai para interrupcao de violacao
		BTFSS		FLAGS, 0							; 0 - Verifica o cartao de acesso
		
		GOTO		VER_SENSOR						; 0 - Nao ativado ver de novo o sensor
		BSF			FLAGS, 0							; 1 - Setando a flag zero como 1, segue o baile
		
		MOVLW		.20								; Adicionando 20 ao Worker
		MOVWF		CONTADOR						; Adicionando 20 ao contador	

		BSF			LED_VM							; Apaga o Led Vermelho
		BCF			LED_VD							; Liga o Led Verde
		BSF			RELE								; Ativa o Rele	

VER_PASS:
		BTFSC		SENSOR							; Verifica o sensor		
		GOTO		ABRE_CAT							; 1 - Abrir a catraca
		
		CALL			LP_05SEG							; Aguarda 0,5 Segundos
		DECFSZ      	CONTADOR, F						; Decrementando do contador
		
		GOTO		VER_PASS							; 1 - Verifica de novo
		GOTO		ABRE_CAT							; 0 - pula
	
;  Bit 0: 0 = Leitora não ativada; 1 = Leitora de cartão gerou um sinal


ABRE_CAT:
		BSF			LED_VM							; Apaga do Led Vermelho
		BCF			LED_VD							; Liga o Led Verde
		BSF			RELE								; Ativa o Rele
		CALL			LP_10SEG							; Espera os 10 segundos da catraca
		BCF			RELE								; Desativa o Rele
		GOTO		VOLTA

; ------- Loops -------
	
LP_10SEG:
            	MOVLW       	.50                    						 ; 50 x  200mseg = 10s
            	MOVWF       	CONTA4

LOOP2:      
            	CALL        		LP_200MS               					
            	DECFSZ      	CONTA4, F
            	GOTO        		LOOP2

LP_8SEG:
            	MOVLW       	.40                    						 ; 40 x  200mseg = 8s
            	MOVWF       	CONTA3
		
LOOP1:      
            	CALL        		LP_200MS               					
            	DECFSZ      	CONTA3, F
            	GOTO        		LOOP1

LP_05SEG:
            	MOVLW       	.3                    						 ; 2,5 x  200mseg = 0,5s
            	MOVWF       	CONTA5
		
LOOP3:      
            	CALL        		LP_200MS               					
            	DECFSZ      	CONTA5, F
            	GOTO        		LOOP3


LP_200MS:
            	MOVLW       	.200                   						 ; 200 x 1 mseg = 200 mseg
            	MOVWF     	CONTA2

LP_1MS:   												
            	MOVLW       	.215								 ; 7 x ? x 0,6666 useg = 1mseg
            	MOVWF       	CONTA1							 ; x = 215

LOOP:       	
		NOP											
		NOP											 
            	NOP
		NOP
            	DECFSZ      	CONTA1, F							
            	GOTO        		LOOP

	         DECFSZ      	CONTA2, F							
            	GOTO        		LP_1MS
            	RETURN  

; --------- labels para excluir -------
VIOLADO: 	
		; nao deu tempo de programar certinho as interrupcoes
		; deixei a subrotina para a pipeline manter o sentido
		GOTO 	VIOLADO

		END
