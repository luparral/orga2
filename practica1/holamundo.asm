section .data
	msg DB 'Hola mundo', 10 ;el 10 es el salto de linea
	largo EQU $ - msg

global _start
section .text
_start:
	mov rsi, 20
ciclo:
	mov rax, 4
	mov rbx, 1
	mov rcx, msg
	mov rdx, largo
	int 0x80

	sub rsi, 1
	jne ciclo
	mov rax, 1
	mov rbx, 0
	int 0x80
