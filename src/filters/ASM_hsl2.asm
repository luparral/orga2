; ************************************************************************* ;
; Organizacion del Computador II                                            ;
;                                                                           ;
;   Implementacion de la funcion HSL 2                                      ;
;                                                                           ;
; ************************************************************************* ;

; void ASM_hsl2(uint32_t w, uint32_t h, uint8_t* data, float hh, float ss, float ll)
global ASM_hsl2
ASM_hsl2:
  mov r12d, edi
  mov r13d, esi
  mov rbx, rdx
  movdqu xmm13, xmm0
  movdqu xmm14, xmm1
  movdqu xmm15, xmm2
  
  mov r8d, [rbx + 1]
  mov r9d, [rbx + 2]
  mov r10d, [rbx + 3]

  cmp r8d, r9d
  jg r8dMayor
  cmp r9d, r10d
  jg r9dMaximo
  jl r10dMaximo

  r8dMayor:
  	cmp r8d, r10d
  	jg r8dMaximo
  	jl r10dMaximo

  r8dMaximo:
  	mov edx, r8d
  r9dMaximo:
  	mov edx, r9d
  r10dMaximo:
  	mov edx, r10d


  ret
  

