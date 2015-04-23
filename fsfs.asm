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
	; 	r12d = w
	;	r13d = h
	; 	rbx  = data
	; 	r14  = m_row_0
	; 	r15  = m_row_1

	mov rdi, r15 				
	mov dword esi, 0
	mov rdx, rbx
	mov ecx, r12d
	call copiarRowIhIntoRow_1 	;Hago primer for (linea 19)

	mov dword r8d, 1
	.ciclo1:
		cmp r8d, r13d - 1
		je finCiclo1

		mov rdx, r14
		mov r14, r15
		mov r15, rdx



		mov dword r9d, 1
		.ciclo2:
			cmp r9d, r12d -1
			je .finCiclo2

		
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
	sub rsp, 8	;Alineando el stack desalineado

		; rdi = row_1
		; esi = rowNumber
		; rbx = m = imagen
		; ecx = w = width de la imagen

		mov r13, rbx + w * esi
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

	add rsp, 8
	pop r12
	pop rbp
	ret


	; mov r12d, 0
		; .ciclo1:
		; 	cmp r12d, ecx
		; 	je .finCiclo1

		; 	;APLICAR ACA LOGICA PARA HACER 4 ASIGNACIONES DE UN SOLO SAQUE

		; 	inc r12d
		; 	jmp ciclo1
		; .finCiclo1: