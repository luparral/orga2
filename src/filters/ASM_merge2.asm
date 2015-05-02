; ************************************************************************* ;
; Organizacion del Computador II                                            ;
;                                                                           ;
;   Implementacion de la funcion Merge 2                                    ;
;                                                                           ;
; ************************************************************************* ;
section .rodata
	uno: dd 1.0
	dosCincoSeis: dd 32768.0

;multiplico value * un millon ;se puede multiplicar con instruccion de float *256 // 1024 mas precision
;paso a int
;multiplico por el pixeles
;divido el resultado por un millon para cada pixel *shift de 8 (divido por 256)

; void ASM_merge2(uint32_t w, uint32_t h, uint8_t* data1, uint8_t* data2, float value)
global ASM_merge2
section .text
ASM_merge2:
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

	pxor xmm1, xmm1
	movss xmm1, [dosCincoSeis]
	mulss xmm0, xmm1
	CVTTPS2DQ xmm0, xmm0 ; convierto value*256 a int

	;registro xmm15 =  [value|value|value|value] para multiplicar
	movdqu xmm9, xmm0 ;copio value
	pshufd xmm0, xmm0, 0x00
	
	movdqu xmm15, xmm0

	pxor xmm1, xmm1
	
	movss xmm1, [uno] ;0000 0000 0000 0001
	movss xmm2, [dosCincoSeis]
	
	mulss xmm1, xmm2 ; multiplico 1*256
	CVTTPS2DQ xmm1, xmm1;convierto 1*256 a int	

	psubd xmm1, xmm9 ;1-value


	pshufd xmm1, xmm1, 0x00
	;registro xmm14 = [1-value|1-value|1-value|1-value] para multiplicar
	movdqu xmm14, xmm1

	;calculo el tamanio del vector
	mov eax, r12d
	mov ebx, r13d
	mul ebx ; ebx*eax -> res = p.a en edx - p.b en eax
	xor r13, r13
	mov r13d, edx
	shl r13, 4 ;chequear cuanto shiftea shl 4B o 4bits?
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
		;xmm14 = 1-value
		;xmm15 = value
		cmp rcx, 0
		je .terminarMerge

		movdqu xmm0, [r14] ; [P_a_3 | P_a_2 | P_a_1 | P_a_0] ;data1
		movdqu xmm1, [r15] ; [P_b_3 | P_b_2 | P_b_1 | P_b_0] ;data2
		pxor xmm7, xmm7

		movdqu xmm2, xmm0 ;copio xmm0
		punpcklbw xmm0, xmm7 ;0|P3a|0|P3b|0|P3c|0|P3d|0|P2a|0|P2b|0|P2c|0|P2d  L
		punpckhbw xmm2, xmm7 ;0|P1a|0|P1b|0|P1c|0|P1d|0|P0a|0|P0b|0|P0c|0|P0d  H

		;ahora tengo que desempaquetar una vez mas de word a double word

		movdqu xmm3, xmm0
		punpcklwd xmm0, xmm7 ;0|0|0|P3a|0|0|0|P3b|0|0|0|P3c|0|0|0|P3d  L
		punpckhwd xmm3, xmm7 ;0|0|0|P2a|0|0|0|P2b|0|0|0|P2c|0|0|0|P2d  H

		movdqu xmm4, xmm2
		punpcklwd xmm2, xmm7 ;0|0|0|P1a|0|0|0|P1b|0|0|0|P1c|0|0|0|P1d  L
		punpckhwd xmm4, xmm7 ;0|0|0|P0a|0|0|0|P0b|0|0|0|P0c|0|0|0|P0d  H

		;multiplico ints
		pmulld xmm0, xmm15
		pmulld xmm3, xmm15
		pmulld xmm2, xmm15
		pmulld xmm4, xmm15
		
		psrad xmm0, 15
		psrad xmm3, 15
		psrad xmm2, 15
		psrad xmm4, 15

		;ahora desempaqueto xmm1

		pxor xmm13, xmm13
		movdqu xmm5, xmm1 ;copio xmm1
		punpcklbw xmm1, xmm13;0|Pp3a|0|Pp3b|0|Pp3c|0|Pp3d|0|Pp2a|0|Pp2b|0|Pp2c|0|Pp2d  L
		punpckhbw xmm5, xmm13 ;0|Pp1a|0|Pp1b|0|Pp1c|0|Pp1d|0|Pp0a|0|Pp0b|0|Pp0c|0|Pp0d  H

		;ahora tengo que desempaquetar una vez mas de word a double word

		movdqu xmm6, xmm1
		punpcklwd xmm1, xmm13 ;0|0|0|Pp3a|0|0|0|Pp3b|0|0|0|Pp3c|0|0|0|Pp3d  L
		punpckhwd xmm6, xmm13 ;0|0|0|Pp2a|0|0|0|Pp2b|0|0|0|Pp2c|0|0|0|Pp2d  H

		movdqu xmm8, xmm5
		punpcklwd xmm5, xmm13 ;0|0|0|Pp1a|0|0|0|Pp1b|0|0|0|Pp1c|0|0|0|Pp1d  L
		punpckhwd xmm8, xmm13 ;0|0|0|Pp0a|0|0|0|Pp0b|0|0|0|Pp0c|0|0|0|Pp0d  H

		;multiplico

		pmulld xmm1, xmm14
		pmulld xmm6, xmm14
		pmulld xmm5, xmm14
		pmulld xmm8, xmm14

		psrad xmm1, 15
		psrad xmm6, 15
		psrad xmm5, 15
		psrad xmm8, 15

		;sumo con el registro analogo de xmm0
		paddd xmm0, xmm1 ;P3*value + Pp3*(1-value)
		paddd xmm3, xmm6 ;P2*value + Pp2*(1-value)
		paddd xmm2, xmm5 ;P1*value + Pp1*(1-value)
		paddd xmm4, xmm8 ;P0*value + Pp0*(1-value)

		packusdw xmm0, xmm3 ;[P3|P2]
		packusdw xmm2, xmm4 ;[P1|P0]

		packuswb xmm0, xmm2 ;[P3|P2|P1|P0]

		movdqu [r14], xmm0

		add r14, 16 ;me muevo en xmm0 (data1)
		add r15, 16 ;me muevo en xmm1 (data1)
		sub rcx, 1
		jmp .ciclo

	.terminarMerge
		pop rbp
		ret