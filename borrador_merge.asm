section .rodata
	_value = [value | value | value | value]
	_1MenosValue = [1-value | 1-value | 1-value | 1-value]

section .text
	
;xmmo = data1
;xmm1 = data2

; xmm0 = P0a|P0b|P0c|P0d|P1a|P1b|P1c|P1d|P2a|P2b|P2c|P2d|P3a|P3b|P3c|P3d
; xmm1 = Pp0a|Pp0b|Pp0c|Pp0d|Pp1a|Pp1b|Pp1c|Pp1d|Pp2a|Pp2b|Pp2c|Pp2d|Pp3a|Pp3b|Pp3c|Pp3d

movdqu xmm10, xmm0 ;copio xmm0 en xmm10 para no arruinar xmm0 porque en este devuelvo

pxor xmm7, xmm7
movdqu xmm2, xmm10 ;copio xmm0
punpcklbw xmm10, xmm7 ;0|P2a|0|P2b|0|P2c|0|P2d|0|P3a|0|P3b|0|P3c|0|P3d  L
punpckhbw xmm2, xmm7 ;0|P0a|0|P0b|0|P0c|0|P0d|0|P1a|0|P1b|0|P1c|0|P1d  H

;ahora tengo que desempaquetar una vez mas de word a double word

pxor xmm7, xmm7
movdqu xmm3, xmm10
punpcklbw xmm0, xmm7 ;0|0|0|P3a|0|0|0|P3b|0|0|0|P3c|0|0|0|P3d  L
punpcklbw xmm3, xmm7 ;0|0|0|P2a|0|0|0|P2b|0|0|0|P2c|0|0|0|P2d  H

pxor xmm7, xmm7
movdqu xmm4, xmm2
punpcklbw xmm2, xmm7 ;0|0|0|P1a|0|0|0|P1b|0|0|0|P1c|0|0|0|P1d  L
punpcklbw xmm4, xmm7 ;0|0|0|P0a|0|0|0|P0b|0|0|0|P0c|0|0|0|P0d  H

cvtdq2pd xmm5, xmm10 ;convert packed dword int to packed double FP
cvtdq2pd xmm6, xmm3
cvtdq2pd xmm7, xmm2
cvtdq2pd xmm8, xmm4

mulps xmm5, _value
mulps xmm6, _value
mulps xmm7, _value
mulps xmm8, _value

;tengo que volver a convertir a int?

packusdw xmm5, xmm6
packusdw xmm7, xmm8

packuswb xmm5, xmm7

;en xmm5 tengo los primeros 4 pixeles ya multiplicados por _value

pxor xmm7, xmm7
movdqu xmm2, xmm1 ;copio xmm1
punpcklbw xmm1, xmm7 ;0|Pp2a|0|Pp2b|0|Pp2c|0|Pp2d|0|Pp3a|0|Pp3b|0|Pp3c|0|Pp3d  L
punpckhbw xmm2, xmm7 ;0|Pp0a|0|Pp0b|0|Pp0c|0|Pp0d|0|Pp1a|0|Pp1b|0|Pp1c|0|Pp1d  H

;ahora tengo que desempaquetar una vez mas de word a double word

pxor xmm7, xmm7
movdqu xmm3, xmm1
punpcklbw xmm1, xmm7 ;0|0|0|Pp3a|0|0|0|Pp3b|0|0|0|Pp3c|0|0|0|Pp3d  L
punpcklbw xmm3, xmm7 ;0|0|0|Pp2a|0|0|0|Pp2b|0|0|0|Pp2c|0|0|0|Pp2d  H

pxor xmm7, xmm7
movdqu xmm4, xmm2
punpcklbw xmm2, xmm7 ;0|0|0|Pp1a|0|0|0|Pp1b|0|0|0|Pp1c|0|0|0|Pp1d  L
punpcklbw xmm4, xmm7 ;0|0|0|Pp0a|0|0|0|Pp0b|0|0|0|Pp0c|0|0|0|Pp0d  H

cvtdq2pd xmm9, xmm1 ;convert packed dword int to packed double FP
cvtdq2pd xmm6, xmm3
cvtdq2pd xmm7, xmm2
cvtdq2pd xmm8, xmm4

mulps xmm9, _1MenosValue
mulps xmm6, _1MenosValue
mulps xmm7, _1MenosValue
mulps xmm8, _1MenosValue

;tengo que volver a convertir a int?

packusdw xmm9, xmm6
packusdw xmm7, xmm8

packuswb xmm9, xmm7

;en xmm9 tengo los primeros 4 pixeles ya multiplicados por _value

addps xmm5, xmm9
movups xmm0, xmm5 ;pongo el resultado en xmm0, es decir, voy pisando data1 

movups xmm0, [xmm0+16] ;me muevo en xmm0 (data1)
movups xmm1, [xmm1+16] ;me muevo en xmm1 (data1)

loop .ciclo
