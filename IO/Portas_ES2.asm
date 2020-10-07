#INCLUDE P16F628A.INC 

 ; cistal de 4MHZ -> CM = 4/Fcristal; 4/4MH = 1us
; entradas ra0, ra1, ra2
; saidas, rb3, rb4, rb5
CONTA1     EQU 20H
CONTA2            EQU 21H     


            ORG         000H

            BSRF        STATUS, RP0         ; muda para o banco 1
            MOVLW       0FFH
            MOVWF       TRISA
            MOVLW       B'11000111'         ; Rb3 e rb4 e rb5 como saidas
            MOVWF       TRISB
            BCF         STATUS, RP0         ; muda para o banco 0

            BSF        PORTB, 3            ; Led inicialmente apagado
            BSF        PORTB, 4            ; Led inicialmente apagado
            BCF        PORTB, 5             ; Desliga af (caixa de som)

LE_CH1:      BTFSC      PORTA, 0             ; Chave 1 foi preciosanada?
            GOTO        LE_CH2

            MOVLW       B'00001000'         ; Mascara para inverter o bit 3
            XORWF       PORTB, F         ; Inverte o estado do led

            CALL        LP_150MS          ; Espera acabar a trepidação

            GOTO        LE_CH
            
LE_CH2:      BTFSC       PORTA, 1             ; Chave 2 foi preciosanada?
            GOTO        LE_CH3

            MOVLW       B'00010000'         ; Mascara para inverter o bit 3
            XORWF       PORTB, F         ; Inverte o estado do led

            CALL        LP_150MS          ; Espera acabar a trepidação

LE_CH3:      BTFSC       PORTA, 2             ; Chave 3 foi preciosanada?
            GOTO        LE_CH1

SOM:        BSF        PORTB, 5             ; Ativa alto-falantes
            CALL        LP_333US            ; aguardando metade do periodo
            BCF         PORTB, 5            ; Desativa do auto
            CALL        LP_333US

            BTFSS       PORTA, 2
            GOTO        SOM

            GOTO        LE_CH1

LP_150MS:   MOVLW       .150
            MOVWF       CONTA2
LP_1MS:     MOVLW       .250
            MOVWF       CONTA1
LOOP:       NOP                         ; tempo = 4 x K x CM
            DECFSZ      CONTA1, F       ; K = 1000/(4 x CM) = 1000/4 = 250
            GOTO        LOOP

            DECFSZ      CONTA2, F
            GOTO        LP_1MS
            RETURN  
; calculo de tempo do auto falante, precisa ficar oscilando entre alto e baixo
; 1,5KHZ -> T = 0.6666667 mseg, g=666,67useg -> nesse caso precisa estar em micro
; t/2 = 333,33 useg

LP_333US:   
            MOVLW       .109
            MOVWF       CONTA1
LOOP1:      DECFSZ      CONTA1, F 
            GOTO        LOOP1
            NOP
            RETURN


; tempo = 3 x K x CM 
; K = 1000/(4 x CM) = 1000/4 = 250
            END