;RDI,RSI,RDX,RCX,R8,R9
;XMM0,XMM1,XMM2,XMM3,XMM4,XMM5,XMM6,XMM7
;Preservar RBX, R12, R13, R14, R15
;resultado en RAX o XMM0
;Byte: AL, BL, CL, DL, DIL, SIL, BPL, SPL, R8L - R15L
;Word: AX, BX, CX, DX, DI, SI, BP, SP, R8W - R15W
;DWord: EAX, EBX, ECX, EDX, EDI, ESI, EBP, ESP, R8D - R15D
;QWord: RAX, RBX, RCX, RDX, RDI, RSI, RBP, RSP, R8 - R15

%define char_size 1
%define int_size 4
%define word_size 2
%define double_size 8
%define puntero_size 8

; ESTUDIANTE
	global estudianteCrear
	global estudianteBorrar
	global menorEstudiante
	global estudianteConFormato
	global estudianteImprimir
	
; ALTALISTA y NODO
	global nodoCrear
	global nodoBorrar
	global altaListaCrear
	global altaListaBorrar
	global altaListaImprimir

; AVANZADAS
	global edadMedia
	global insertarOrdenado
	global filtrarAltaLista

; YA IMPLEMENTADAS EN C
	extern string_iguales
	;extern insertarAtras

; /** DEFINES **/    >> SE RECOMIENDA COMPLETAR LOS DEFINES CON LOS VALORES CORRECTOS
	%define NULL 	0
	%define TRUE 	1
	%define FALSE 	0

	%define ALTALISTA_SIZE     		16 ;tamaño de la altaLista
	%define OFFSET_PRIMERO 			0 ; 8
	%define OFFSET_ULTIMO  			8 ; 8

	%define NODO_SIZE     			36 ;
	%define OFFSET_SIGUIENTE   		0 ; 8
	%define OFFSET_ANTERIOR   		8 ; 8
	%define OFFSET_DATO 			16 ; 20 

	%define ESTUDIANTE_SIZE  		20 ; 20
	%define OFFSET_NOMBRE 			0 ; 8
	%define OFFSET_GRUPO  			8 ; 8
	%define OFFSET_EDAD 			16 ; 4


section .rodata


section .data


section .text

;/** FUNCIONES OBLIGATORIAS DE ESTUDIANTE **/    >> PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES
;---------------------------------------------------------------------------------------------------------------

	; estudiante *estudianteCrear( char *nombre, char *grupo, unsigned int edad );
	
	estudianteCrear:
		;RDI = nombre
		;RSI = grupo
		;RDX = edad
		push rbp
		mov rbp, rsp
		xor rcx, rcx
		mov rcx, ESTUDIANTE_SIZE
		call malloc
		mov qword [rax + OFFSET_NOMBRE], rdi
		mov qword [rax + OFFSET_GRUPO], rsi
		mov dword [rax + OFFSET_DATO], rdx
		pop rbp
		ret

	; void estudianteBorrar( estudiante *e );
	estudianteBorrar:
		;rdi = estudiante
		push rbp
		mov rbp, rsp
		call free
		mov qword [rdi+OFFSET_NOMBRE], NULL
		mov qword [rdi + OFFSET_GRUPO], NULL
		mov qword [rdi + OFFSET_EDAD], NULL
		pop rbp
		ret

	; bool menorEstudiante( estudiante *e1, estudiante *e2 ){
	menorEstudiante:
		;rdi e1
		;rsi e2
		xor al, al ;limpio al
		call string_menor
		cmp al, 1
		je esMenor
		xor al, al ;limpio al
		call string_iguales
		cmp al, 1
		je sonIguales


	sonIguales:
		cmp [rdi + OFFSET_EDAD], [rsi, OFFSET_EDAD]
		jle e1MenorQueE2
		mov al, FALSE
		ret

	e1MenorQueE2:
		mov al, TRUE
		ret

	esMenor:
		mov al, TRUE
		ret 

	; void estudianteConFormato( estudiante *e, tipoFuncionModificarString f )
	estudianteConFormato:
		; COMPLETAR AQUI EL CODIGO
	
	; void estudianteImprimir( estudiante *e, FILE *file )
	estudianteImprimir:
		; COMPLETAR AQUI EL CODIGO


;/** FUNCIONES DE ALTALISTA Y NODO **/    >> PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES
;--------------------------------------------------------------------------------------------------------

	; nodo *nodoCrear( void *dato )
	nodoCrear:
		; dato esta en rdi
		push rbp
		mov rbp, rsp
		xor rsi, rsi
		mov rsi, NODO_SIZE
		call malloc ;de donde sabe malloc que tiene que tomar el valor del size? En este caso quiero que lo tome de rsi
		mov qword [rax + OFFSET_DATO], rdi
		mov qword [rax + OFFSET_ANTERIOR], NULL
		mov qword [rax + OFFSET_SIGUIENTE], NULL
		pop rbp
		ret

	; void nodoBorrar( nodo *n, tipoFuncionBorrarDato f )
	nodoBorrar:
		;rdi = nodo
		push rbp
		mov rbp, rsp
		call free
		mov qword [rdi + OFFSET_SIGUIENTE], NULL
		mov qword [rdi + OFFSET_ANTERIOR], NULL
		xor rdi, rdi ; limpio rdi
		mov rdi, [rdi+OFFSET_DATO]
		call estudianteBorrar; supuestamente se va a borrar lo que esta en rdi, que es [rdi+OFFSET_DATO]
		pop rbp
		ret

	; altaLista *altaListaCrear( void )
	altaListaCrear:
		push rbp
		mov rbp, rsp
		xor rdi, rdi
		mov rdi, ALTALISTA_SIZE
		call malloc
		mov qword [rax + OFFSET_PRIMERO], NULL
		mov qword [rax + OFFSET_ULTIMO], NULL
		pop rbp
		ret

	; void altaListaBorrar( altaLista *l, tipoFuncionBorrarDato f )
	altaListaBorrar:
		;rdi = l
		;r9 = l
		mov r9, rdi
		push rbp
		mov rbp, rsp
		push rbx

		mov rbx, [r9 + OFFSET_PRIMERO]
		cmp rbx, NULL 
		jne hayUnElemento ;l->primero != NULL
		jmp finBorrar
		pop rbp
		ret

	hayUnElemento:
		;rcx nodoActual = l->primero
		;rdx nodoSiguiente = l->primero->siguiente
		;r8 nodoABorrar = nodoActual
		mov rcx, [r9 + OFFSET_PRIMERO]
		mov rdx, [rcx + OFFSET_SIGUIENTE] ;esto esta bien para apuntar al siguiente?
		mov r8, rcx
		cmp rdx, NULL
		jne hayOtroElemento
		jmp borrarNodo

	hayOtroElemento:
		;rcx : nodoActual = nodoSiguiente
		;rdx : nodoSiguiente = nodoSiguiente->siguiente
		;r8: nodoABorrar = nodoActual
		xor rdi, rdi ; limpio rdi
		mov rdi, r8
		mov rcx, rdx
		mov rdx, [rcx + OFFSET_SIGUIENTE] ;esto esta bien?
		call nodoBorrar ;supuestamente se va a borrar lo que esta en rdi, que es r8
		mov r8, rcx
		cmp rdx, NULL
		jne hayOtroElemento
		jmp borrarNodo

	borrarNodo:
		xor rdi, rdi ;limpio rdi
		mov rdi, rcx
		call nodoBorrar ;supuestamente se va a borrar lo que esta en rdi, que es rcx
		jmp finBorrar

	finBorrar:
		mov qword [r9 + OFFSET_PRIMERO], NULL
		mov qword [r9 + OFFSET_ULTIMO], NULL
		call free


	; void altaListaImprimir( altaLista *l, char *archivo, tipoFuncionImprimirDato f )
	altaListaImprimir:
		; COMPLETAR AQUI EL CODIGO


;/** FUNCIONES AVANZADAS **/    >> PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES
;----------------------------------------------------------------------------------------------

	; float edadMedia( altaLista *l )
	edadMedia:
		;rdi = l
		call cantidadEstudiantes
		mov rsi, rax ;guardo en rsi la cantidadEstudiantes
		xor rax, rax
		call sumaDeEdades
		mov rdx, rax
		cvtsi2ss xmm0, rsi
		cvtsi2ss xmm1, rdx
		divss xmm0, xmm2
		ret

	; void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f )
	insertarOrdenado:
		; COMPLETAR AQUI EL CODIGO

	; void filtrarAltaLista( altaLista *l, tipoFuncionCompararDato f, void *datoCmp )
	filtrarAltaLista:
		; COMPLETAR AQUI EL CODIGO

	;char *string_copiar( char *s );
	string_copiar:
		call string_longitud ;longitud del string
		;rax <- |string|
		inc rax ;+1 para el caracter del final
		mov rdi, rax
		call malloc
		;rax <- puntero al primero
		xor rsi, rsi ; limpio rsi
		cmp [rdi+rsi], 0
		je finCopiar
		mov [rax + rsi], [rdi + rsi]		
		inc rsi

	finCopiar:
		ret
	
	;unsigned char string_longitud( char *s )s
	string_longitud
		;s esta en rdi
		xor rsi, rsi
		xor rax, rax
		jmp cicloStringLongitud
	cicloStringLongitud:
		mov rdx, [rdi+rsi];supuestamente voy poniendo cada caracter en rdx
		inc rax
		inc rsi
		cmp rdx, 0 ;chequear si llegue a cero?
		jae finStringLongitud
		jmp cicloStringLongitud

	finStringLongitud:
		ret

	
	; cmp a, b = a - b
	; si a - b = mayor que 0 => a > b
	;si a - b = menor que 0 => a < b
	;bool string_menor(char *s1, char *s2){ //s1 < s2
	string_menor
		;rdi: s1
		;rsi: s2
		call string_iguales
		cmp rax, 0
		je sonIguales
		xor rdx, rdx; pongo en 0 rsi
		mov al, FALSE; pongo al en false
		jmp cicloStringMenor

	cicloStringMenor:
		cmp [rdi + rdx], 0 ;(s1[i]!=0)
		je finStringMenor
		cmp [rsi + rdx], 0 ; s2[i]==0
		je finStringMenor
		cmp [rdi+rdx], [rsi+rdx]; (s1[i]>s2[i])
		jg s1MayorAs2
		cmp [rdi+rdx], [rsi+rdx]; (s1[i]<s2[i])
		jl s1MenorAs2
		mov al, TRUE
		inc rdx
		jmp cicloStringMenor

	s1MenorAs2:
		mov al, TRUE
		jmp finStringMenor

	s1MayorAs2:
		mov al, FALSE		
		jmp fin

	finStringMenor:
		ret ;aca estoy devolviendo al?

	sonIguales:
		mov al, FALSE
		ret


	;otras funciones auxiliares hechas por menorEstudiante
	;int cantidadDeNodos (altaLista* l)
	cantidadDeNodos:
		;rdi = l
		xor r8, r8 ;limpio r8 cantidadDeEstudiantes = 0
		mov rsi, [rdi + OFFSET_PRIMERO]	
		cmp rsi, 0
		je finCantidadDeNodos
		jmp cicloCantidadDeNodos
	
	cicloCantidadDeNodos:
		cmp rsi, 0 ; (nodoActual != NULL)
		je finCantidadDeNodos
		inc r8 ; cantidadEstudiantes++
		mov rsi, [rsi + OFFSET_SIGUIENTE]

	finCantidadDeNodos:
		mov rax, r8
		ret

	;int sumaEdades (altaLista* l)
	sumaEdades:
	;rdi = l
		xor r8, r8 ;limpio r8 suma = 0
		mov rsi, [rdi+OFFSET_PRIMERO]; nodoActual
		jmp cicloSumaEdades

	cicloSumaEdades
		cmp rsi, 0; (l->primero != NULL)
		je finSumaEdades
		xor rdx, rdx; limpio rdx
		mov rdx, [rsi+OFFSET_DATO]
		mov rdx, [rdx+OFFSET_EDAD] ;((estudiante*)nodoActual->dato)->edad;
		add r8, rdx
		mov rsi, [rsi + OFFSET_SIGUIENTE] ;nodoActual = nodoActual->siguiente;
		jmp cicloSumaEdades
		
	finSumaEdades
		mov rax, r8
		ret

