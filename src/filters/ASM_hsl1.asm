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
	push rbx
	push r15
	mov R8, rsp
	sub rsp, 16
	
	;rdi = w
	;rsi = h
	;rdx = data
	;xmm0 = hh
	;xmm1 = ss
	;xmm2 = ll

	mov r15, rdx ;preservo data
	movups xmm15, xmm0 ;libero los registros xmm0 que son para pasar en param por c
	movups xmm14, xmm1
	movups xmm13, xmm2

	;calculo el tamanio del vector
	mov eax, edi
	mov ebx, esi
	mul ebx ; ebx*eax -> res = p.a en edx - p.b en eax
	xor r13, r13
	mov r13d, edx
	shl r13, 4
	mov r13d, eax 

	;en r13 tengo rdi * rsi
	;rdi(w)*rsi(h)*4 /16 = (w*h)/4
	mov rcx, r13
	
	.ciclo
		;voy a iterar la imagen de pixel
		cmp rcx, 0
		je .terminarCiclo
		
		mov rdi, r15 ;puntero a donde empieza la imagen
		mov rsi, r8

		call rgbTOhsl
		movups xmm0, [r8]
		
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


		movdqu [r8], xmm0
		mov rdi, r8
		mov rsi, r15
		call hslTOrgb
		
		add r15, 4 ;me muevo un pixel en la imagen
		sub rcx, 4 ;decremento el contador
		jmp .ciclo

	.terminarCiclo
	add rsp, 16
	pop r15
	pop rbx
	pop rbp
  	ret
  

