global suma2Doubles

section .text

suma2Doubles:

	; Esto es un comentario
	; double suma2Doubles(double a, double b);
	; a-> XMM0
	; b-> XMM1
	
	; Armo stack frame SALVANDO TODOS los registros
		push RBP
		mov RBP, RSP

	
	;CODIGO
		add XMM0, XMM1	; Hago rdi= rdi+rsi
		mov RAX, XMM0	; Devuelvo por RAX
	
	; Desarmo stack frame

		pop rbp
		ret
