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
uno: dd 1.0
dos: dd 2.0
cuatro: dd 4.0
seis: dd 6.0
sesenta: dd 60.0
cientoVeinte: dd 120.00
cientoOchenta: dd 180.00
dosCuanrenta: dd 240.00
dosCincoCinco: dd 255.00
trecientos: dd 300.00
tresSesenta: dd 360.00
quinientosDiez: dd 510.0
topeSuperior: dd 255.0001
bitDeSigno: dd 0x7FFFFFFF
ceros: dd 0.0, 0.0, 0.0, 0.0
comparar: dd 0.0, 360.0, 1.0, 1.0
vuelta_atras: dd 0.0, -360.0, 1.0, 1.0
vuelta_adelante: dd	0.0, 360.0, 0.0, 0.0

section .text
ASM_hsl1:
	push rbp
	mov rbp, rsp
	sub rsp, 40
	push rbx
	push r15
	push r14
	push r13
	push r12

	lea rbx, [rbp-40]		;rbx: 16 bytes reservados para el calculo de un pixel a hsl

	mov r13, rdi			;r13 = w
	mov r14, rsi			;r14 = h
	mov r15, rdx			;r15 = data
	movss [rbp-24], xmm0	;[rbp-24] = hh
	movss [rbp-20], xmm1	;[rbp-20] = ss
	movss [rbp-16], xmm2	;[rbp-16] = ll


	;calculo el tamanio de la imagen en pixeles
	mov eax, r13d
	mul r14d 				;r13(w)*r14(h) -> res = p.a en edx - p.b en eax
	xor r8, r8
	mov r8d, edx
	shl r8, 4
	mov r8d, eax			;r8 = r13(w)*r14(h)
	mov r12, r8				;r12 = r13(w)*r14(h) preservo porque r8 se puede perder


	;voy a iterar cada pixel (r12) de la imagen
	.ciclo:
		cmp r12, 0
		je .terminarCiclo

		mov rdi, r15 			;puntero a donde empieza la imagen
		mov rsi, rbx

		call rgbTOhsl
		movups xmm0, [rbx]		;xmm0 = |l|s|h|a| valores transformados a hsl

		;armo los datos sumados
		pxor xmm1, xmm1			;xmm1 = |00|00|00|00|
		pxor xmm2, xmm2
		pxor xmm3, xmm3
		movss xmm1, [rbp-16]	;xmm1 = |00|00|00|LL|
		pslldq xmm1, 12			;xmm1 = |00|00|LL|00|
		movss xmm2, [rbp-20]	;xmm1 = |00|00|LL|SS|
		pslldq xmm2, 8			;xmm1 = |00|LL|SS|00|
		movss xmm3, [rbp-24]	;xmm1 = |00|LL|SS|HH|
		pslldq xmm3, 4			;xmm1 = |LL|SS|HH|aa|

		addps xmm1, xmm2
		addps xmm1, xmm3

		addps xmm0, xmm1		;xmm0 = |l+LL|s+SS|h+HH|aa|
		movups xmm7, xmm0       ;xmm7 = |l+LL|s+SS|h+HH|aa|
		movups xmm8, xmm0       ;xmm8 = |l+LL|s+SS|h+HH|aa|
		movups xmm1, xmm0		;xmm1 = |l+LL|s+SS|h+HH|aa|

		;traigo mascaras
		movups xmm10, [comparar]
		pxor xmm11, xmm11
		movups xmm2, [vuelta_atras]
		movups xmm3, [vuelta_adelante]

		;preparo datos con mascaras
		pxor xmm5, xmm5
		movlhps xmm5, xmm0		;xmm5 = |h+HH|aa|00|00|
		psrldq xmm5, 8			;xmm5 = |00|00|h+HH|aa|
		movups xmm6, xmm5		;xmm6 = |00|00|h+HH|aa|
		addps xmm5, xmm2		;xmm5 = |1|1|h+HH-360|aa|
		addps xmm6, xmm3		;xmm6 = |0|0|h+HH+360|aa|

		;logica de suma
		;if h+HH>=360 || s+SS>1 || l+LL>1
			;5 = greater equal
		cmpps xmm0, xmm10, 5	;xmm0 = |1|0|0|1|
		pand xmm0, xmm5			;xmm0 = |1|0|0|aa|

		;if 0<=h+HH<360 || 0<=s+SS<1 || 0<=l+LL<1
			;1 = less than
		cmpps xmm7, xmm10, 1	;xmm7 = |0|1|1|0|
			;5 = greater equal
		cmpps xmm8, xmm11, 5	;xmm8 =	|0|1|1|1|
		pand xmm7, xmm8			;xmm7 = |0|0|1|0|
		pand xmm7, xmm1			;xmm7 = |00|00|h+HH|0|

		;if h+HH<0 || s+SS<0 || l+LL<0
			;1 = less than
		cmpps xmm1,	xmm11, 1	;xmm1 = |1|0|0|0|
		pand xmm1, xmm6			;xmm1 = |0|0|0|0|

		;sumo todos los valores con las mascaras aplicadas
		por xmm0, xmm7		;xmm0 = |00|1|hh+HH|aa|
		por xmm0, xmm1		;xmm0 =	|00|1|hh+HH|aa|

		;deposito cuidadosamente el resultado
		movdqu [rbx], xmm0
		mov rdi, rbx
		mov rsi, r15
		call hslTOrgb
		;c'est voila

		add r15, 4 				;me muevo un pixel en la imagen
		sub r12, 1 				;decremento el contador
		jmp .ciclo

	.terminarCiclo:

	pop r12
	pop r13
	pop r14
	pop r15
	pop rbx
	add rsp, 40
	pop rbp
  	ret
