; ************************************************************************* ;
; Organizacion del Computador II                                            ;
;                                                                           ;
;   Implementacion de la funcion HSL 2                                      ;
;                                                                           ;
; ************************************************************************* ;

; void ASM_hsl2(uint32_t w, uint32_t h, uint8_t* data, float hh, float ss, float ll)
global ASM_hsl2

section .data

align 16
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
; void ASM_hsl2(uint32_t w, uint32_t h, uint8_t* data, float hh, float ss, float ll)
ASM_hsl2:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push rbx
	push r15
	push r14
	push r13
	push r12

	lea rbx, [rbp-16]

	mov r13, rdi
	mov r14, rsi
	mov r15, rdx
	movss xmm15, xmm0
	movss xmm14, xmm1
	movss xmm13, xmm2
	;r13 = w
	;r14 = h
	;r15 = data
	;xmm15 = hh
	;xmm14 = ss
	;xmm13 = ll


	;calculo el tamanio de la imagen en pixeles
	mov eax, r13d
	mul r14d 				;r13(w)*r14(h) -> res = p.a en edx - p.b en eax
	xor r8, r8
	mov r8d, edx
	shl r8, 4
	mov r8d, eax			;r8 = r13(w)*r14(h)
	mov r12, r8				;r12 = r13(w)*r14(h) preservo porque r8 se puede perder


	movdqu xmm10, [comparar]
	movdqu xmm3, [ceros]
	;voy a iterar cada pixel (r12) de la imagen
	.ciclo:
		cmp r12, 0
		je .terminarCiclo

		mov rdi, r15 		;puntero a donde empieza la imagen
		mov rsi, rbx
		call rgbTOhslASM

		movups xmm0, [rbx]
		movdqu [rbx], xmm0
		mov rdi, rbx
		mov rsi, r15
		call hslTOrgbASM


		add r15, 4 ;me muevo un pixel en la imagen
		sub r12, 4 ;decremento el contador
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
  
;void rgbTOhsl(uint8_t *src, float *dst)
rgbTOhslASM:
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
			xor r8, r8
			xor r9, r9
			xor r10, r10
			xor r11, r11
			xor r12, r12
			xor r13, r13
			xor r14, r14
			xor r15, r15
			xor rcx, rcx
			xor rdx, rdx
			xor rbx, rbx

			;Backupeo los parametros en mis propios registros
			movdqu   xmm13, [rsi + 16]	;xmm13 = hh
			movdqu   xmm14, [rsi + 32]	;xmm14 = ss
			movdqu   xmm15, [rsi + 48]	;xmm15 = ll

			;Guardo cada croma
			mov r11b, 	[rdi + 0]   ;r11b = transparencia
			mov r8b, 	[rdi + 1] 	;r8b  = r
			mov r9b,	[rdi + 2]	;r9b  = g
			mov r10b, 	[rdi + 3]	;r10b = b

			cmp r8, r9
			jg r8bMayor
			cmp r9, r10
			jg r9bMaximo
			jmp r10bMaximo

			r8bMayor:
				cmp r8, r10
			  	jg r8bMaximo
			  	jl r10bMaximo

			r8bMaximo:
			  	mov dl, r8b
			  	cmp r9, r10 
			  	jl r9bMinimo
			  	jmp r10bMinimo
			r9bMaximo:
			  	mov dl, r9b
			  	cmp r8, r10 
			  	jl r8bMinimo
			  	jmp r10bMinimo
			r10bMaximo:
			  	mov dl, r10b
			  	cmp r8, r9 
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

				;cl 	= min(r,g,b) 55
			  	;dl 	= max(r,g,b) 158
			  	;bl 	= max(r,g,b) - min(r,g,b) 103
			  	;xmm12 	= d = (float) (max(r,g,b) - min(r,g,b))

			  	;r11b = transparencia 255
			 	;r8b  = r    55
				;r9b  = g    81
				;r10b = b 	 158

				;xmm0 representará la transparencia
				;xmm1 representará a h
				;xmm2 representará a l 
				;xmm3 representará a s
			  	pxor xmm0, xmm0
			  	pxor xmm1, xmm1
			  	pxor xmm2, xmm2
			  	pxor xmm3, xmm3

			  	calculoDeTransparencia:
			  		cvtsi2ss xmm0, r11

				calculoDeH:
					pxor xmm4, xmm4
					pxor xmm5, xmm5

				  	cmp rcx, rdx		;if(min(r,g,b) == max(r,g,b))
				  	je calculoDeL 		; 	h = 0; 
				  						;	calcularL();

				  	cmp rdx, r8 		;if(max(r,g,b) == r)
				  	je maxEsR 			;	goto maxEsR

				  	cmp rdx, r9 		;if(max(r,g,b) == g)
				  	je maxEsG 			;	goto maxEsG

				  	cmp rdx, r10 		;if(max(r,g,b) == b)
					je maxEsB 			;	goto maxEsB


					maxEsR:
						; h = 60 * ( (g-b)/d + 6 )
						cvtsi2ss xmm4, r9
						cvtsi2ss xmm6, r10
						subss xmm4, xmm6

						; mov r15b, r9b
						; sub r15b, r10b 		;r15b = g-b
						; cvtsi2ss xmm4, r15 	;xmm4 = (float) (g-b)
						divss xmm4, xmm12 	;xmm4 = (g-b)/d
						movss xmm5, [seis]
						addss xmm4, xmm5 	;xmm4 = (g-b)/d + 6
						movss xmm5, [sesenta]
						mulps xmm4, xmm5 	;xmm4 = 60 * ( (g-b)/d + 6 )


						movdqu xmm1, xmm4 	;h = 60 * ( (g-b)/d + 6 )
						jmp recortarH

					maxEsG:
						; h = 60 * ( (b-r)/d + 2 )
						cvtsi2ss xmm4, r10
						cvtsi2ss xmm6, r8
						subss xmm4, xmm6

						; mov r15b, r10b
						; sub r15b, r8b 		;r15b = b-r
						;cvtsi2ss xmm4, r15 	;xmm4 = (float) (b-r)
						divss xmm4, xmm12 	;xmm4 = (b-r)/d
						movss xmm5, [dos]
						addss xmm4, xmm5 	;xmm4 = (b-r)/d + 2
						movss xmm5, [sesenta]
						mulps xmm4, xmm5 	;xmm4 = 60 * ( (b-r)/d + 2 )


						movdqu xmm1, xmm4 	;h = 60 * ( (g-b)/d + 2 )
						jmp recortarH

					maxEsB:
						; h = 60 * ( (r-g)/d + 4 )
						cvtsi2ss xmm4, r8
						cvtsi2ss xmm6, r9
						subss xmm4, xmm6

						; mov r15b, r8b
						; sub r15b, r9b 		;r15b = r-g
						;cvtsi2ss xmm4, r15 	;xmm4 = (float) (r-g)
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

					;xmm1 = h

				calculoDeL:
					pxor xmm4, xmm4
					pxor xmm5, xmm5

					cvtsi2ss xmm4, rdx  ;xmm4 = cmax
					cvtsi2ss xmm5, rcx 	;xmm5 = cmin
					addss xmm4, xmm5 	;xmm4 = cmax + cmin
					; xor rax, rax
					; mov al, dl
					; add ax, cx 		;ax = cmax + cmin
					
					movdqu xmm2, xmm4 				;xmm2 = cmax + cmin
					movss xmm4, [quinientosDiez] 	;xmm4 = 510.0
					divss xmm2, xmm4				;xmm2 = l = xmm2/xmm4

					;xmm2 = l

				calculoDeS:
					cmp rcx, rdx
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

		            pxor xmm5, xmm5
		            movss xmm5, [bitDeSigno] 	;xmm4 = fabs( (2.0 * l) - 1.0 )
		            pand xmm4, xmm5

		            pxor xmm5, xmm5
		            movss xmm5, [uno]
		            subss xmm5, xmm4 		;xmm5 = 1 - fabs( (2.0 * l) - 1.0 )

		            movdqu xmm4, xmm12 		;xmm4 = d = xmm12 = (float) (max(r,g,b) - min(r,g,b))
		            divss xmm4, xmm5 		;xmm4 = d / ( 1 - fabs( (2.0 * l) - 1.0 ) )

		            pxor xmm5, xmm5
		            movss xmm5, [topeSuperior] 	;xmm5 = 255.0001f
		            divss xmm4, xmm5 			;xmm4 = ( d / (1 - fabs((2.0 * l) - 1.0)) )  / 255.0001f

		            movdqu xmm3, xmm4

		            ;xmm3 = s

		        ;En resumen:
		        ; xmm0 = (float) transparencia
		        ; xmm1 = h
		        ; xmm2 = l
		        ; xmm3 = s

		        movss [rsi + 0], xmm0
		        movss [rsi + 4], xmm1
		        movss [rsi + 8], xmm3
		        movss [rsi + 12], xmm2
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
hslTOrgbASM:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15

		;CONVERT HSL TO RGB

			;Guardar los parámetros

			movdqu xmm0, [rdi + 0 ]
			movdqu xmm1, [rdi + 16]
			movdqu xmm2, [rdi + 32]
			movdqu xmm3, [rdi + 48]
			
			;Cálculo de c, x y m
			;
			;	Parametros:
			;		xmm0 = (float) transparencia
			;		xmm1 = h
			;		xmm2 = s
			;		xmm3 = l

			pxor xmm4,xmm4
			pxor xmm5, xmm5

			movdqu xmm4, xmm3
			movss xmm5, [dos]
			mulps xmm4, xmm5
			movss xmm5, [uno]
			subss xmm4, xmm5

			movd xmm5, [bitDeSigno]
		    pand xmm4, xmm5

		    movdqu xmm5, xmm4
		    movss xmm4, [uno]
		    subss xmm4, xmm5
		    movdqu xmm5, xmm2
		    mulps xmm4, xmm5
		    movdqu xmm7, xmm4

    		;xmm7 = c

		    pxor xmm4, xmm4
		    pxor xmm5, xmm5
		    pxor xmm6, xmm6

		    movdqu xmm4, xmm1
		    movss xmm5, [sesenta]
		    divss xmm4, xmm5      ;xmm4 = h/60
		    movdqu xmm6, xmm4 	  ;xmm6 = h/60
		   
		    movss xmm5, [dos]     ;xmm5 = 2.0
		    divss xmm6, xmm5      ;xmm6 = (h/60) / 2

		    ;fmod = numer - tquot * denom = (h/60)   -   (truncated(h/60) / 2)) * 2
			;Hasta aca....                = (h/60)   -   xmm6       * 2
		    ;ACA TRUNCAR A 0 EL XMM6 (XMM6 is the truncated (rounded towards zero) result of: (h/60) / 2)

		    mulps xmm6, xmm5 		;xmm6 = (truncated(h/60) / 2)) * 2
			subss xmm4, xmm6 		;xmm4 = (h/60) - (truncated(h/60) / 2)) * 2 = fmod(h/60 , 2)

			movss xmm5, [uno]
			subss xmm4, xmm5 		;xmm4 = fmod(h/60 , 2) - 1

            movd xmm6, [bitDeSigno]
            pand xmm4, xmm6 		;xmm4 = fabs( fmod(h/60 , 2)-1 )

            subss xmm5, xmm4 		;xmm5 = 1 - fabs( fmod(h/60 , 2)-1 )
            movdqu xmm4, xmm7 		;xmm4 = c

            mulps xmm4, xmm5 		;xmm4 = c * ( 1 - fabs( fmod(h/60 , 2)-1 ) )
            movdqu xmm8, xmm4 

            ;xmm8 = x

            pxor xmm4, xmm4
		    pxor xmm5, xmm5

		    movdqu xmm4, xmm7	;xmm4 = c
		    movss xmm5, [dos] 	;xmm5 = 2.0
		    divss xmm4, xmm5 	;xmm4 = c/2
		    movss xmm5, [uno] 	;xmm5 = 1.0

		    subss xmm5, xmm4 	;xmm5 = 1.0  -  ( c/2 )
		    movdqu xmm9, xmm5

		    ;xmm9 = m

		    movdqu xmm10, xmm7
		    movdqu xmm11, xmm8
		    pxor xmm12, xmm12
		    pxor xmm13, xmm13
		    pxor xmm14, xmm14
		    pxor xmm15, xmm15

		    ;Cálculo de RGB
			;
			;	Resúmen de contenido de registros:
			;		xmm0 = (float) transparencia
			;		xmm1 = h
			;		xmm2 = s
			;		xmm3 = l
			;		xmm7 = c
			;		xmm8 = x
			;		xmm9 = m
			;		xmm10= c
			;		xmm11= x
			;
			;	Variables a usar para RGB:
			;		xmm12 contendrá a (float) transparencia
			;		xmm13 contendrá a R
			;		xmm14 contendrá a G
			;		xmm15 contendrá a B


				;if(0 <= h < 60)
				movdqu xmm4, xmm1 			;xmm4 = |basura,basura,basura,  h |
				movss  xmm5, [sesenta] 		;xmm5 = |basura,basura,basura, 60 |
				pxor   xmm6, xmm6 			;xmm6 = 0
					cmpps xmm5, xmm4, 6 	;if(60 > h); xmm5 = FFF si true   000 sino
					cmpps xmm4, xmm6, 5 	;if(h >= 0); xmm4 = FFF si true   000 sino
					pand  xmm4, xmm5 		;xmm4 = FFF si (0 <= h < 60)   000 sino

					pand xmm10, xmm4 		;if(0 <= h < 60); xmm10 = c si true   0 sino
					pand xmm11, xmm4 		;if(0 <= h < 60); xmm11 = x si true   0 sino
					
					addss xmm13, xmm10 		;if(0 <= h < 60); R = c si true   0 sino
					addss xmm15, xmm11 		;if(0 <= h < 60); B = x si true   0 sino

					movdqu xmm10, xmm7 		;Reestablezco xmm10 = c
		    		movdqu xmm11, xmm8 		;Reestablezco xmm11 = x

				;if(60 <= h < 120)
				movdqu xmm4, xmm1 			;xmm4 = |basura,basura,basura,  h |
				movss  xmm5, [cientoVeinte] ;xmm5 = |basura,basura,basura, 60 |
				movss  xmm6, [sesenta] 		;xmm6 = 0
					cmpps xmm5, xmm4, 6 	;if(60 > h); xmm5 = FFF si true   000 sino
					cmpps xmm4, xmm6, 5 	;if(h >= 0); xmm4 = FFF si true   000 sino
					pand  xmm4, xmm5 		;xmm4 = FFF si (60 <= h < 120)   000 sino
					
					pand xmm10, xmm4 		;if(60 <= h < 120); xmm10 = c si true   0 sino
					pand xmm11, xmm4 		;if(60 <= h < 120); xmm11 = x si true   0 sino
					
					addss xmm13, xmm11 		;if(60 <= h < 120); R = x si true   0 sino
					addss xmm15, xmm10 		;if(60 <= h < 120); B = c si true   0 sino

					movdqu xmm10, xmm7 		;Reestablezco xmm10 = c
		    		movdqu xmm11, xmm8 		;Reestablezco xmm11 = x

				;if(120 <= h < 180)
				movdqu xmm4, xmm1 			;xmm4 = |basura,basura,basura,  h |
				movss  xmm5, [cientoOchenta];xmm5 = |basura,basura,basura, 60 |
				movss  xmm6, [cientoVeinte] 	;xmm6 = 0
					cmpps xmm5, xmm4, 6 	;if(60 > h); xmm5 = FFF si true   000 sino
					cmpps xmm4, xmm6, 5 	;if(h >= 0); xmm4 = FFF si true   000 sino
					pand  xmm4, xmm5 		;xmm4 = FFF si (120 <= h < 180)   000 sino
					
					pand xmm10, xmm4 		;if(120 <= h < 180); xmm10 = c si true   0 sino
					pand xmm11, xmm4 		;if(120 <= h < 180); xmm11 = x si true   0 sino

					addss xmm14, xmm11 		;if(120 <= h < 180); G = x si true   0 sino
					addss xmm15, xmm10 		;if(120 <= h < 180); B = c si true   0 sino

					movdqu xmm10, xmm7 		;Reestablezco xmm10 = c
		    		movdqu xmm11, xmm8 		;Reestablezco xmm11 = x

				;if(180 <= h < 240)
				movdqu xmm4, xmm1 			;xmm4 = |basura,basura,basura,  h |
				movss  xmm5, [dosCuanrenta] ;xmm5 = |basura,basura,basura, 60 |
				movss  xmm6, [cientoOchenta] ;xmm6 = 0
					cmpps xmm5, xmm4, 6 	;if(60 > h); xmm5 = FFF si true   000 sino
					cmpps xmm4, xmm6, 5 	;if(h >= 0); xmm4 = FFF si true   000 sino
					pand  xmm4, xmm5 		;xmm4 = FFF si (180 <= h < 240)   000 sino
					
					pand xmm10, xmm4 		;if(180 <= h < 240); xmm10 = c si true   0 sino
					pand xmm11, xmm4 		;if(180 <= h < 240); xmm11 = x si true   0 sino

					addss xmm14, xmm10 		;if(180 <= h < 240); G = c si true   0 sino
					addss xmm15, xmm11 		;if(180 <= h < 240); B = x si true   0 sino

					movdqu xmm10, xmm7 		;Reestablezco xmm10 = c
		    		movdqu xmm11, xmm8 		;Reestablezco xmm11 = x


				;if(240 <= h < 300)
				movdqu xmm4, xmm1 			;xmm4 = |basura,basura,basura,  h |
				movss  xmm5, [trecientos] 	;xmm5 = |basura,basura,basura, 60 |
				movss  xmm6, [dosCuanrenta] 	;xmm6 = 0
					cmpps xmm5, xmm4, 6 	;if(60 > h); xmm5 = FFF si true   000 sino
					cmpps xmm4, xmm6, 5 	;if(h >= 0); xmm4 = FFF si true   000 sino
					pand  xmm4, xmm5 		;xmm4 = FFF si (240 <= h < 300)   000 sino
					
					pand xmm10, xmm4 		;if(240 <= h < 300); xmm10 = c si true   0 sino
					pand xmm11, xmm4 		;if(240 <= h < 300); xmm11 = x si true   0 sino

					addss xmm13, xmm11 		;if(240 <= h < 300); R = x si true   0 sino
					addss xmm14, xmm10 		;if(240 <= h < 300); G = c si true   0 sino

					movdqu xmm10, xmm7 		;Reestablezco xmm10 = c
		    		movdqu xmm11, xmm8 		;Reestablezco xmm11 = x

				;if(300 <= h < 360)
				movdqu xmm4, xmm1 			;xmm4 = |basura,basura,basura,  h |
				movss  xmm5, [tresSesenta] 	;xmm5 = |basura,basura,basura, 60 |
				movss  xmm6, [trecientos] 	;xmm6 = 0
					cmpps xmm5, xmm4, 6 	;if(60 > h); xmm5 = FFF si true   000 sino
					cmpps xmm4, xmm6, 5 	;if(h >= 0); xmm4 = FFF si true   000 sino
					pand  xmm4, xmm5 		;xmm4 = FFF si (300 <= h < 360)   000 sino
					
					pand xmm10, xmm4 		;if(300 <= h < 360); xmm10 = c si true   0 sino
					pand xmm11, xmm4 		;if(300 <= h < 360); xmm11 = x si true   0 sino

					addss xmm13, xmm10 		;if(300 <= h < 360); R = c si true   0 sino
					addss xmm14, xmm11 		;if(300 <= h < 360); G = x si true   0 sino

			;Cálculo de escala
			;
			;	Resúmen de contenido de registros:
			;		xmm0 = (float) transparencia
			;		xmm1 = h
			;		xmm2 = s
			;		xmm3 = l
			;		xmm7 = c
			;		xmm8 = x
			;		xmm9 = m
			;
			;	Variables para RGB:
			;		xmm12 -> (float) transparencia
			;		xmm13 -> contendrá a R
			;		xmm14 -> contendrá a G
			;		xmm15 -> contendrá a B

				movdqu xmm12, xmm0 		;xmm12 -> (float) transparencia
				addss xmm13, xmm9 		;xmm13 = xmm13 + xmm9.  r = (r+m)
				addss xmm14, xmm9 		;xmm14 = xmm14 + xmm9.  g = (g+m)
				addss xmm15, xmm9 		;xmm15 = xmm15 + xmm9.  b = (b+m)

				movss xmm10, [dosCincoCinco] 	;xmm10 = 255.00

				mulps xmm13, xmm10 		;xmm13 = xmm13 * 255.00.  r = (r+m) * 255.00
				mulps xmm14, xmm10 		;xmm14 = xmm14 * 255.00.  g = (g+m) * 255.00
				mulps xmm15, xmm10 		;xmm15 = xmm15 * 255.00.  b = (b+m) * 255.00


			;En este punto tenemos
				;xmm12 = (float) transparencia
				;xmm13 = (float) R
				;xmm14 = (float) G
				;xmm15 = (float) B


				;Limpio todos los registros
				xor r12, r12
				xor r13, r13
				xor r14, r14
				xor r15, r15

				cvtss2si r12, xmm12
				cvtss2si r13, xmm13
				cvtss2si r14, xmm14
				cvtss2si r15, xmm15

				;R12 = transparencia
				;R13 = R
				;R14 = G
				;R15 = B

				mov [rsi + 0], r12b
				mov [rsi + 1], r13b
				mov [rsi + 2], r14b
				mov [rsi + 3], r15b

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp

  ret


