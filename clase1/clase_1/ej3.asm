;Construir una función en ASM que imprima correctamente por pantalla sus parámetros en orden, llamando solo una vez a printf. La función debe tener la siguiente aridad: void imprime_parametros(int a, double f, char*s)

section .data
   msg:  DB '%d, %5.2f, %c', 10
   largo EQU $ - msg

global _start
section .text

imprime: ;este nombre tiene que ser el mismo que este extern void imprime_parametros(int a, double f, char* s); que esta en c?
   ; Armo stack frame SALVANDO TODOS los registros
   push RBP
   mov RBP, RSP
   push RBX ;para guardar a d
   push R12 ; para guardar a c
            ; a f lo guardo en XXM0
   
   ;CODIGO
   
   ;como pongo a rbx, r12 y xmm0 (que ni siquiera lo cargue) en msg para que se imprima?
   ;ademas, no estoy imprimiendo 2 veces, una con sys_write y otra con printf desde c?

   mov rax, 4     ; funcion 4
   mov rbx, 1     ; stdout
   mov rcx, msg   ; mensaje
   mov rdx, largo ; longitud
   int 0x80       ; syscall
   mov rax, 1
   mov rbx, 0
   int 0x80
   


   ; Desarmo stack frame
   pop r12
   pop rbx
   pop rbp
   ret
