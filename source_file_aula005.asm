
 list		p=16f84A							; microcontrolador utilizado PIC16F84A
  
  
; --- Arquivos incluídos no projeto ---
 #include <p16f84a.inc>							; inclui o arquivo do PIC16F84A  
  
  
; --- FUSE Bits ---
; Cristal oscilador externo 4MHz, sem watchdog timer, com power up timer, sem proteção do código
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF
	

; --- Paginação de Memória ---
 #define		bank0		bcf	STATUS,RP0		;Cria um mnemônico para o banco 0 de memória
 #define		bank1		bsf STATUS,RP0		;Cria um mnemônico para o banco 1 de memória
 

; --- Entradas ---
 #define		botao1		PORTB,RB0			;botão 1 ligado em RB0
 #define		botao2		PORTB,RB2			;botao 2 ligado em rb2
 
 
; --- Saídas ---
 #define		led1		PORTB,RB1			;LED 1 ligado em RB1
 #define		led2		PORTB,RB3			;LED 2 ligado em RB3
                       
                             
; --- Vetor de RESET ---
				org			H'0000'				;Origem no endereço 0000h de memória
				goto		inicio				;Desvia do vetor de interrupção
				
; --- Vetor de Interrupção ---
				org			H'0004'				;Todas as interrupções apontam para este endereço
				retfie							;Retorna de interrupção
				

; --- Programa Principal ---				
inicio:
				bank1							;seleciona o banco 1 de memória
				movlw		H'FF'				;W = B'11111111'
				movwf		TRISA				;TRISA = H'FF' (todos os bits são entrada)
				movlw		H'F5'				;W = B'1111 0101'
				movwf		TRISB				;TRISB = H'F5' Configura rb1 e rb3 como saida
				bank0							;seleciona o banco 0 de memória (padrão do RESET)
				movlw		H'F5'				;W = B'1111 0101'
				movwf		PORTB				;LEDs irao começar desligados
				
				;goto		$					;Segura o código nesta linha

loop:			
				call		check_but1			;Chama subrotina do but1
				call		check_but2			;Chama subrotina do but2
				goto		loop				;votamos para o loop

; ------ Subrotinas ------
check_but1:										;subrotina para o botao1
				btfsc		botao1				;testa se o botao está em zero, se estiver pula a prox instrucao
				goto		apaga_led1			;Nao, desvia dessa label, Sim, ele passa nela e apaga o led
				bsf			led1				;Liga o led um
				return							;retorna/sai da subrotina
			
apaga_led1:
				bcf			led1				;apaga led 1
				return							;sai dessa rotina quando o led esta apagado

check_but2:										;subrotina para o botao2
				btfsc		botao2				;testa se o botao está em zero, se estiver pula a prox instrucao
				goto		apaga_led2			;Nao, desvia dessa label, Sim, ele passa nela e apaga o led
				bsf			led2				;Liga o led um
				return							;retorna/sai da subrotina
			
apaga_led2:
				bcf			led2				;apaga led 1
				return							;sai dessa rotina quando o led esta apagado

				end								;Final do programa

;subrotinas e parecidos com funcoes, blocos de codigos que rodam quando sao 