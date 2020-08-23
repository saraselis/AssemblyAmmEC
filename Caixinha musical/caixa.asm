; ------- Descricao do problema  -------
; | RA0 -> LED       | RA1 -> Chave fa | RA2 -> chave sol | RB0 -> chave dó |
; | RB1 -> chave fá  | RB2 -> chave ré | RB3 -> AF        | RB4 -> Chave lá |

; -------  Processador utilizado -------
#INCLUDE P16F628A.INC 

; ------- Inputs e Outputs  -------
#DEFINE     	CH_DO       	PORTB, 0
#DEFINE     	CH_RE       		PORTB, 1
#DEFINE     	CH_MI       	PORTB, 2
#DEFINE     	CH_FA       		PORTA, 1
#DEFINE     	CH_SOL      	PORTA, 2
#DEFINE     	CH_LA      		PORTA, 4
#DEFINE     	LED         		PORTA, 0
#DEFINE     	AF          		PORTB, 3


; ------- Registradores de uso geral  -------
#DEFINE		DESL_LED		BSF		LED
#DEFINE		LIGA_LED		BCF		LED
#DEFINE		LIGA_AF		BSF		AF
#DEFINE		DESL_AF		BCF		AF

; ------- Bancos de memoria  -------
#DEFINE	    	BANK0      		BCF     	STATUS, RP0				; mnemonico - banco 0		
#DEFINE		BANK1      		BSF     	STATUS, RP0				; mnemonico - banco 1

; ------- Variaveis  -------
#DEFINE     	LIGA_LED    	BCF     	LED 
#DEFINE     	DESL_LED    	BSF     	LED 
#DEFINE     	DESL_AF     	BCF     	AF
#DEFINE     	LIGA_AF     	BSF     	AF
	

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
        		MOVLW       	B'11111110'                        					 ; Somente RA0 como saida
        		MOVWF       	TRISA                               

       		MOVLW       	B'11110111'
        		MOVWF       	TRISB                              					 ; Somente RB3 como saida
        		BANK0                                          							 ; Volta para o Banco 0

        		DESL_LED                                       						 ; Desliga o LED
       		DESL_AF                                        						 ; Desliga o Auto Falante

; ------- Subrotinas  -------

; # Nota Do> Do = 261,63Hz -> T = 3,82 mseg | T/2 = 1,911mseg = 1.911 useg #
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


; # Nota Re> Re = 293,66hz -> T = 3.45 mseg -> T/2 = 1,7025mseg = 1.702,5
TESTA_RE:     
        		BTFSC       		CH_RE                               					; A Chave do Re foi acionada?
        		GOTO        		TESTA_MI                            				; 1 - Testa a chave do mi
        
        		LIGA_LED                                       			 			; 0 - Acende led

GERA_RE:    
        		LIGA_AF                                         						; Ligar auto falante
        		CALL        		TEMPO_RE                            				; Tocar a nota pelo tempo determinado do Re
        		DESL_AF                                        						; Desliga o auto falante
        		CALL        		TEMPO_RE                            				; Esperar o tempo da nota

        		BTFSS       		CH_RE                               					; A chave foi solta?
        		GOTO        		GERA_RE                             					; 0 - Gerar a nota novamente
       		LIGA_LED                                        						; 1 - Liga o led


; # Nota Mi> Mi = 329,63Hz -> T = 3,0337 mseg -> t/2 = 1,516 mseg = 1.516,85 useg
TESTA_MI:     
        		BTFSC       		CH_MI                               					; A Chave do Mi foi pressionada?
        		GOTO        		TST_FA                              					; 1 - Testa a chave do Fa

        		LIGA_LED                                        						; 0 - Liga o led

GERA_MI:    
       		 LIGA_AF                                         						; Liga auto falante
        		CALL        		TEMPO_MI                            				; Toca a nota pelo tempo do Mi
       		 DESL_AF                                         						; Desliga auto falante
        		CALL        		TEMPO_MI                            				; 

       		BTFSS       		CH_MI                   						; chave do foi solta?
        		GOTO        		GERA_MI                
        		BCF         		LED                     						;apaga o led


; # Nota Fa> Fa = 349,23Hz -> T = 2,863 mseg -> t/2 = 1,14431mseg = 1.431,5 useg
TST_FA:     
        		BTFSC       		CH_FA                  						 ; Chave do re acionada?????
        		GOTO        		TST_SOL

       	 	BCF         		LED                    							 ; Acende led
GERA_FA:    
        		BSF         		AF                     							 ; liga auto falante
        		CALL        		T2_FA                  
        		BCF        		AF                     							 ; desliga auto falante
        		CALL        		T2_FA

        		BTFSS       		CH_FA                  						 ; chave do foi solta?
        		GOTO        		GERA_FA                
        		BCF         		LED                     						;apaga o led



; Nota Sol> Sol = 392Hz -> T =  2,551mseg -> t/2 = 1,2755 mseg = 1.275,5 useg
TST_SOL:    
        		BTFSC       		CH_FA                  						 ; Chave do re acionada?????
        		GOTO        		TST_LA
        
        		BCF        		 LED                    						 ; Acende led

GERA_SOL:   
        		BSF         		AF                     							 ; liga auto falante
        		CALL       		T2_SOL                  
        		BCF         		AF                     							; desliga auto falante
       		CALL        		T2_SOL

        		BTFSS       		CH_SOL                   						; chave do foi solta?
        		GOTO        		GERA_SOL                
       		 BCF         		LED                     						; apaga o led


; Nota La> La = 440Hz -> T =  2,273mseg -> t/2 = 1,1365 mseg = 1.136,5 useg
TST_LA:     
        		BTFSC       		CH_LA                  						; Chave do re acionada?????
        		GOTO        		TESTA_DO				
                            
        		BCF         		LED                     						; Acende led

GERA_LA:    
        		BSF         		AF                      							; liga auto falante
        		CALL        		T2_LA                  
        		BCF         		AF                     							; desliga auto falante
       		 CALL        		T2_LA

        		BTFSS       		CH_LA                  						 ; chave do foi solta?
        		GOTO        		GERA_LA                
       		BCF         		LED                     						;apaga o led

        		GOTO        		TESTA_DO


; ---- subrotinas
TEMPO_DO:      
        		MOVLW      	 .238           							; 238 x 8 x CM(1) = 1.904 [que é o valor total do dó]
        		MOVWF       	CONTA           							; 1cm = 1 micro segundo
        		GOTO        		LOOP1

TEMPO_RE:      
        		MOVLW       	.212        								; 1702
        		MOVWF       	CONTA      								; 212 x 8 x CM(1) = 1696
        		GOTO        		LOOP1

TEMPO_MI:      
        		MOVLW      	.189           								; 189 x 8 x CM = 1.512
        		MOVWF       	CONTA      								;  x 8 x CM(1) =  
        		GOTO        		LOOP1

T2_FA:      
        		MOVLW      	 .189           							; 189 x 6 x CM = 1.512
        		MOVWF       	CONTA       							;  x 8 x CM(1) =  
        		GOTO        		LOOP2

T2_SOL:     
        		MOVLW       	.212           								; 212 x 6 x CM = 1.272
        		MOVWF       	CONTA       							;  x 8 x CM(1) =  
        		GOTO        		LOOP2

T2_LA:      
        		MOVLW       	.189           								; 189 x 6 x CM = 1.134
        		MOVWF       	CONTA       							;  x 8 x CM(1) =  
        		GOTO        		LOOP2

LOOP1:      
        		NOP
        		NOP 
        		NOP 
        		NOP
        		NOP
        		DECFSZ      	CONTA,	 F
        		GOTO        		LOOP1
        		RETURN 

; ------- Loops  -------
LOOP2:      
       		NOP
        		NOP 
        		NOP 
        		NOP
        		NOP
        		DECFSZ      	CONTA,	 F
        		GOTO       		 LOOP2
        		RETURN 
