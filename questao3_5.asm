#INCLUDE P16F628A.INC

; Crie um programa que verifique se a posição de memória 25H possui um valor diferente de 0. Se isso for
; verdade, some o conteúdo dessa posição com a constante 37 e salve o resultado na posição 26H. Caso
; contrário, zere o conteúdo da posição 26H.

VALOR1 	EQU	 	25H		; Dando nomes para as variaveis
VALOR2	EQU 	26H
		ORG		00H

		CLRF 	VALOR2 	; Zera o conteúdo da posição indicada por f

		MOVF 	VALOR1, F	; Move o conteúdo da posição indicada por x para o destino y	 
		
		BTFSC	STATUS, Z	; Testa se o bit f (posição de memória) e b (posição do bit) é igual a 0
							; Se True, pula uma instrução
		
		GOTO 	FIM			; O Bit f é 0 e se encerra o programa, pois o valor2 já está limpo
							; Caso o bit f seja diferente de 0, ele pula a instrução anterior

		MOVFW  	VALOR1		; Vai movero conteudo da posição F para W;

		ADDLW	.37			; Somando o que está em W + a constante 37

		MOVWF	VALOR2		; Move o conteúdo da posição de W para posição de F 26H e encerra o programa

FIM: 	GOTO	FIM

		END
