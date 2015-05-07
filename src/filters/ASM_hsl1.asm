; ************************************************************************* ;
; Organizacion del Computador II                                            ;
;                                                                           ;
;   Implementacion de la funcion HSL 1                                      ;
;                                                                           ;
; ************************************************************************* ;
; YA IMPLEMENTADAS EN C

	;void rgbTOhsl(uint8_t *src, float *dst)
	extern hslTOrgb
	;void hslTOrgb(float *src, uint8_t *dst)
	extern rgbTOhsl

; void ASM_hsl1(uint32_t w, uint32_t h, uint8_t* data, float hh, float ss, float ll)
global ASM_hsl1

section .data

comparar: dd	0.0, 360.0, 1.0, 1.0,
vuelta_atras: dd	0.0, -360.0, 1.0, 1.0
vuelta_adelante: dd		0.0, 360.0, 0.0, 0.0

section .text
ASM_hsl1:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push rbx
	push r15
	push r14
	push r13
	push r12

	lea rbx, [rbp-16]		;rbx: 16 bytes reservados para el calculo de un pixel a hsl

	mov r13, rdi			;r13 = w
	mov r14, rsi			;r14 = h
	mov r15, rdx			;r15 = data
	movss xmm15, xmm0		;xmm15 = hh
	movss xmm14, xmm1		;xmm14 = ss
	movss xmm13, xmm2		;xmm13 = ll


	;calculo el tamanio de la imagen en pixeles
	mov eax, r13d
	mul r14d 				;r13(w)*r14(h) -> res = p.a en edx - p.b en eax
	xor r8, r8
	mov r8d, edx
	shl r8, 4
	mov r8d, eax			;r8 = r13(w)*r14(h)
	mov r12, r8				;r12 = r13(w)*r14(h) preservo porque r8 se puede perder


	movdqu xmm10, [comparar]
	pxor xmm11, xmm11
	movdqu xmm2, [vuelta_atras]
	movdqu xmm3, [vuelta_adelante]
	;voy a iterar cada pixel (r12) de la imagen
	.ciclo:
		cmp r12, 0
		je .terminarCiclo

		mov rdi, r15 			;puntero a donde empieza la imagen
		mov rsi, rbx

		call rgbTOhsl
		movups xmm0, [rbx]		;xmm0 = |l|s|h|a| valores transformados a hsl

		;;;;;suma;;;;;;
		pxor xmm1, xmm1			;xmm1 = |00|00|00|00|
		movss xmm1, xmm13		;xmm1 = |00|00|00|LL|
		pslldq xmm1, 4			;xmm1 = |00|00|LL|00|
		movss xmm1, xmm14		;xmm1 = |00|00|LL|SS|
		pslldq xmm1, 4			;xmm1 = |00|LL|SS|00|
		movss xmm1, xmm15		;xmm1 = |00|LL|SS|HH|
		pslldq xmm1, 4			;xmm1 = |LL|SS|HH|aa|

		addps xmm0, xmm1		;xmm0 = |l+LL|s+SS|h+HH|aa|
		movups xmm7, xmm0       ;xmm7 = |l+LL|s+SS|h+HH|aa|
		movups xmm8, xmm0       ;xmm8 = |l+LL|s+SS|h+HH|aa|

		pxor xmm5, xmm5
		movlhps xmm5, xmm0		;xmm5 = |h+HH|aa|00|00|
		psrldq xmm5, 8			;xmm5 = |00|00|h+HH|aa|
		movups xmm6, xmm5		;xmm6 = |00|00|h+HH|aa|
		addps xmm5, xmm2		;xmm5 = |1|1|h+HH-360|aa|
		addps xmm6, xmm3		;xmm6 = |0|0|h+HH+360|aa|

		cmpps xmm0, xmm10, 5	;not less than = mayor o igual
		pand xmm0, xmm5 		;en xmm0 queda donde habia ceros 0 y el valor correspondiente en xmm5 donde habia 1.
		cmpps xmm7, xmm11, 1	;less than
		pand xmm7, xmm6 		;en xmm7 queda donde habia ceros 0 y el valor correspondiente en xmm6 donde habia 1
		addps xmm0, xmm7

		movups xmm7, xmm0 		;preservo xmm0
		cmpps xmm0, xmm11, 0 	;comparo de nuevo contra 0
		pand xmm0, xmm8 		;donde era igual a 0, pongo el resultado del else if en xmm8

		addps xmm0, xmm7 		;en xmm0 me queda el resultado final?

		movdqu [rbx], xmm0
		mov rdi, rbx
		mov rsi, r15
		call hslTOrgb

		add r15, 4 				;me muevo un pixel en la imagen
		sub r12, 1 				;decremento el contador
		jmp .ciclo

	.terminarCiclo:

	pop r12
	pop r13
	pop r14
	pop r15
	pop rbx
	add rsp, 24
	pop rbp
  	ret







;;;idea!!!


		;armar un registro xmm1 = [00|LL|SS|HH]
		;sumar xmm1 y xmm0 de modo que quede xmm0 = [a|l+LL|s+SS|h+HH]
		;copiar xmm0 en xmm7
		;armar este registro: xmm2 = [0|1|1|360] para comparar mayor o igual
		; ojo, el alfa puede estar mal
		;armar este registro: xmm3 = [0|0|0|0] para comparar por menor

		;armar este registro: xmm4 = [a|l+LL|s+SS|h+HH] (es una copia de xmm0)

		;cmpps xmm0, xmm2, 5 (5 = not less)
		; en xmm0 queda una mascara donde 1 = true, 0 = false
		;armar este registro: xmm5 = [0|1|1|h+HH-360]
		;pand xmm0, xmm5 ; en xmm0 queda donde habia ceros 0 y el valor correspondiente en xmm5 donde habia 1.
		;armar este registro: xmm6 = [0|0|0|h+HH+360]
		;cmpps xmm7, xmm3, 1 (1= less)
		;en xmm7 queda una mascara donde 1 =true, 0 = false
		;pand xmm7, xmm6 ;en xmm7 queda donde habia ceros 0 y el valor correspondiente en xmm6 donde habia 1
		;si sumo xmm0 con xmm7 me queda todo con valores, y donde hay ceros es el else.
		;puedo hacer un cmpps mas, con 0 y si es igual le pongo como hicimos antes una mascara que tenga los valores del else.
		;pongo con un shuffle o algo el alfa al principio, porque creo que lo perdi

		;Tengo en xmm0 el valor final procesado
