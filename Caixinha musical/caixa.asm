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
	; E D# E D# E B D C A C E A B E G# B C

; # Oh Susana
	; C D E G G A G E C D E E D C D C D 

; -------  Processador utilizado -------
#INCLUDE 	P16F628A.INC 


; ------- Inputs e Outputs  -------
#DEFINE		CH_MSC		PORTB, 1							; Chave para selecionar musica
#DEFINE		LED_VM		PORTB, 2							; 
#DEFINE		LED_VD		PORTA, 3							; 
#DEFINE     	AF          		PORTA, 4							;
#DEFINE		CH_INT		PORTB, 0


; ------- Registradores de uso geral  -------
#DEFINE		DESL_LED_VD		BSF		LED_VD
#DEFINE		LIGA_LED_VD		BCF		LED_VD
#DEFINE		DESL_LED_VM		BSF		LED_VM
#DEFINE		LIGA_LED_VM		BCF		LED_VM
#DEFINE		LIGA_AF			BSF		AF
#DEFINE		DESL_AF			BCF		AF


; ------- Bancos de memoria  -------
#DEFINE	    	BANK0      		BCF     	STATUS, RP0				; mnemonico - banco 0		
#DEFINE		BANK1      		BSF     	STATUS, RP0				; mnemonico - banco 1


; ------- Contadores  -------
CONTA       	EQU		 20H


; ------- Variaveis  -------
FLAGS    		EQU           21H
SALVA_W  		EQU           22H
SALVA_S  		EQU           23H


; ------- Definindo origem  -------
		ORG          		000H
;		CLRF    		STATUS
        		GOTO    		INICIO


; ------- Salvando o contexto da interrupcao -------
		ORG        		004H
		BCF        		INTCON,	INTF 						; 

		
            	BTFSS    		INTCON,	INTF 						;TESTA SE FOI INTER EXT
            	GOTO     		INT_TMR

		BCF        		INTCON,	INTF    						;ZERA FLAG DO INT. EXT
            	GOTO    		SAI_INT

;              
	        	MOVWF           	SALVA_W                					 	; Salva o conteudo de w
	        	SWAPF           	STATUS, 	W							 ; Salva o conteudo do status sem alterar a flag z
	        	MOVWF           	SALVA_S							 	; PS: esse valor esta com os nibbles invertidos


; ------- Tratamento da interrupcao -------


SAI_INT:        
		SWAPF    		SALVA_S,W 							; Desinvertendo 
                	MOVWF    		STATUS        							; Recuperei valor do status
                	SWAPF    		SALVA_W,F  							; Invertendo salva_w e salvando em f (para nao afretar nenhuma flag)
                	SWAPF    		SALVA_W,W    							; Reinvertendo e salvabndo em w

                	RETFIE 												; Vai no bit GIE e coloca em 1

INT_TMR:
		NOP

; ------- Principio do programa  -------
INICIO:
        		BANK1                                          							 	; Vai para o Banco 1
        		MOVLW       	B'11100111'                        					 	; Somente RA0 como saida
        		MOVWF       	TRISA                               

       		MOVLW       	B'11111000'
        		MOVWF       	TRISB                              						 ; Somente RB3 como saida

		MOVLW    		B'10010010'								; Int externa por borda de subida, prescaler de 1:4
               	MOVWF    		OPTION_REG

                	MOVLW    		B'00000000'
                	MOVWF    		INTCON

        		BANK0                                          								; Volta para o Banco 0

       		DESL_AF                                        						 	; Desliga o Auto Falante

; ------- Subrotinas  -------

TESTA_CHAVE:													; Testa chave da musica
		BTFSC       		CH_MSC                               						; 
        		GOTO        		FUR_ELISE                              					; 1 - Toca Fur Elise
		GOTO		SUSANA									; 0 - Toca musica estranha dos EUA
		
FUR_ELISE:
		LIGA_LED_VD											; Liga led verde
		CALL			GERA_MI
		CALL			GERA_RES
		CALL			GERA_MI
		CALL			GERA_RES
		CALL			GERA_MI
		CALL			GERA_SI
		CALL			GERA_RE
		CALL			GERA_DO
		CALL			GERA_LA
		CALL			GERA_DO
		CALL			GERA_MI
		CALL			GERA_LA
		CALL			GERA_SI
		CALL			GERA_MI
		CALL			GERA_SOLS
		CALL			GERA_SI
		CALL			GERA_DO
		DESL_LED_VD	
		GOTO		TESTA_CHAVE
		
SUSANA:
		LIGA_LED_VM
		CALL			GERA_DO
		CALL			GERA_RE
		CALL			GERA_MI
		CALL			GERA_SOL
		CALL			GERA_SOL
		CALL			GERA_LA
		CALL			GERA_SOL
		CALL			GERA_MI
		CALL			GERA_DO
		CALL			GERA_RE
		CALL			GERA_MI
		CALL			GERA_MI
		CALL			GERA_RE
		CALL			GERA_DO
		CALL			GERA_RE
		CALL			GERA_DO
		CALL			GERA_RE
		DESL_LED_VM
		GOTO		TESTA_CHAVE


; # Nota Do> C = 261,63Hz -> T = 3,82 mseg | T/2 = 1,911mseg = 1.911 useg #
GERA_DO:    
        		LIGA_AF                                         							; Ligar o auto falante
        		CALL        		TEMPO_DO                            					; Tocar a nota pelo tempo determinado do Do
        		DESL_AF                                         							; Desligar o auto falante
        		CALL        		TEMPO_DO                            					; Esperar o tempo da nota
		RETURN
	
; # Nota Re> D = 293,66hz -> T = 3.45 mseg -> T/2 = 1,702mseg = 1.702,5useg #
GERA_RE:    
        		LIGA_AF                                         						; Ligar auto falante
        		CALL        		TEMPO_RE                            				; Tocar a nota pelo tempo determinado do Re
        		DESL_AF                                        						; Desliga o auto falante
        		CALL        		TEMPO_RE                            				; Esperar o tempo da nota
		RETURN

; # Nota Re#> D# = 311,13 Hz -> T = 3,214 mseg / T/2 = 1,607 mseg = 1.607 useg
GERA_RES:    
        		LIGA_AF                                         						; Ligar auto falante
        		CALL        		TEMPO_RES                            				; Tocar a nota pelo tempo determinado do Re
        		DESL_AF                                        						; Desliga o auto falante
        		CALL        		TEMPO_RES                            				; Esperar o tempo da nota
		RETURN

; # Nota Mi> E = 329,63Hz -> T = 3,0337 mseg -> t/2 = 1,516 mseg = 1.516,85 useg
GERA_MI:    
       		 LIGA_AF                                         						; Liga auto falante
        		CALL        		TEMPO_MI                            				; Toca a nota pelo tempo do Mi
       		 DESL_AF                                         						; Desliga auto falante
        		CALL        		TEMPO_MI                            				; 
		RETURN

; Nota Sol> G = 392Hz -> T =  2,551mseg -> t/2 = 1,2755 mseg = 1.275,5 useg
GERA_SOL:   
        		LIGA_AF		                    							 ; liga auto falante
        		CALL       		TEMPO_SOL                  
        		DESL_AF		                  							; desliga auto falante
       		CALL        		TEMPO_SOL
		RETURN

; Nota SolS>  G# = 415,3 Hz -> T = 2,407 mseg / T/2 = 1,2035 mseg = 1.203,5 useg
GERA_SOLS:   
        		LIGA_AF   		                     							 ; liga auto falante
        		CALL       		TEMPO_SOLS                  
        		DESL_AF		                     							; desliga auto falante
       		CALL        		TEMPO_SOLS
		RETURN

; Nota La> A = 440Hz -> T =  2,273mseg -> t/2 = 1,1365 mseg = 1.136,5 useg
GERA_LA:    
        		LIGA_AF		                      							; liga auto falante
        		CALL        		TEMPO_LA                  
        		DESL_AF		                     							; desliga auto falante
       		CALL        		TEMPO_LA
		RETURN

; Nota Si> B = 493,88 Hz -> T = 2,0247 mseg / T/2 = 1,0123 mseg = 1.012,35useg

GERA_SI:    
        		LIGA_AF		                      							; liga auto falante
        		CALL        		TEMPO_SI                  
        		DESL_AF		                     							; desliga auto falante
       		CALL        		TEMPO_SI
		RETURN

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