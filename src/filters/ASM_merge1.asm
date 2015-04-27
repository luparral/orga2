; ************************************************************************* ;
; Organizacion del Computador II                                            ;
;                                                                           ;
;   Implementacion de la funcion Merge 1                                    ;
;                                                                           ;
; ************************************************************************* ;

;cvtsi2ss

;section .rodata
;	_value: byte value, value, value, value
;	_1menosValue: byte 1-value, 1-value, 1-value, 1-value

; void ASM_merge1(uint32_t w, uint32_t h, uint8_t* data1, uint8_t* data2, float value)
global ASM_merge1
ASM_merge1:
	push rbp
	mov rbp, rsp
	;rdi = w 
	;rsi = h
	;rdx = data1
	;rcx = data2
	;xmm0 = value

	mov r12, rdi ; r12 = w
	mov r13, rdi ; r13 = h
	mov r14, rdx ; r14 = data1
	mov r15, rcx ; r15 = data2
	;xmm0 sigue siendo value

	;calculo el tamaño del vector
	mov eax, r12d
	mov ebx, r13d
	mul ebx ; ebx*eax -> res = p.a en edx - p.b en eax
	xor r13, r13
	mov dw r13, edx
	shl r13, 4
	mov dw r13, eax 

	;en r13 tengo r12 * r13
	;r12(w)*r13(h)*4 /16 = (w*h)/4
	;cada vez que shifeas dividis por 2
	mov rcx, r13
	shr rcx, 2 ; divido por 4
	;en rcx ya tengo la cantidad de iteraciones

	;tengo que hacer un ciclo de rcx iteraciones en el que en cada uno, me traigo todos los pixeles que pueda y los pongo en xmm0 los de data 1 y en xmm1 los de data2

	;aca hay que ver como es toda la movida de dar vuelta los registros y toda la bola

	mov xmm0, r14 ; [P_a_1 | P_a_2 | P_a_3 | P_a_4]
	mov xmm1, r15 ; [P_b_1 | P_b_2 | P_b_3 | P_b_4]

	;ahora tengo que recorrer byte por byte 
	;para cada byte tengo que hacer la puta cuenta:

	;m1[ih][iw][ii] = (uint8_t)(value * ((float)m1[ih][iw][ii]) + (1.0-value) * ((float)m2[ih][iw][ii]));

	;podria tratar de multiplicar todos los de m1 con value y todos los de m2 con (1.0-value) y luego sumar los dos vectores y guardar el res en m1

	.ciclo
		pxor xmm7, xmm7
		

		loop .ciclo	






	push rbp
  	ret