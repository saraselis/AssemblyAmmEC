#INCLUDE P16F628A.INC
; Y = 11X + 22

; Para calcular 11X, desmembramos a constante em potencias de 2: 11X = (8 + 2 + 1)X = 8X + 2X + X
; Cada deslocamento para a esquerda (operacao SHIFT LEFT) resulta em uma multiplicacao por 2
; Como o PIC16F628A nao possui instrucao SHIFT LEFT, ela eh "simulada" por uma operacao de rotacao a esquerda com a flag C
; Deve-se utilizar a instrucao BCF zerando a flag C antes da instrucao RLF para garantir que sera inserido um bit 0 na rotacao

; Para ser possivel realizar o calculo desse polinomio, o resultado deve ser menor ou igual a 255
; Entao: 11X + 22 <= 255 -> 11X <= 233 -> X <= 21,18
; Como so estamos operando com numeros inteiros: X <= 21

; O teste de maior, maior ou igual, menor e menor ou igual eh feito por meio de uma operacao de subtracao
; A - B		. Se A > B, flag C = 1 e flag Z = 0
;			. Se A = B, flag C = 1 e flag Z = 1
;			. Se A < B, flag C = 0 e flag Z = 0
; Entao, pela flag C = 1 sabemos que A >= B, e com C = 0 sabemos que A < B
; Invertendo a operacao de subtracao:
; B - A		. Se A > B, flag C = 0 e flag Z = 0
;			. Se A = B, flag C = 1 e flag Z = 1
;			. Se A < B, flag C = 1 e flag Z = 0
; Entao, pela flag C = 1 sabemos que A <= B, e com C = 0 sabemos que A > B

; Como queremos saber se X <= 21, basta fazer 21 - X e testar se C = 1

X	EQU	20H		; Define X como sendo a posicao de memoria 20H
Y	EQU	21H		; Define Y como sendo a posicao de memoria 21H

		ORG		000H

		MOVFW	X		; Transfere X p/ W
		SUBLW	.21		; Efetua 21 - X
		BTFSS	STATUS,C ; Testa se flag C = 1 (X <= 21)
		GOTO	FIM		; Se nao for, encerra o calculo

		BCF		STATUS,C ; Zera a flag C antes da instrucao RLF
		MOVFW	X		; W = X
		RLF		X,F		; Multiplica X por 2 -> 2X
		ADDWF	X,W		; Soma com W: W = X + 2X = 3X
		RLF		X,F		; 4X
		RLF		X,F		; 8X
		ADDWF	X,W		; Soma com W: W = 3X + 8X = 11X
		ADDLW	.22		; Soma resultado com a constante 22
		MOVWF	Y		; Salva o resultado final em Y: Y = 11X + 22

FIM:	GOTO	FIM		

		END
