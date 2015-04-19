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
	mov rbx, rdx
	mov r12d, rdi
	mov r13d, rsi
	
	xor rdi, rdi
	mov edi, (r12d * 4)
	call malloc
	mov r14, rax

	xor rdi, rdi
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
	call copiarRowIhIntoRow_1

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

;void copiarRowIhIntoRow_1(uint8_t** row_1, int rowNumber, uint8_t*** imagen, uint32_t width)
;Ojo, el comentario este es un re pseudocodigo, no se si puse bien los punteros, pero reciben lo que dice
	; rdi = row_1
	; esi = rowNumber
	; rbx = imagen
	; ecx = witdh
copiarRowIhIntoRow_1:
	;Armando el stack frame
	push rbp
	mov	rbp, rsp
	;Backupeando los registros, para la convención C
	push r12
	sub rsp, 8	;Alineando el stack desalineado

		mov r12d, 0
		.ciclo1:
			cmp r12d, ecx
			je .finCiclo1

			;APLICAR ACA LOGICA PARA HACER 4 ASIGNACIONES DE UN SOLO SAQUE

			inc r12d
			jmp ciclo1
		.finCiclo1:

	add rsp, 8
	pop r12
	pop rbp
	ret