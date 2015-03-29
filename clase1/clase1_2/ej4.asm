;Construir una función en ASM con la siguiente aridad:
;int suma_parametros(int a0, int a1, int a2, int a3, int a4, int a5, int a6, int a7);
;la función retorna como resultado la operación a0-a1+a2-a3+a4-a5+a6-a7

global _start
section .text
operacion:
   	push RBP
   	mov RBP, RSP
   	sub RSP, 16 ;hago espacio para dos registros que no tienen lugar?
   	push RDI ;a0
   	push RSI ;a1
   	push RDX ;a2
   	push RCX ;a3
   	push R8  ;a4
   	push R9  ;a5
   	;me faltan dos registros, que onda?
   	;no termino de entender cuando los registros se llenan con lo que me pasa c como param
   	;no entiendo como voy a pushear a a6 y a7 a la pila y como los voy a pedir luego.

   	sub RDI, RSI ;a0 = a0-a1
   	add RDI, RDX ;a0 = a0+a2|
   	sub RDI, RCX ;a0 = a0-a3
   	add RDI, R8  ;a0 = a0+a4
   	sub RDI, R9  ;a0 = a0-a5
   	;faltan a0= a0+a6
   	;a0 = a0-a7
   	mov RAX, RDI ; devuelvo rdi por rax.

    pop R9
   	pop R8
   	pop RCX
   	pop RDX
   	pop RSI
   	pop RDI
   	add RSP, 16
   	pop RBP
