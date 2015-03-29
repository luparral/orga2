section .data
   msg:  DB 'en 10 me voy ... 9', 10
   largo EQU $ - msg
global _start
section .text

_start:
   mov esi, 10    ; como sabe que esi pertenece al mensaje?
ciclo:
   mov rax, 4     ; funcion 4
   mov rbx, 1     ; stdout
   mov rcx, msg   ; mensaje
   mov rdx, largo ; longitud
   int 0x80       ; syscall
   dec byte [msg+largo-2] ;que es byte? - aparentemente se guarda una dirección de memoria.
   dec esi        ; por que combina registros de 32 bits con registros de 64?
   cmp esi, 0
   jnz ciclo

   mov rax, 1
   mov rbx, 0
   int 0x80
