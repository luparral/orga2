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
	;global insertarOrdenado
	;global filtrarAltaLista

; YA IMPLEMENTADAS EN C
	extern string_iguales
	extern malloc
	extern free
	extern insertarAtras
	extern fprintf
	extern fopen
	extern fclose


;AUXILIARES
	global string_longitud
	global string_menor
	global sumaEdades
	global cantidadDeNodos
	global string_copiar


; /** DEFINES **/    >> SE RECOMIENDA COMPLETAR LOS DEFINES CON LOS VALORES CORRECTOS
	%define NULL 	0
	%define TRUE 	1
	%define FALSE 	0

	%define ALTALISTA_SIZE     		16 ;tamaño de la altaLista
	%define OFFSET_PRIMERO 			0 ; 8
	%define OFFSET_ULTIMO  			8 ; 8

	%define NODO_SIZE     			24 ;
	%define OFFSET_SIGUIENTE   		0 ; 8
	%define OFFSET_ANTERIOR   		8 ; 8
	%define OFFSET_DATO 			16 ; 8 

	%define ESTUDIANTE_SIZE  		20 ; 20
	%define OFFSET_NOMBRE 			0 ; 8
	%define OFFSET_GRUPO  			8 ; 8
	%define OFFSET_EDAD 			16 ; 4


section .rodata


section .data
	
	imprimirEstudianteFormato: DB '%s', 10, 9, '%s', 10, 9, '%d', 10, 0
	vaciaFormato: db "<vacia>", 10, 0
	formatoApendear:db "w", 0

section .text

;/** FUNCIONES OBLIGATORIAS DE ESTUDIANTE **/   
;---------------------------------------------------------------------------------------------------------------

	; estudiante *estudianteCrear( char *nombre, char *grupo, unsigned int edad )----------
	estudianteCrear:
		;RDI = nombre
		;RSI = grupo
		;RDX = edad
		push rbp
		mov rbp, rsp
		push r12
		push r13
		push r14
		sub rsp, 8

		mov r12, rdi ;nombre -rcx
		mov r13, rsi ;grupo 
		mov r14, rdx ;edad 

		mov rdi, r12
		call string_copiar
		mov r12, rax

		mov rdi, r13	
		call string_copiar
		mov r13, rax

		mov rdi, ESTUDIANTE_SIZE
		call malloc

		mov rbx, rax

		mov [rbx + OFFSET_NOMBRE], r12
		mov [rbx + OFFSET_GRUPO], r13
		mov [rbx + OFFSET_EDAD], r14

		add rsp, 8
		pop r14
		pop r13
		pop r12
		pop rbp
		ret

	;void estudianteBorrar( estudiante *e )------------------------------------------------
	estudianteBorrar:
		;rdi = estudiante
		push rbp
		mov rbp, rsp
		push r12
		sub rbp, 8

		mov r12, rdi
		mov rdi, [r12+OFFSET_NOMBRE]
		call free
		mov rdi, [r12 + OFFSET_GRUPO]
		call free
		mov qword [r12 + OFFSET_EDAD], NULL
		mov rdi, r12
		call free
	
		add rbp, 8
		pop r12
		pop rbp
		ret

	; bool menorEstudiante( estudiante *e1, estudiante *e2 )-------------------------
	menorEstudiante:
		;rdi e1
		;rsi e2
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		sub rsp, 8

		mov r12, rdi
		mov r13, rsi

		call string_menor
		cmp al, TRUE
		je esMenor

		mov rdi, r12
		mov rsi, r13
		call string_iguales
		cmp al, TRUE
		je sonIgualesLosEstudiantes
		jmp noEraMenor ;completar

	sonIgualesLosEstudiantes:
		mov rbx, [r12 + OFFSET_EDAD] 
		cmp rbx, [r13 + OFFSET_EDAD]
		jle esMenor
		jmp noEraMenor

	esMenor:
		mov al, TRUE
		jmp terminar

	noEraMenor:
		mov al, FALSE
		jmp terminar

	terminar:
		add rsp, 8
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret


	; void estudianteConFormato( estudiante *e, tipoFuncionModificarString f )
	estudianteConFormato:
		;rdi = e
		;rsi = f
		push rbp
		mov rbp, rsp
		push r12
		push r13
		
		mov r12, rdi
		mov r13, rsi
		mov rdi, [r12+OFFSET_NOMBRE]
		call r13
		mov rdi, [r12+OFFSET_GRUPO]
		call r13

		pop r13
		pop r12
		pop rbp
		ret


	; void estudianteImprimir( estudiante *e, FILE *file )---------------------------------
	estudianteImprimir:
		push rbp
		mov rbp, rsp
		push r14
		push rbx
		
   		mov rbx, rdi ;estudiante
		mov r14, rsi; file
		mov rdx, [rbx+OFFSET_NOMBRE]
		mov rcx, [rbx+OFFSET_GRUPO]
		mov r8, [rbx+OFFSET_EDAD]   
		mov rdi, r14
		mov rsi, imprimirEstudianteFormato
		call fprintf

		pop rbx
		pop r14
		pop rbp
		ret

	;/** FUNCIONES OBLIGATORIAS DE NODO **/ 
	;---------------------------------------------------------------------------------------------------------------
	;nodo *nodoCrear( void *dato )------------------------------------------------------------
	nodoCrear:
		; dato esta en rdi
		push rbp
		mov rbp, rsp
		push r12
		sub rsp, 8

		mov r12, rdi ; guardo el dato en r12
		mov rdi, NODO_SIZE
		call malloc ;en rax queda el puntero al nuevo nodo
		mov qword [rax + OFFSET_DATO], r12
		mov qword [rax + OFFSET_ANTERIOR], NULL
		mov qword [rax + OFFSET_SIGUIENTE], NULL
		
		add rsp, 8
		pop r12
		pop rbp
		ret

	; void nodoBorrar( nodo *n, tipoFuncionBorrarDato f )-----------------------------------------
	nodoBorrar:
		;rdi = nodo
		push rbp
		mov rbp, rsp
		push r12
		sub rsp, 8

		mov r12, rdi
		mov qword [r12 + OFFSET_SIGUIENTE], NULL
		mov qword [r12 + OFFSET_ANTERIOR], NULL
		mov rdi, [r12+OFFSET_DATO]
		call estudianteBorrar
		mov rdi, r12
		call free ;borro el nodo

		add rsp, 8
		pop r12
		pop rbp
		ret

	;/** FUNCIONES OBLIGATORIAS DE ALTALISTA **/   
	;---------------------------------------------------------------------------------------------------------------

	; altaLista *altaListaCrear( void )------------------------------------------------------
	altaListaCrear:
		push rbp
		mov rbp, rsp
		
		mov rdi, ALTALISTA_SIZE
		call malloc
		mov qword [rax + OFFSET_PRIMERO], NULL
		mov qword [rax + OFFSET_ULTIMO], NULL
		
		pop rbp
		ret

	; void altaListaBorrar( altaLista *l, tipoFuncionBorrarDato f )---------------------------
	altaListaBorrar:
		;rdi = l

		push rbp
		mov rbp, rsp
		push r12
		push r13
		push r14
		push r15
		push rbx
		sub rbp, 8

		mov r12, rdi
		mov r13, [r12 + OFFSET_PRIMERO]
		cmp r13, NULL 
		jne hayUnElemento ;l->primero != NULL
		jmp finBorrar


	hayUnElemento:
		;r14 rcx nodoActual = l->primero
		;r15 rdx nodoSiguiente = l->primero->siguiente
		;rbx r8 nodoABorrar = nodoActual
		mov r14, [r12 + OFFSET_PRIMERO]
		mov r15, [r14 + OFFSET_SIGUIENTE] ;esto esta bien para apuntar al siguiente?
		mov rbx, r14
		cmp r15, NULL
		jne hayOtroElemento
		jmp borrarNodo

	hayOtroElemento:
		;r14 rcx : nodoActual = nodoSiguiente
		;r15 rdx : nodoSiguiente = nodoSiguiente->siguiente
		;rbx r8: nodoABorrar = nodoActual
		mov r14, r15
		mov r15, [r14 + OFFSET_SIGUIENTE] ;esto esta bien?
		mov rdi, rbx
		call nodoBorrar ;supuestamente se va a borrar lo que esta en rdi, que es r8
		mov rbx, r14
		cmp r15, NULL
		jne hayOtroElemento
		jmp borrarNodo

	borrarNodo:

		mov rdi, r14
		call nodoBorrar ;supuestamente se va a borrar lo que esta en rdi, que es rcx
		jmp finBorrar

	finBorrar:
		mov qword [r9 + OFFSET_PRIMERO], NULL
		mov qword [r9 + OFFSET_ULTIMO], NULL
		call free
		
		add rbp, 8
		pop rbx
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbp
		ret

	;void altaListaImprimir( altaLista *l, char *archivo, tipoFuncionImprimirDato f )-----------
	altaListaImprimir:
		;rdi = l
		;rsi = archivo
		;rdx = f
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14
		push r15
		sub rbp, 8

		mov rbx, rdi ;altaLista
		mov r12, rsi ;archivo
		mov r13, rdx ;f

		mov rdi, r12
		mov rsi, formatoApendear
		call fopen

		mov r14, rax ; archivo abierto

		mov r15, [rbx+OFFSET_PRIMERO] ; nodoActual = l->primero
		cmp r15, NULL ;nodoActual == NULL?
		je altaListaVacia
		mov r12, [r15+OFFSET_SIGUIENTE] ;nodoActual->siguiente
		cmp r12, NULL ;NodoSiguiente = nodoActual->siguiente == NULL?
		je altaListaDeUnNodo
		;mov r9, r15 ;nodoSiguiente = nodoActual->siguiente
		jmp cicloImprimirAltaLista

	cicloImprimirAltaLista:
		cmp r12, NULL ;nodoSiguiente == NULL?
		je terminarDeImprimir
		mov r8, [r15+OFFSET_DATO]
		mov rdi, r8 ;imprimir estudiante actual

		mov rdx, [r8+OFFSET_NOMBRE];


		mov rsi, r14 
		call estudianteImprimir
		mov r15, r12 ; nodoactual = nodoSiguiente
		mov r12, [r12 + OFFSET_SIGUIENTE]
		jmp cicloImprimirAltaLista

	altaListaDeUnNodo:
		lea r8, [r15+OFFSET_DATO]
		mov rdi, r8

		;mov rdi, r15
		mov rsi, r14
		call estudianteImprimir
		jmp terminarDeImprimir

	altaListaVacia:
		mov rdi, r14
		mov rsi, vaciaFormato
		call fprintf
		jmp terminarDeImprimir
		
	terminarDeImprimir:
		mov r8, [r15+OFFSET_DATO]
		mov rdi, r8
		;mov rdi, [r15+OFFSET_DATO] ;imprimir nodo actual
		mov rsi, r14
		call estudianteImprimir

		mov rdi, r14
		call fclose

		add rbp, 8
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp

	;/** FUNCIONES AVANZADAS **/  
	;---------------------------------------------------------------------------------------------------------------
	
	; float edadMedia( altaLista *l )------------------------------------------------------
	edadMedia:
		;rdi = l
		push rbp
		mov rbp, rsp
		push r12
		push r13
		push r14
		sub rbp, 8

		mov r12, rdi	
		call cantidadDeNodos
		mov r13, rax ;guardo en rsi la cantidadEstudiantes
		
		xor rax, rax

		mov rdi, r12
		call sumaEdades
		mov r14, rax
		cvtsi2ss xmm0, r14
		cvtsi2ss xmm1, r13
		divss xmm0, xmm1
		
		add rbp, 8
		pop r14
		pop r13
		pop r12
		pop rbp
		ret


	;/** FUNCIONES AUXILIARES DE STRINGS**/    
	;---------------------------------------------------------------------------------------------------------------

	;char *string_copiar( char *s )----------------------------------------------------------
	string_copiar:
		;rdi = string a copiar
		push rbp
		mov rbp, rsp
		push r12
		push r13
		push r14
		push rbx

		mov r12, rdi ; en r12 queda el string a copiar
		call string_longitud ;longitud del string
		;rax <- |string|
		inc rax ;+1 para el caracter del final
		;en rax esta la longitud del string +1
		mov rdi, rax
		call malloc
		;rax <- puntero al primero
		mov r13, rax ;copio el puntero al string nuevo de rax a r13
		mov rbx, r13
		xor r14, r14 ;i = 0
		jmp cicloCopiar

	cicloCopiar:
		;en r12 tengo el string original
		;en r13 tengo el puntero de la direccion nueva
		cmp byte [r12+r14], 0 ;llegue al final del string que estoy copiando
		je finCopiar
		mov al, [r12 + r14] ;char que quiero copiar		
		mov [r13 + r14], al ;lo copio en la direccion correcta
		inc r14
		jmp cicloCopiar

	finCopiar:
		add r13, r14
		mov al, [r12 + r14] ;char que quiero copiar		
		mov [r13], al ;lo copio en la direccion correcta
		
		mov rax, rbx
		pop rbx
		pop r14
		pop r13
		pop r12
		pop rbp
		ret
	
	;unsigned char string_longitud( char *s )--------------------------------------------------
	string_longitud:
		;s esta en rdi
		push rbp
		mov rbp, rsp
		push r12
		push r13
		push rbx
		sub rbp, 8

		mov r12, rdi
		xor r13, r13 ;i = 0
		jmp cicloStringLongitud

	cicloStringLongitud:
		mov al, [r12 + r13] 
		cmp al, 0 ;chequear si llegue a cero?
		je finStringLongitud
		inc r13
		jmp cicloStringLongitud

	finStringLongitud:
		mov rax, r13	
		add rbp, 8
		pop rbx
		pop r13
		pop r12
		pop rbp
		ret

	;bool string_menor(char *s1, char *s2){ //s1 < s2-------------------------------------
	string_menor:
		;rdi: s1
		;rsi: s2
		push rbp
		mov rbp, rsp

		mov r12, rdi ;r12 = s1
		mov r13, rsi ;r13 = s2
		call string_iguales
		cmp rax, TRUE
		je sonIgualesStringMenor
		xor r14, r14; i = 0
		mov al, FALSE; pongo al en false
		jmp cicloStringMenor

	cicloStringMenor:
		mov bl, [r12 + r14]
		mov cl, [r13 + r14]
		cmp bl, 0 ;(s1[i]!=0)
		je finStringMenor
		cmp cl, 0 ; s2[i]==0
		je finStringMenor
		cmp bl, cl; (s1[i]>s2[i])
		jg s1MayorAs2
		jl s1MenorAs2 ; (s1[i]<s2[i])
		mov al, TRUE
		inc r14
		jmp cicloStringMenor

	s1MenorAs2:
		mov al, TRUE
		jmp finStringMenor
 	
	s1MayorAs2:
		mov al, FALSE		
		jmp finStringMenor

	finStringMenor:
		pop rbp
		ret ;aca estoy devolviendo al?

	sonIgualesStringMenor:
		mov al, FALSE
		jmp finStringMenor



	;/** OTRAS FUNCIONES AUXILIARES**/ 
	;---------------------------------------------------------------------------------------------------------------
	
 	;int cantidadDeNodos (altaLista* l)-----------------------------------------------------
 	cantidadDeNodos:
		;rdi = l
		push rbp
		mov rbp, rsp

		xor r13, r13 ;limpio r13 cantidadDeEstudiantes = 0
		mov r14, [rdi + OFFSET_PRIMERO]	
		cmp r14, 0
		je finCantidadDeNodos
		jmp cicloCantidadDeNodos
	
	cicloCantidadDeNodos:
		cmp r14, 0 ; (nodoActual != NULL)
		je finCantidadDeNodos
		inc r13 ; cantidadEstudiantes++
		mov r14, [r14 + OFFSET_SIGUIENTE]
		jmp cicloCantidadDeNodos

	finCantidadDeNodos:
		mov rax, r13
		pop rbp
		ret

	;int sumaEdades (altaLista* l)----------------------------------------------------------
	sumaEdades:
	;rdi = l
		push rbp
		mov rbp, rsp

		xor r8, r8 ;limpio r8 suma = 0
		mov rsi, [rdi+OFFSET_PRIMERO]; nodoActual
		jmp cicloSumaEdades

	cicloSumaEdades:
		cmp rsi, 0; (l->primero != NULL)
		je finSumaEdades
		xor rdx, rdx; limpio rdx
		mov rdx, [rsi+OFFSET_DATO]
		mov rdx, [rdx+OFFSET_EDAD] ;((estudiante*)nodoActual->dato)->edad;
		add r8, rdx
		mov rsi, [rsi + OFFSET_SIGUIENTE] ;nodoActual = nodoActual->siguiente;
		jmp cicloSumaEdades
		
	finSumaEdades:
		mov rax, r8
		pop rbp
		ret

	
