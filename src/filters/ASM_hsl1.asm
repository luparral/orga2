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
	sub rsp, 8
	;rdi = w
	;rsi = h
	;rdx = data
	;xmm0 = hh
	;xmm1 = ss
	;xmm2 = ll

	mov rbx, rdx ;preservo data
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
		
		mov rdi, rbx ;puntero a donde empieza la imagen
		sub rsp, 16
		mov rsi, rbp

		call rgbTOhsl
		movups xmm0, [rbp]
		
		;suma
		movdqu [rbp], xmm0
		mov rdi, rbp
		mov rsi, rbx
		call hslTOrgb
		add rsp, 16


	.terminarCiclo
	add rsp, 8
	pop rbx
	pop rbp
  	ret
  

