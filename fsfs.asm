extern free
extern malloc
; ************************************************************************* ;
; Organizacion del Computador II                                            ;
;                                                                           ;
;   Implementacion de la funcion Blur 1                                     ;
;                                                                           ;
; ************************************************************************* ;

; void ASM_blur1( uint32_t w, uint32_t h, uint8_t* data )
global ASM_blur1
global copiarRowIhIntoRow_1

ASM_blur1:
	mov rbx, rdx			;uint8_t (*m)[w][4] = (uint8_t (*)[w][4]) data;
	mov r12d, rdi
	mov r13d, rsi
	
	xor rdi, rdi 			;uint8_t (*m_row_0)[4] = (uint8_t (*)[4]) malloc(w*4);
	mov edi, (r12d * 4) 	
	call malloc
	mov r14, rax

	xor rdi, rdi 			;uint8_t (*m_row_1)[4] = (uint8_t (*)[4]) malloc(w*4);
	mov edi, (r12d * 4)
	call malloc
	mov r15, rax

	; Hasta acá vale:
	; 	rbx  = data
	; 	r12d = w
	;	r13d = h
	; 	r14  = m_row_0
	; 	r15  = m_row_1

	;(READ_ONLY REGISTERS): rbx, r12, r13

	mov rdi, r15 				
	mov dword esi, 0 			
	mov rdx, rbx 				
	mov ecx, r12d 				
	call copiarRowIhIntoRow_1 	;(*m_row1, 0, *imagen, width)

	mov dword r8d, 1 			;r8d = 1
	.ciclo1:
		cmp r8d, r13d - 1
		je finCiclo1

		mov rdx, r14 			;swap(r14, r15)    
		mov r14, r15			;if(*r14 == m_row_0) then *r14 = m_row_1
		mov r15, rdx			;if(*r15 == m_row_0) then *r15 = m_row_1

		mov rdi, r15 				
		mov esi, r8d 			
		mov rdx, rbx 				
		mov ecx, r12d 				
		call copiarRowIhIntoRow_1 	;(*m_row1, r8d, *imagen, width)

		xor rdx,rdx
		pxor xmm7, xmm7
		pxor xmm0, xmm0
		pxor xmm1, xmm1
		mov dword r9d, 1
		.ciclo2:
			cmp r9d, r12d -1
			je .finCiclo2

			mov r11, rbx
				mov ebx, r12d
				shl ebx, 2			;ebx = r12d * 4 = ancho de la imagen * 4
				mov eax, r9d 		;eax = numero de row
				mul ebx 			;ebx = ebx * r9d = numero de row * ancho de la imagen * 4
				mov r10, rbx + ebx  ;r13 (puntero a row_m a copiar) = rbx + (esi * (4 * ecx) )
			mov rbx, r11

			;r10 = fila siguiente
			;r14 = row_0
			;r15 = row_1

			;| P7 | P8 | P9 | => FILA + 1
			;| P4 | P5 | P6 | => ROW 1             El promedio debe guardarse en P5;
			;| P1 | P2 | P3 | => ROW 0

			movdqu dword xmm0, [r15+rdx] 	;xmmo=|     BASURA    |     BASURA    |     BASURA    |P1a,P1b,P1c,P1d|
			punpcklbw xmm0, xmm7			;xmmo=|     BASURA    |     BASURA    |0  ,P1a,0  ,P1b|0  ,P1c,0  ,P1d|

			;xmm0 será el acumulador

				;--------------------------

				movdqu dword xmm1, [r14+rdx] 	;xmm1=|     BASURA    |     BASURA    |     BASURA    |P1a,P1b,P1c,P1d|
				punpcklbw xmm1, xmm7			;xmm1=|     BASURA    |     BASURA    |0  ,P1a,0  ,P1b|0  ,P1c,0  ,P1d|
				
				;//xmm0 = xmm0 + xmm1 (dword a dword)

				movdqu dword xmm1, [r10+rdx] 	;xmm1=|     BASURA    |     BASURA    |     BASURA    |P1a,P1b,P1c,P1d|
				punpcklbw xmm1, xmm7			;xmm1=|     BASURA    |     BASURA    |0  ,P1a,0  ,P1b|0  ,P1c,0  ,P1d|
				
				;//xmm0 = xmm0 + xmm1 (dword a dword)

				movdqu dword xmm1, [r15+rdx+4] 	;xmm1=|     BASURA    |     BASURA    |     BASURA    |P1a,P1b,P1c,P1d|
				punpcklbw xmm1, xmm7			;xmm1=|     BASURA    |     BASURA    |0  ,P1a,0  ,P1b|0  ,P1c,0  ,P1d|

				;//xmm0 = xmm0 + xmm1 (dword a dword)

				movdqu dword xmm1, [r14+rdx+4] 	;xmm1=|     BASURA    |     BASURA    |     BASURA    |P1a,P1b,P1c,P1d|
				punpcklbw xmm1, xmm7			;xmm1=|     BASURA    |     BASURA    |0  ,P1a,0  ,P1b|0  ,P1c,0  ,P1d|
				
				;//xmm0 = xmm0 + xmm1 (dword a dword)

				movdqu dword xmm1, [r10+rdx+4] 	;xmm1=|     BASURA    |     BASURA    |     BASURA    |P1a,P1b,P1c,P1d|
				punpcklbw xmm1, xmm7			;xmm1=|     BASURA    |     BASURA    |0  ,P1a,0  ,P1b|0  ,P1c,0  ,P1d|
				
				;//xmm0 = xmm0 + xmm1 (dword a dword)

				movdqu dword xmm1, [r15+rdx+8] 	;xmm1=|     BASURA    |     BASURA    |     BASURA    |P1a,P1b,P1c,P1d|
				punpcklbw xmm1, xmm7			;xmm1=|     BASURA    |     BASURA    |0  ,P1a,0  ,P1b|0  ,P1c,0  ,P1d|

				;//xmm0 = xmm0 + xmm1 (dword a dword)

				movdqu dword xmm1, [r14+rdx+8] 	;xmm1=|     BASURA    |     BASURA    |     BASURA    |P1a,P1b,P1c,P1d|
				punpcklbw xmm1, xmm7			;xmm1=|     BASURA    |     BASURA    |0  ,P1a,0  ,P1b|0  ,P1c,0  ,P1d|
				
				;//xmm0 = xmm0 + xmm1 (dword a dword)

				movdqu dword xmm1, [r10+rdx+8] 	;xmm1=|     BASURA    |     BASURA    |     BASURA    |P1a,P1b,P1c,P1d|
				punpcklbw xmm1, xmm7			;xmm1=|     BASURA    |     BASURA    |0  ,P1a,0  ,P1b|0  ,P1c,0  ,P1d|
				
				;//xmm0 = xmm0 + xmm1 (dword a dword)
		
				;CONVERTIR XMM0 EN FLOAT POR CADA UNO DE LOS PRIMEROS 4 DWORD
				;DIVIDIR POR 9 CADA UNO DE LOS PRIMEROS 4 DWORDS

				;COPIAR LOS BYTES A EL PIXEL DEL MEDIO

			add rdx, 12
			inc r9d
			jmp ciclo2

		.finCiclo2:
		inc r8d
		jmp ciclo1

	.finCiclo1:

	ret

ASM_blur2:
	ciclo1
	ret

;void copiarRowIhIntoRow_1(uint8_t** row_1, int rowNumber, uint8_t*** m, uint32_t width)
;Ojo, el comentario este es un re pseudocodigo, no se si puse bien los punteros, pero reciben lo que dice
copiarRowIhIntoRow_1:
	;Armando el stack frame
	push rbp
	mov	rbp, rsp
	;Backupeando los registros, para la convención C
	push r12
	push rbx

		; rdi = row_1
		; esi = rowNumber
		; rbx = m = imagen
		; ecx = w = width de la imagen

		mov ebx, ecx
		shl ebx, 2			;ebx = 4 * ecx
		
		mov eax, esi
		mul ebx 			; ebx = ebx * esi

		mov r13, rbx + ebx ;r13 (puntero a row_m a copiar) = rbx + (esi * (4 * ecx) )

		shr ecx, 4 	;divido por 16 porque leo de a 16 bytes
					;ecx será la cantidad de iteraciones a realizar
		xor r12,r12
		.ciclo:
			cmp ecx, 0
			je .fin
			movdqu xmm0, [r13+r12] 	
				;xmm0= R1|G1|B1|T1 |R2|G2|B2|T2 |R3|G3|B3|T3 |R4|G4|B4|T4
				;r13 = Donde empieza la fila de la imagen a leer 
				;r12 = Nro de pixel donde empiezo a leer
				;rdi = Donde empieza la row_1
			movdqu [rdi+r12],xmm0   
			dec ecx
			add r12, 16
		.fin:

	pop rbx
	pop r12
	pop rbp
	ret
