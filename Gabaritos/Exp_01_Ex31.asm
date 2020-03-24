#INCLUDE P16F628A.INC

; MOVLW -> Carrega uma constante no registrador W (Work Register)
; MOVWF -> Escreve o valor de W em uma posicao de memoria (escrita na memoria)
; MOVFW -> Transfere o conteudo de uma posicao de memoria para W (leitura da memoria)

		ORG		000H	; Diretiva para o compilador indicando a partir de qual posicao
						; da memoria de programa o codigo escrito devera ser colocado
		
		MOVLW	3AH		; Carrega W com a constante 3AH
		MOVWF	25H		; Transfere o valor de W para a posicao de memoria 25H
		MOVLW	.45		; Carrega W com a constante decimal 45 (2DH em hexadecimal)
		MOVWF	26H		; Transfere o valor de W para a posicao 26H
		
		MOVFW	27H		; Transfere o conteudo da posicao de memoria 27H para W
		MOVWF	30H		; Transfere o valor de W para a posicao 30H

FIM:	GOTO	FIM

		END				; Diretiva para o compilador indicando o final do programa