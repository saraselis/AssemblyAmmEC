; ------- Descricao do problema  -------
; | RA0 -> LED       | RA1 -> Chave fa | RA2 -> chave sol | RB0 -> chave dó |
; | RB1 -> chave fá  | RB2 -> chave ré | RB3 -> AF        | RB4 -> Chave lá |

; C = 261,63 Hz -> T = 3,822 mseg / T/2 = 1,911 mseg = 1.911 useg
; D = 293,66 Hz -> T = 3,405 mseg / T/2 = 1,7025 mseg = 1.702,5 useg
; D# = 311,13 Hz -> T = 3,214 mseg / T/2 = 1,607 mseg = 1.607 useg
; E = 329,63 Hz -> T = 3,0337 mseg / T/2 = 1,51685 mseg = 1.516,85 useg
; G = 392 Hz -> T = 2,551 mseg / T/2 = 1,2755 mseg = 1.275,5 useg
; G# = 415,3 Hz -> T = 2,407 mseg / T/2 = 1,2035 mseg = 1.203,5 useg
; A = 440 Hz -> T = 2,273 mseg / T/2 = 1,1365 mseg = 1.136,5 useg
; B = 493,88 Hz -> T = 2,0247 mseg / T/2 = 1,0123 mseg = 1.012,35useg

; C, D, D#, E, G, G#, A, B,  
; # Fur Elise
	; E D# E D# E B D C A C E A B E G# B DO

; # Oh Susana
	; C D E G G A G E C D E E D C D C D 

; -------  Processador utilizado -------
#INCLUDE P16F628A.INC 

; ------- Inputs e Outputs  -------
#DEFINE     	CH_DO       	PORTB, 1
#DEFINE     	CH_RE       		PORTB, 2
#DEFINE		CH_RES		PORTB, 3
#DEFINE     	CH_MI       	PORTB, 4
#DEFINE     	CH_SOL      	PORTB, 5 
#DEFINE     	CH_SOLS      	PORTB, 6 
#DEFINE     	CH_LA      		PORTB, 7
#DEFINE     	CH_SI      		PORTA, 1 
#DEFINE     	LED         		PORTA, 2
#DEFINE		LED_VM		PORTA, 3
#DEFINE		LED_VD		PORTA, 4
#DEFINE     	AF          		PORTA, 6
#DEFINE		CH_INT		PORTB, 0
#DEFINE		CH_CL		PORTA, 7


; ------- Registradores de uso geral  -------
#DEFINE		DESL_LED		BSF		LED
#DEFINE		LIGA_LED		BCF		LED
#DEFINE		LIGA_AF		BSF		AF
#DEFINE		DESL_AF		BCF		AF

; ------- Bancos de memoria  -------
#DEFINE	    	BANK0      		BCF     	STATUS, RP0				; mnemonico - banco 0		
#DEFINE		BANK1      		BSF     	STATUS, RP0				; mnemonico - banco 1

; ------- Contadores  -------
CONTA       	EQU		 20H

; ------- Variaveis  -------


; ------- Definindo origem  -------
		ORG          		000H
		CLRF    		STATUS
        		GOTO    		INICIO

; ------- Principio do programa  -------
INICIO:
        		BANK1                                          							 ; Vai para o Banco 1
        		MOVLW       	B'10000000'                        					 ; Somente RA0 como saida
        		MOVWF       	TRISA                               

       		MOVLW       	B'00000001'
        		MOVWF       	TRISB                              					 ; Somente RB3 como saida
        		BANK0                                          							 ; Volta para o Banco 0

        		DESL_LED                                       						 ; Desliga o LED
       		DESL_AF                                        						 ; Desliga o Auto Falante

; ------- Subrotinas  -------

; # Nota Do> C = 261,63Hz -> T = 3,82 mseg | T/2 = 1,911mseg = 1.911 useg #
TESTA_DO:     
        		BTFSC       		CH_DO                               					; A Chave do Do esta acionada?
        		GOTO        		TESTA_RE                            				; 1 - Testa a chave do RE
        		LIGA_LED                                        						; 0 - Liga o led

GERA_DO:    
        		LIGA_AF                                         						; Ligar o auto falante
        		CALL        		TEMPO_DO                            				; Tocar a nota pelo tempo determinado do Do
        		DESL_AF                                         						; Desligar o auto falante
        		CALL        		TEMPO_DO                            				; Esperar o tempo da nota

        		BTFSS       		CH_DO                               					; A chave continua pressionada?
        		GOTO        		GERA_DO                             					; 0 - Gerar a nota novamente
        		DESL_LED                                        						; 1 - Apagar o led


; # Nota Re> D = 293,66hz -> T = 3.45 mseg -> T/2 = 1,702mseg = 1.702,5useg #
TESTA_RE:     
        		BTFSC       		CH_RE                               					; A Chave do Re foi acionada?
        		GOTO        		TESTA_RES                            				; 1 - Testa a chave do mi
        
        		LIGA_LED                                       			 			; 0 - Acende led

GERA_RE:    
        		LIGA_AF                                         						; Ligar auto falante
        		CALL        		TEMPO_RE                            				; Tocar a nota pelo tempo determinado do Re
        		DESL_AF                                        						; Desliga o auto falante
        		CALL        		TEMPO_RE                            				; Esperar o tempo da nota

        		BTFSS       		CH_RE                               					; A chave foi solta?
        		GOTO        		GERA_RE                             					; 0 - Gerar a nota novamente
       		LIGA_LED                                        						; 1 - Liga o led


; # Nota Re#> D# = 311,13 Hz -> T = 3,214 mseg / T/2 = 1,607 mseg = 1.607 useg
TESTA_RES:     
        		BTFSC       		CH_RES                               					; A Chave do Re foi acionada?
        		GOTO        		TESTA_MI                            				; 1 - Testa a chave do mi
        
        		LIGA_LED                                       			 			; 0 - Acende led

GERA_RES:    
        		LIGA_AF                                         						; Ligar auto falante
        		CALL        		TEMPO_RES                            				; Tocar a nota pelo tempo determinado do Re
        		DESL_AF                                        						; Desliga o auto falante
        		CALL        		TEMPO_RES                            				; Esperar o tempo da nota

        		BTFSS       		CH_RES                               					; A chave foi solta?
        		GOTO        		GERA_RES                            					; 0 - Gerar a nota novamente
       		LIGA_LED


; # Nota Mi> E = 329,63Hz -> T = 3,0337 mseg -> t/2 = 1,516 mseg = 1.516,85 useg
TESTA_MI:     
        		BTFSC       		CH_MI                               					; A Chave do Mi foi pressionada?
        		GOTO        		TESTA_SOL                              				; 1 - Testa a chave do Fa

        		LIGA_LED                                        						; 0 - Liga o led

GERA_MI:    
       		 LIGA_AF                                         						; Liga auto falante
        		CALL        		TEMPO_MI                            				; Toca a nota pelo tempo do Mi
       		 DESL_AF                                         						; Desliga auto falante
        		CALL        		TEMPO_MI                            				; 

       		BTFSS       		CH_MI                   						; chave do foi solta?
        		GOTO        		GERA_MI                
        		DESL_LED			                     						;apaga o led


; Nota Sol> G = 392Hz -> T =  2,551mseg -> t/2 = 1,2755 mseg = 1.275,5 useg
TESTA_SOL:    
        		BTFSC       		CH_SOL                  						 ; Chave do re acionada?????
        		GOTO        		TESTA_SOLS
        
        		LIGA_LED			                    						 ; Acende led

GERA_SOL:   
        		LIGA_AF		                    							 ; liga auto falante
        		CALL       		TEMPO_SOL                  
        		DESL_AF		                  							; desliga auto falante
       		CALL        		TEMPO_SOL

        		BTFSS       		CH_SOL                   						; chave do foi solta?
        		GOTO        		GERA_SOL                
       		DESL_LED                     								; apaga o led


; Nota SolS>  G# = 415,3 Hz -> T = 2,407 mseg / T/2 = 1,2035 mseg = 1.203,5 useg
TESTA_SOLS:    
        		BTFSC       		CH_SOLS                  						 ; Chave do re acionada?????
        		GOTO        		TESTA_LA
        
        		LIGA_LED			                    						 ; Acende led

GERA_SOLS:   
        		LIGA_AF   		                     							 ; liga auto falante
        		CALL       		TEMPO_SOLS                  
        		DESL_AF		                     							; desliga auto falante
       		CALL        		TEMPO_SOLS

        		BTFSS       		CH_SOLS                   						; chave do foi solta?
        		GOTO        		GERA_SOLS                
       		DESL_LED			                    						; apaga o led


; Nota La> A = 440Hz -> T =  2,273mseg -> t/2 = 1,1365 mseg = 1.136,5 useg
TESTA_LA:     
        		BTFSC       		CH_LA                  						; Chave do re acionada?????
        		GOTO        		TESTA_SI				
                            
        		LIGA_LED			                     						; Acende led

GERA_LA:    
        		LIGA_AF		                      							; liga auto falante
        		CALL        		TEMPO_LA                  
        		DESL_AF		                     							; desliga auto falante
       		CALL        		TEMPO_LA

        		BTFSS       		CH_LA                  						 ; chave do foi solta?
        		GOTO        		GERA_LA                
       		DESL_LED			                    						; apaga o led

; Nota Si> B = 493,88 Hz -> T = 2,0247 mseg / T/2 = 1,0123 mseg = 1.012,35useg
TESTA_SI:     
        		BTFSC       		CH_SI                  						; Chave do re acionada?????
        		GOTO        		TESTA_DO				
                            
        		LIGA_LED			                     						; Acende led

GERA_SI:    
        		LIGA_AF		                      							; liga auto falante
        		CALL        		TEMPO_SI                  
        		DESL_AF		                     							; desliga auto falante
       		CALL        		TEMPO_SI

        		BTFSS       		CH_SI                  						 ; chave do foi solta?
        		GOTO        		GERA_SI                
       		DESL_LED			                    						; apaga o led

        		GOTO        		TESTA_DO


; ---- subrotinas
TEMPO_DO:      
        		MOVLW      	 .238           							; 238 x 8 x 1 useg = 1.911 useg
        		MOVWF       	CONTA           							; 
        		GOTO        		LOOP

TEMPO_RE:      
        		MOVLW       	.213        								; 213 x 8 x 1 useg = 1.702,5useg
        		MOVWF       	CONTA      								; 
        		GOTO        		LOOP

TEMPO_RES:
		MOVLW       	.201        								; 201 x 8 x 1 useg = 1.607 useg
        		MOVWF       	CONTA      								; 
        		GOTO        		LOOP

TEMPO_MI:      
        		MOVLW      	.190           								; 190 x 8 x 1 useg = 1.520 useg
        		MOVWF       	CONTA      								;  
        		GOTO        		LOOP

TEMPO_SOL:     
        		MOVLW       	.159           								; 159 x 8 x 1 useg = 1.272 useg
        		MOVWF       	CONTA       							;  
        		GOTO        		LOOP

TEMPO_SOLS:   
		MOVLW       	.150           								; 150 x 8 x 1 useg = 1.200 useg
        		MOVWF       	CONTA       							;  
        		GOTO        		LOOP

TEMPO_LA:      
        		MOVLW       	.142           								; 142 x 8 x 1 useg = 1.136 useg
        		MOVWF       	CONTA       							;  
        		GOTO        		LOOP

TEMPO_SI:
        		MOVLW       	.126           								; 126 x 8 x 1 useg = 1.012,3useg
        		MOVWF       	CONTA       							;  
        		GOTO        		LOOP


; ------- Loops  -------
LOOP:      
        		NOP
        		NOP 
        		NOP 
        		NOP
        		NOP
        		DECFSZ      	CONTA,	 F
        		GOTO        		LOOP

        		RETURN 




		END