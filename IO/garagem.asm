; se tiver o endereco de todas as interrupcoes é interrupcao vetorada (vc sabe quem gerou a interrupcao)
; todas as fontes de interrupcoes vao pra um endereco (nao vetorada)

; nao sao vetoradas a do pic, todas elas vao pro end 4



#INCLUDE P16F628A.INC
#DEFINE LED     PORTA, 0
#DEFINE CH      PORTB, 0
#DEFINE AF      PORTB, 3

; TEM Q SER NA RBO, VAI TER UM CIRCUITO VERIFICANDO SE VAI TER COISADO LA


                ORG         000H
                                ; quero acender o led qnd apertar

                goto        INICIO


                ORG         004H
                BTFSS       INTCON, INTF        ; testa se foi interrupcao externa
                goto        INT_TMR

                
                BCF         LED 
                BCF         INTCON, INTF        ; zera flag de interrup externa
                GOTO        SAI_INT

                ; precisa zerar as flgas p voltar das interrupcoes

INT_TMR:        BCF         INTCON, F0IF        ; zera flag de interrup timer
                NOP
                NOP




SAI_INT:        RETFIE 





INICIO:         BSF         STATUS, RP0         ; BANCO 1 DA MEMORIA
                movlw       '11111110'          ; ra0 como saida
                movwf       TRISA
                movlw       B'11110111'
                movwf       TRISB               ; ra3 como saida
                MOVLW       B'11011111'
                BCF         OPTION_REG       ; configurando interrupcao externa em rb0 por borda de descida
                movlw       B'10100000'                 ; 
                movwf       intcon              ; ativando interrupcao externa em rb0
                BCF         STATUS, RP0         ; volta pro banco 0

                BSF         LED                 ; apaga o led
; pulso de clock = cm
; T = 400,00useg, Meio T, metade alto metade baixo, = 200useg | CM 4/freq do cristal = 1micro
; Timer = (256-(tempo/cm))
; Timer = 256 - (200u/1u) = 256 -200
; Timer = 56

; T = contagem do temporizador X CM
; CM = clock do processador
; colocar no timer um valor q dá 200useg
; quantas contagens o temporizador tem que fazer = T / CM
; 256- 
; tendo o valor final q nesse caso era 56, precisa adicionar +2 q é o tempo para chamar
; a instrucao

; se o valor der negativo significa q vc não vai conseguir bater o tempo

                MOVLW       .56 
                movwf       TMR0

ESPERA:        goto         ESPERA 
               END