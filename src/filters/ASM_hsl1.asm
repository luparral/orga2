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
section .text
ASM_hsl1:
	push rbp
	mov rbp, rsp
	sub rsp, 8
	push rbx
	push r12
	push r13
	push r14
	push r15


	mov r12, rdi
	mov r13, rsi
	mov r14, rdx

	movups xmm15, xmm0 		;libero los registros xmm0 que son para pasar en param por c
	movups xmm14, xmm1
	movups xmm13, xmm2
	;r12 = w
	;r13 = h
	;r14 = *data
	;xmm15 = hh
	;xmm14 = ss
	;xmm13 = ll


	;calculo el tamanio de la imagen
	mov eax, edi
	mul esi 				;h(rdi)*w(rsi) -> res = p.a en edx - p.b en eax
	xor r15, r15
	mov r15d, edx
	shl r15, 4
	mov r15d, eax			;r15: h(rdi)*w(rsi) = full size image (en px)

	xor rbx, rbx			;uso rbx de contador

	;voy a iterar cada pixel de la imagen
	.ciclo:
		cmp rbx, r15
		je .terminarCiclo

		lea rdi, [r14+rbx*4] ;puntero al pixel a transformar en la imagen, avanzo de a 4 bytes
		sub rsp, 16			;uso el espacio del stack frame para guardar el pixel transformado
		mov rsi, rbp
		call rgbTOhsl

		movups xmm0, [rbp]


		;;;;;suma;;;;;;
		;en xmm0 tengo [a|l|s|h]


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


		movdqu [rbp], xmm0
		mov rdi, rbp
		lea rsi, [r14+rbx*4]
		call hslTOrgb		;vuelvo a transformar a rgb

		add rsp, 16
		inc rbx
		jmp .ciclo


	.terminarCiclo:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	add rsp, 8
	pop rbp
  	ret
