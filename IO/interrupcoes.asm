; se tiver o endereco de todas as interrupcoes é interrupcao vetorada (vc sabe quem gerou a interrupcao)
; todas as fontes de interrupcoes vao pra um endereco (nao vetorada)

; nao sao vetoradas a do pic, todas elas vao pro end 4

#INCLUDE P16F628A.INC 

#DEFINE SENSOR      PORTB, 0      ; a interrupcao só rola na porta b
#DEFINE LED1    PORTA, 0
#DEFINE LED2    PORTA, 1                ; monitora as portas simultaneamente
#DEFINE AF      PORTB, 3

FLAGS    EQU     20H
CONTA1   EQU     21H
CONTA2   EQU            22H
CONTA3   EQU     23H

SALVA_W  EQU            24H

SALVA_S  EQU            25H

; ra5 só funciona como entrada

        ORG         000H

        


        CLRF            FLAGS                  ; zerando ela p n ter merda
        GOTO        INICIO
        ORG         004H

        MOVWF           SALVA_w                 ; salva o conteudo de w
        SWAPF           STATUS, W               ; salva o conteudo do status sem alterar a flag z

        MOVWF           SALVA_S                 ; (esse valor esta com os nibbles invertidos)
; tratamento da interrupcao
        BTFSS           INTCON, INTF            ; interrupcao externa?

        goto            INT_TMR

        BSF             FLAGS, 0                ; indica q o carro passou pelo sensor
        BSF             FLAGS, 1                ; habilita a geracao do sinal sonoro
        MOVLW           .30
        MOVWF           TEMPO15
        
        BCF             INTCON, INF             ; precisa sempre zerar o bit que gerou a interrupcao externa
        ; se n foi a interrpcao externa sabemos q foi a interna, entao ja vamos para a int interna

        GOTO          FIMINT

INT_TMR: 
        BCF     INTCON, T0IF                    ; zera flag de interrupcao do timer 0
        BTFSS   FLAGS, 1
        GOTO    ZERA_AF

        movlw   .100
        movwf   tmr0                            ; recarrega o timer 0 para interrupcao a 500 useg


        MOVLW   B'00001000'
        XOR     PORTB, F                      ; inverte o bitche o alto falante
        goto    FIMINT

ZERA_AF: BCF    AF
         
FIMINT: 
        swapf   SALVA_S, W              ; agora desinverto o valor dos nibbles, recupera o valor do status
        MOVWF   STATUS                  ; recupera o valor do Status
        SWAPF    SALVA_W, F         
        SWAPF   SALVA_W, W              ; recupera o valor de status
        RETFIE 
; configuracao do pix
INICIO:        BSF         STATUS, RP0             ; bando 1 da ram
        MOVLW       B'11111100'             ; ra0 e ra1 como saídas
        MOVWF       TRISA   
        MOVLW       B'11110111'             ; rb3 como saida
        MOVWF       TRISB   
        
        movlw       B'10000001'             ; 0 saida, 1 entrada
        MOVWF       OPTION_REG                  ; sem resistores pull-up, borda de descida, modo temporizador
                                                ; 
        MOVLW           B'10110000'
                                                ; modo temporizador, prescaler com taxa 1:4
         
         
        movwf           INTCON                   ; int ext em rb0 e int do timer 0                   ; esta em todos os bancos
        ; 
        BCF         STATUS, RP0                 ; anotar certinho oq faz cada um dos bits ali
        ; CLRF        FLAGS 

; leds piscando a 0,5hz -> t = 1/f = 2 seg
; 16, 66 metros em 1 seg
PISCA1:  BCF         LED1                    ; led 1 acesso (logica esta inversa)
        BSF         LED2                    ; led 2 apagado

        CALL        LP_1SEG

        BSF         LED1                    ; led 1 apagado 
        BCF         LED2                    ; led 1 acesso

        CALL        LP_1SEG
        

        BTFSS           FLAGS, 0                ; testando o bit zero da flag, se tiver em 1 o carro passou

        goto        PISCA1                      ; agr q o carro passou vamos mudar de meio hertz para 4 hertz

; leds piscando a 4hz -> t = 1/f = 0,5 seg
PISCA2:  BCF         LED1                    ; led 1 acesso (logica esta inversa)
        BSF         LED2                    ; led 2 apagado

        CALL        LP_250MS

        BSF         LED1                    ; led 1 apagado 
        BCF         LED2                    ; led 1 acesso

        CALL        LP_250MS
        DECFSZ          TEMPO15, F              ; Decrementa temporizador de 15s

        goto        PISCA2                      ; decrementa o temporizador de 15s

        BCF             FLAGS, 0
        BCF             FLAGS, 1

        goto            PISCA1

        ; se usar o prescaler precisa ajustar a formula, e ajustar a formula para o pre
        ; scaler q vc quiser, nesse caso, irá incrementar 1 no contador a cada
        ; 4 ciclos de maquina
LP_1SEG:        MOVLW           .4
                MOVWF           CONTA3
                CALL            LP_250MS
                DECFSZ          CONTA3, F
                GOTO            TMP_250
                return 
LP_250MS:       movlw           .250             ; 250 x 1mseg = 250mseg
                movwf           CONTA2

                
LP_1MS:         MOVLW           .250             ; 250 x 5 x 0,8useg = 1000useg
                MOVWF           CONTA1    
                       


LOOP:   NOP
        NOP
        DECFSZ          CONTA1, F
        GOTO            LOOP

        DECFSZ          CONTA2, F
        GOTO            LP_1MS

        RETURN
