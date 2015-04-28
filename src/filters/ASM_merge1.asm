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

	mov r12d, edi ; r12 = w
	mov r13d, esi ; r13 = h
	mov r14, rdx ; r14 = data1
	mov r15, rcx ; r15 = data2
	;xmm0 sigue siendo value

	;registro xmm15 =  [value|value|value|value] para multiplicar
	pxor xmm15, xmm15
	movq xmm15, xmm0
	pslldq xmm15, 4
	movq xmm15, xmm0
	pslldq xmm15, 4
	movq xmm15, xmm0
	pslldq xmm15, 4
	movq xmm15, xmm0
	
	; xmm0 = 1 - value
	pxor xmm1, xmm1
	mov byte xmm1, 1
	subsd xmm1, xmm0
	movq xmm0, xmm1
	 
	;registro xmm14 = [1-value|1-value|1-value|1-value] para multiplicar
	pxor xmm14, xmm14
	movq xmm14, xmm0
	pslldq xmm14, 4
	movq xmm14, xmm0
	pslldq xmm14, 4
	movq xmm14, xmm0
	pslldq xmm14, 4
	movq xmm14, xmm0

	;calculo el tamanio del vector
	mov eax, r12d
	mov ebx, r13d
	mul ebx ; ebx*eax -> res = p.a en edx - p.b en eax
	xor r13, r13
	mov r13d, edx
	shl r13, 4
	mov r13d, eax 

	;en r13 tengo r12 * r13
	;r12(w)*r13(h)*4 /16 = (w*h)/4
	;cada vez que shifeas dividis por 2
	mov rcx, r13
	shr rcx, 2 ; divido por 4
	;en rcx ya tengo la cantidad de iteraciones

	;tengo que hacer un ciclo de rcx iteraciones en el que en cada uno, me traigo todos los pixeles que pueda y los pongo en xmm0 los de data 1 y en xmm1 los de data2

	;m1[ih][iw][ii] = (uint8_t)(value * ((float)m1[ih][iw][ii]) + (1.0-value) * ((float)m2[ih][iw][ii]));

	.ciclo
		cmp rcx, 0
		je .terminarMerge
		movq xmm0, r14 ; [P_a_1 | P_a_2 | P_a_3 | P_a_4]
		movq xmm1, r15 ; [P_b_1 | P_b_2 | P_b_3 | P_b_4]
		pxor xmm7, xmm7

		movdqu xmm10, xmm0 ;copio xmm0 en xmm10 para no arruinar xmm0 porque en este devuelvo

		movdqu xmm2, xmm10 ;copio xmm0
		punpcklbw xmm10, xmm7 ;0|P2a|0|P2b|0|P2c|0|P2d|0|P3a|0|P3b|0|P3c|0|P3d  L
		punpckhbw xmm2, xmm7 ;0|P0a|0|P0b|0|P0c|0|P0d|0|P1a|0|P1b|0|P1c|0|P1d  H

		;ahora tengo que desempaquetar una vez mas de word a double word

		pxor xmm7, xmm7
		movdqu xmm3, xmm10
		punpcklwd xmm10, xmm7 ;0|0|0|P3a|0|0|0|P3b|0|0|0|P3c|0|0|0|P3d  L
		punpckhwd xmm3, xmm7 ;0|0|0|P2a|0|0|0|P2b|0|0|0|P2c|0|0|0|P2d  H

		pxor xmm7, xmm7
		movdqu xmm4, xmm2
		punpcklwd xmm2, xmm7 ;0|0|0|P1a|0|0|0|P1b|0|0|0|P1c|0|0|0|P1d  L
		punpckhwd xmm4, xmm7 ;0|0|0|P0a|0|0|0|P0b|0|0|0|P0c|0|0|0|P0d  H

		cvtdq2ps xmm5, xmm10 ;convert packed dword int to packed double FP
		cvtdq2ps xmm6, xmm3
		cvtdq2ps xmm7, xmm2
		cvtdq2ps xmm8, xmm4

		mulps xmm5, xmm15
		mulps xmm6, xmm15
		mulps xmm7, xmm15
		mulps xmm8, xmm15

		; ahora desempaqueto xmm1

		pxor xmm7, xmm7
		movdqu xmm2, xmm1 ;copio xmm1
		punpcklbw xmm1, xmm7 ;0|Pp2a|0|Pp2b|0|Pp2c|0|Pp2d|0|Pp3a|0|Pp3b|0|Pp3c|0|Pp3d  L
		punpckhbw xmm2, xmm7 ;0|Pp0a|0|Pp0b|0|Pp0c|0|Pp0d|0|Pp1a|0|Pp1b|0|Pp1c|0|Pp1d  H

		;ahora tengo que desempaquetar una vez mas de word a double word

		pxor xmm7, xmm7
		movdqu xmm3, xmm1
		punpcklwd xmm1, xmm7 ;0|0|0|Pp3a|0|0|0|Pp3b|0|0|0|Pp3c|0|0|0|Pp3d  L
		punpckhwd xmm3, xmm7 ;0|0|0|Pp2a|0|0|0|Pp2b|0|0|0|Pp2c|0|0|0|Pp2d  H

		pxor xmm7, xmm7
		movdqu xmm4, xmm2
		punpcklwd xmm2, xmm7 ;0|0|0|Pp1a|0|0|0|Pp1b|0|0|0|Pp1c|0|0|0|Pp1d  L
		punpckhwd xmm4, xmm7 ;0|0|0|Pp0a|0|0|0|Pp0b|0|0|0|Pp0c|0|0|0|Pp0d  H

		;convierto de int a float

		cvtdq2ps xmm9, xmm1 ;convert packed dword int to packed double FP
		cvtdq2ps xmm10, xmm3
		cvtdq2ps xmm11, xmm2
		cvtdq2ps xmm12, xmm4


		;multiplico

		mulps xmm9, xmm14
		mulps xmm10, xmm14
		mulps xmm11, xmm14
		mulps xmm12, xmm14

		;sumo con el registro analogo de xmm0

		addps xmm5, xmm9
		addps xmm6, xmm10
		addps xmm7, xmm11
		addps xmm8, xmm12

		;convierto nuevamente a int
		CVTPS2DQ xmm5, xmm5
		CVTPS2DQ xmm6, xmm6
		CVTPS2DQ xmm7, xmm7
		CVTPS2DQ xmm8, xmm8

		packusdw xmm5, xmm6
		packusdw xmm7, xmm8

		packuswb xmm5, xmm7

		movups xmm0, xmm5 ;pongo el resultado en xmm0, es decir, voy pisando data1 

		add r14, 16 ;me muevo en xmm0 (data1)
		add r15, 16 ;me muevo en xmm1 (data1)
		sub rcx, 1
		jmp .ciclo

	.terminarMerge
		push rbp
  		ret