; ************************************************************************* ;
; Organizacion del Computador II                                            ;
;                                                                           ;
;   Implementacion de la funcion HSL 2                                      ;
;                                                                           ;
; ************************************************************************* ;

; void ASM_hsl2(uint32_t w, uint32_t h, uint8_t* data, float hh, float ss, float ll)
global ASM_hsl2

section .data

uno: dd 1.0
dos: dd 2.0
cuatro: dd 4.0
seis: dd 6.0
sesenta: dd 60.0
tresSesenta: dd 360.00
quinientosDiez: dd 510.0
topeSuperior: dd 255.0001

section .text
ASM_hsl2:
	;Hay registros salvados innecesariamente. Esto es para facilitar la hora del desarrollo.
	;La pila queda alineada, cuando se termine de desarrollar se acomoda y ya
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8

		;CONVERT RGB TO HSL

			;Limpio todos los registros
			xor r9, r9
			xor r10, r10
			xor r11, r11
			xor r12, r12
			xor r13, r13
			xor r14, r14
			xor r15, r15
			xor rbx, rbx

			;Backupeo los parametros en mis propios registros
			mov 	 r12d, edi
			mov 	 r13d, esi
			mov 	 rbx, rdx
			movdqu   xmm13, xmm0 		;xmm13 = hh
			movdqu   xmm14, xmm1 		;xmm14 = ss
			movdqu   xmm15, xmm2 		;xmm15 = ll

			;Guardo cada croma
			mov r11b, 	[rbx + 0]   ;r11b = transparencia
			mov r8b, 	[rbx + 1] 	;r8b  = r
			mov r9b,	[rbx + 2]	;r9b  = g
			mov r10b, 	[rbx + 3]	;r10b = b

			cmp r8b, r9b
			jg r8bMayor
			cmp r9b, r10b
			jg r9bMaximo
			jl r10bMaximo

			r8bMayor:
				cmp r8b, r10b
			  	jg r8bMaximo
			  	jl r10bMaximo

			r8bMaximo:
			  	mov dl, r8b
			  	cmp r9b, r10b 
			  	jl r9bMinimo
			  	jmp r10bMinimo
			r9bMaximo:
			  	mov dl, r9b
			  	cmp r8b, r10b 
			  	jl r8bMinimo
			  	jmp r10bMinimo
			r10bMaximo:
			  	mov dl, r10b
			  	cmp r8b, r9b 
			  	jl r8bMinimo
			  	jmp r9bMinimo

			r8bMinimo:
			  	mov cl, r8b
			  	jmp calculoDeCromas
			r9bMinimo:
			  	mov cl, r9b
			  	jmp calculoDeCromas
			r10bMinimo:
			  	mov cl, r10b
			  	jmp calculoDeCromas

			calculoDeCromas:
				pxor xmm12, xmm12
				xor rbx, rbx
				mov bl, dl
				sub bl, cl 				;bl = max - min
				cvtsi2ss xmm12, rbx

				;Resumen de variables

				;cl 	= min(r,g,b)
			  	;dl 	= max(r,g,b)
			  	;bl 	= max(r,g,b) - min(r,g,b)
			  	;xmm12 	= d = (float) (max(r,g,b) - min(r,g,b))

			  	;r11b = transparencia
			 	;r8b  = r
				;r9b  = g
				;r10b = b

				;xmm0 representará la transparencia
				;xmm1 representará a h
				;xmm2 representará a l 
				;xmm3 representará a s
			  	pxor xmm0, xmm0
			  	pxor xmm1, xmm1
			  	pxor xmm2, xmm2
			  	pxor xmm3, xmm3
			  	jmp calculoDeH

				calculoDeH:
					pxor xmm4, xmm4
					pxor xmm5, xmm5

				  	cmp cl, dl 			;if(min(r,g,b) == max(r,g,b))
				  	je calculoDeL 		; 	h = 0; 
				  						;	calcularL();

				  	cmp dl, r8b 		;if(max(r,g,b) == r)
				  	je maxEsR 			;	goto maxEsR

				  	cmp dl, r9b 		;if(max(r,g,b) == g)
				  	je maxEsG 			;	goto maxEsG

				  	cmp dl, r10b 		;if(max(r,g,b) == b)
					je maxEsB 			;	goto maxEsB


					maxEsR:
						; h = 60 * ( (g-b)/d + 6 )
						mov r15b, r9b
						sub r15b, r10b 		;r15b = g-b

						cvtsi2ss xmm4, r15 	;xmm4 = (float) (g-b)
						divss xmm4, xmm12 	;xmm4 = (g-b)/d
						movss xmm5, [seis]
						addss xmm4, xmm5 	;xmm4 = (g-b)/d + 6
						movss xmm5, [sesenta]
						mulps xmm4, xmm5 	;xmm4 = 60 * ( (g-b)/d + 6 )


						movdqu xmm1, xmm4 	;h = 60 * ( (g-b)/d + 6 )
						jmp recortarH

					maxEsG:
						; h = 60 * ( (b-r)/d + 2 )
						mov r15b, r10b
						sub r15b, r8b 		;r15b = b-r
						
						cvtsi2ss xmm4, r15 	;xmm4 = (float) (b-r)
						divss xmm4, xmm12 	;xmm4 = (b-r)/d
						movss xmm5, [dos]
						addss xmm4, xmm5 	;xmm4 = (b-r)/d + 2
						movss xmm5, [sesenta]
						mulps xmm4, xmm5 	;xmm4 = 60 * ( (b-r)/d + 2 )


						movdqu xmm1, xmm4 	;h = 60 * ( (g-b)/d + 2 )
						jmp recortarH

					maxEsB:
						; h = 60 * ( (r-g)/d + 4 )
						mov r15b, r8b
						sub r15b, r9b 		;r15b = r-g
						
						cvtsi2ss xmm4, r15 	;xmm4 = (float) (r-g)
						divss xmm4, xmm12 	;xmm4 = (r-g)/d
						movss xmm5, [cuatro]
						addss xmm4, xmm5 	;xmm4 = (r-g)/d + 4
						movss xmm5, [sesenta]
						mulps xmm4, xmm5 	;xmm4 = 60 * ( (r-g)/d + 4 )


						movdqu xmm1, xmm4 	;h = 60 * ( (r-g)/d + 4 )
						jmp recortarH

					recortarH:
						;if(h >= 360) h = h - 360
						
						movdqu xmm4, xmm1 			;xmm4 = |basura,basura,basura,  h |
						movss  xmm5, [tresSesenta] 	;xmm5 = |basura,basura,basura, 360|

						cmpps xmm4, xmm5, 5 	;if(h >= 360) = if(xmm4 >= xmm5)
										 		;xmm4 = |basura,basura,basura,FFF si true   000 sino|

						pand xmm4, xmm5 		;xmm4 = |basura,basura,basura,360 si true   0 sino|
						subss xmm1, xmm4 		;xmm1 = |basura,basura,basura,h - 360 si true   h-0 sino|


				calculoDeL:
					pxor xmm4, xmm4

					xor rax, rax
					mov al, dl
					add ax, cx 		;ax = cmax + cmin
					
					cvtsi2ss xmm2, rax 				;xmm2 = cmax + cmin
					movss xmm4, [quinientosDiez] 	;xmm4 = 510.0
					divss xmm2, xmm4				;xmm2 = l = xmm2/xmm4

				calculoDeS:
					cmp cl, dl
					je fin

					pxor xmm4,xmm4
					pxor xmm5, xmm5
					
					;multiplico por 2
					movdqu xmm4, xmm2 		;xmm4 = l
		            movss  xmm5, [dos] 		;xmm5 = 2.0
		            mulps  xmm4, xmm5 		;xmm4 = 2.0 * l

		            pxor xmm5, xmm5
		            movss xmm5, [uno] 		;xmm5 = 1.0
		            subss xmm4, xmm5 		;xmm4 = (2.0 * l) - 1.0

		            ;FALTA: convertir xmm4 a fabs(xmm4) ACA 

		            subss xmm5, xmm4 			;xmm5 = 1 - fabs( (2.0 * l) - 1.0 )
		            pxor xmm4, xmm4
		            movss xmm4, [topeSuperior] 	;xmm4 = 255.0001f
		            divss xmm5, xmm4 			;xmm5 = ( 1 - fabs( (2.0 * l) - 1.0 ) ) / 255.0001f

		            movdqu xmm4, xmm12 		;xmm4 = d = xmm12 = (float) (max(r,g,b) - min(r,g,b))
		            divss xmm4, xmm5 		;xmm4 = d / ( ( 1 - fabs( (2.0 * l) - 1.0 ) ) / 255.0001f )

		            movdqu xmm3, xmm4 		;s = d / ( ( 1 - fabs( (2.0 * l) - 1.0 ) ) / 255.0001f )


		;SUMA


	    ;CONVERT HSL TO RGB





		fin:

	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

  ret
  
;void hslTOrgb(float *src, uint8_t *dst)
hslTOrgb:
	;Hay registros salvados innecesariamente. Esto es para facilitar la hora del desarrollo.
	;La pila queda alineada, cuando se termine de desarrollar se acomoda y ya
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8

		;CONVERT RGB TO HSL

			;Limpio todos los registros
			xor r9, r9
			xor r10, r10
			xor r11, r11
			xor r12, r12
			xor r13, r13
			xor r14, r14
			xor r15, r15
			xor rbx, rbx
			pxor xmm0, xmm0

			;Calculo de RGB
			


	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

  ret
