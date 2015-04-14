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

		;guardo los parametros
		mov r12, rdi ;nombre -rcx
		mov r13, rsi ;grupo 
		mov r14d, edx ;edad 

		;copio el nombre
		mov rdi, r12
		call string_copiar
		mov r12, rax

		;copio el grupo
		mov rdi, r13	
		call string_copiar
		mov r13, rax

		mov rdi, ESTUDIANTE_SIZE
		call malloc

		mov rbx, rax

		;guardo los datos
		mov [rbx + OFFSET_NOMBRE], r12
		mov [rbx + OFFSET_GRUPO], r13
		mov [rbx + OFFSET_EDAD], r14d

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
		sub rsp, 8

		;guardo el estudiante
		mov r12, rdi

		;libero el string de nombre
		mov rdi, [r12+OFFSET_NOMBRE]
		call free

		;libero el string de grupo
		mov rdi, [r12 + OFFSET_GRUPO]
		call free

		;borro el int de edad
		mov dword [r12 + OFFSET_EDAD], NULL
		
		;libero el estudiante
		mov rdi, r12
		call free
	
		add rsp, 8
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

		;guardo los estudiantes
		mov r12, rdi
		mov r13, rsi

		;pongo en los parametros para la funcion los strings de los nombres
		mov rdi, [r12+OFFSET_NOMBRE]
		mov rsi, [r13+OFFSET_NOMBRE]

		;comparo si son menores
		call string_menor
		cmp al, TRUE
		je esMenor

		;si no son menores, comparo si son iguales
		mov rdi, [r12+OFFSET_NOMBRE]
		mov rsi, [r13+OFFSET_NOMBRE]
		
		call string_iguales
		cmp al, TRUE
		je sonIgualesLosEstudiantes

		;no son menores ni iguales
		jmp noEraMenor

	sonIgualesLosEstudiantes:
		mov dword ebx, [r12 + OFFSET_EDAD] 
		cmp dword ebx, [r13 + OFFSET_EDAD]
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
		
		;guardo los parametros
		mov r12, rdi
		mov r13, rsi
		
		;llamo a la funcion de modificar con el nombre
		mov rdi, [r12+OFFSET_NOMBRE]
		call r13

		;llamo a la funcion de modificar con el nombre
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

		;preparo los parametros para el template
		mov rdx, [rbx+OFFSET_NOMBRE]
		mov rcx, [rbx+OFFSET_GRUPO]
		mov dword r8d, [rbx+OFFSET_EDAD]   
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

		;guardo el dato
		mov r12, rdi

		;creo el nodo, el resultado queda en rax
		mov rdi, NODO_SIZE
		call malloc

		;guardo los datos en el nodo
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
		;rsi = funcion borrar
		push rbp
		mov rbp, rsp
		push r12
		push r13

		;guardo los parametros
		mov r12, rdi
		mov r13, rsi

		;limpio los punteros
		mov qword [r12 + OFFSET_SIGUIENTE], NULL
		mov qword [r12 + OFFSET_ANTERIOR], NULL

		;borro el dato
		mov rdi, [r12+OFFSET_DATO]
		call r13

		;borro el nodo
		mov rdi, r12
		call free ;borro el nodo

		pop r13
		pop r12
		pop rbp
		ret

	;/** FUNCIONES OBLIGATORIAS DE ALTALISTA **/   
	;---------------------------------------------------------------------------------------------------------------

	; altaLista *altaListaCrear( void )------------------------------------------------------
	altaListaCrear:
		push rbp
		mov rbp, rsp
		
		;creo alta lista
		mov rdi, ALTALISTA_SIZE
		call malloc

		;asigno punteros
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
		sub rsp, 8

		;guardo los parametros
		mov r12, rdi
		mov r13, [r12 + OFFSET_PRIMERO]
		
		;chequeo si la lista es vacia
		cmp r13, NULL 
		jne hayUnElemento ;l->primero != NULL
		jmp laListaEsVacia

	laListaEsVacia:
		jmp terminarDeBorrarLista


	hayUnElemento:
		;r14 rcx nodoActual = l->primero
		;r15 rdx nodoSiguiente = l->primero->siguiente
		;rbx r8 nodoABorrar = nodoActual
		mov r14, [r12 + OFFSET_PRIMERO]
		mov r15, [r14 + OFFSET_SIGUIENTE]
		mov rbx, r14
		cmp r15, NULL
		jne cicloParaBorrar
		jmp borrarUnicoNodo

	cicloParaBorrar:
		;r14 rcx : nodoActual = nodoSiguiente
		;r15 rdx : nodoSiguiente = nodoSiguiente->siguiente
		;rbx r8: nodoABorrar = nodoActual
		mov r14, r15
		mov r15, [r14 + OFFSET_SIGUIENTE]
		mov rdi, rbx
		call nodoBorrar
		mov rbx, r14
		cmp r15, NULL
		jne cicloParaBorrar
		jmp borrarUnicoNodo

	borrarUnicoNodo:
		mov rdi, r14
		call nodoBorrar
		jmp terminarDeBorrarLista


	terminarDeBorrarLista:
		mov rdi, r12
		call free
		add rsp, 8
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
		sub rsp, 8

		;guardo los parametros
		mov rbx, rdi ;altaLista
		mov r12, rsi ;archivo
		mov r13, rdx ;f

		;preparo el formato y abro el archivo
		mov rdi, r12
		mov rsi, formatoApendear
		call fopen
		mov r14, rax ; archivo abierto

		;chequeo si la lista es vacia
		mov r15, [rbx+OFFSET_PRIMERO] ; nodoActual = l->primero
		cmp r15, NULL ;nodoActual == NULL?
		je altaListaVacia
		
		;chequeo si es la lista de un nodo
		mov r12, [r15+OFFSET_SIGUIENTE] ;nodoActual->siguiente
		cmp r12, NULL ;NodoSiguiente = nodoActual->siguiente == NULL?
		je altaListaDeUnNodo
		;mov r9, r15 ;nodoSiguiente = nodoActual->siguiente
		jmp cicloImprimirAltaLista

	cicloImprimirAltaLista:
		;chequeo si no hay proximo nodo
		cmp r12, NULL
		je terminarDeImprimirCiclo

		;preparo para imprimir al estudiante actual
		mov r8, [r15+OFFSET_DATO]
		mov rdi, r8
		mov rsi, r14 
		
		;imprimo estudiante
		call r13

		;avanzo un actual y siguiente
		mov r15, r12
		mov r12, [r12 + OFFSET_SIGUIENTE]
		jmp cicloImprimirAltaLista

	altaListaDeUnNodo:
		;preparo para imprimir al unico estudiante
		mov r8, [r15+OFFSET_DATO]
		mov rdi, r8
		mov rsi, r14

		;imprimo al unico estudiante
		call r13
		jmp terminarDeImprimir

	altaListaVacia:
	 	;imprimo con el formato de lista vacia
		mov rdi, r14
		mov rsi, vaciaFormato
		call fprintf
		jmp terminarDeImprimir
		
	terminarDeImprimirCiclo:
		;preparo para imprimir el ultimo estudiante
		mov r8, [r15+OFFSET_DATO]
		mov rdi, r8
		mov rsi, r14
		
		;imprimo ultimo estudiante
		call r13
		jmp terminarDeImprimir
	
	terminarDeImprimir:
		;cierro el archivo
		mov rdi, r14
		call fclose

		add rsp, 8
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	;/** FUNCIONES AVANZADAS **/  
	;---------------------------------------------------------------------------------------------------------------
	;void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f )
		;Preservar RBX, R12, R13, R14, R15
	insertarOrdenado:
		push rbp
		mov rbp, rsp
		push r12
		push r13
		push r14
		push rbx
		push r15
		sub rsp, 8

		;guardo los parametros
		mov r12, rdi ;lista
		mov r13, rsi ;dato
		mov r14, rdx ;f

		;guardo el primero de la lista
		mov rbx, [r12+OFFSET_PRIMERO] ;nodoActual
		cmp rbx, NULL
		je insertarEnListaVacia 
		jmp insertarEnListaNoVacia

	insertarEnListaVacia:
		mov rdi, r12
		mov rsi, r13
		call insertarAtras
		jmp terminarDeInsertar

	insertarEnListaNoVacia:
		;creo nuevo nodo
		mov rdi, r13
		call nodoCrear
		mov r15, rax ;direccion del nuevo nodo
		jmp cicloInsertarNodo

	cicloInsertarNodo:
		cmp rbx, NULL ;nodoActual != NULL
		je finDelCiclo

		;preparo los params para llamar a menorEstudiante
		mov r9, [rbx+OFFSET_DATO] ;nodoActual->dato
		mov rdi, r13
		mov rsi, r9 
		
		;llamo a menorEstudiante
		call r14
		cmp al, TRUE
		je elDatoEsMenor
		jmp elDatoNoEsMenor


	elDatoEsMenor:
		;chequeo si el nodoActual es el primero
		cmp rbx, [r12+OFFSET_PRIMERO]
		je esMenorQueElPrimero
		jmp esMayorQueElPrimero

	elDatoNoEsMenor:
		mov rbx, [rbx+OFFSET_SIGUIENTE]
		jmp cicloInsertarNodo

	esMenorQueElPrimero:
		mov [r12+OFFSET_PRIMERO], r15
		mov [r15+OFFSET_SIGUIENTE],rbx
		mov qword [r15+OFFSET_ANTERIOR], NULL
		mov [rbx + OFFSET_ANTERIOR], rbx
		jmp finDelCiclo

	esMayorQueElPrimero:
		mov [r15+OFFSET_SIGUIENTE], rbx
		mov rcx, [rbx+OFFSET_ANTERIOR]
		mov [r15+OFFSET_ANTERIOR], rcx
		mov r10, [rbx+OFFSET_ANTERIOR] ;nodoActual->anterior
		mov [r10+OFFSET_SIGUIENTE], r15 ;nodoActual->anterior->siguiente
		mov [rbx+OFFSET_ANTERIOR], r15
		jmp finDelCiclo

	finDelCiclo:
		mov r11, [r12+OFFSET_ULTIMO] ;l->ultimo
		mov r11, [r11 + OFFSET_DATO] ;l->ultimo->dato

		mov rdi, r11
		mov rsi, r13
		call r14

		cmp al, TRUE
		je esMayorQueElUltimo
		jmp terminarDeInsertar

	esMayorQueElUltimo:
		mov rbx, [r12+OFFSET_ULTIMO] ;nodoActual = l->ultimo
		mov qword [r15+OFFSET_SIGUIENTE], NULL
		mov [r15+OFFSET_ANTERIOR], rbx
		mov [rbx+OFFSET_SIGUIENTE], r15
		mov [r12+OFFSET_ULTIMO], r15
		jmp terminarDeInsertar

	terminarDeInsertar:
		add rsp, 8
		pop r15
		pop rbx
		pop r14
		pop r13
		pop r12
		pop rbp
		ret	




	; float edadMedia( altaLista *l )------------------------------------------------------
	edadMedia:
		;rdi = l
		push rbp
		mov rbp, rsp
		push r12
		push r13
		push r14
		sub rsp, 8

		;guardo los parametros
		mov r12, rdi	
		
		;obtengo la cantidad de nodos de la lista
		call cantidadDeNodos
		mov r13, rax
		

		xor rax, rax

		;obtengo la suma de todas las edades de los estudiantes
		mov rdi, r12
		call sumaEdades
		mov r14, rax

		;convierto los ints a floats
		cvtsi2ss xmm0, r14
		cvtsi2ss xmm1, r13

		;divido y devuelvo por xmm0
		divss xmm0, xmm1
		
		add rsp, 8
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

		;guardo el string a copiar
		mov r12, rdi

		;pido memoria para la longitud del string + 1 para el caracter final
		call string_longitud
		inc rax
		mov rdi, rax
		call malloc

		;copio el puntero al nuevo string en r13 e inicializo el contador en 0 en r14
		mov r13, rax
		mov rbx, r13
		xor r14, r14
		jmp cicloCopiar

	cicloCopiar:
		;en r12 tengo el string original
		;en r13 tengo el puntero de la direccion nueva
		
		;miro si llegue al final del string que estoy copiando
		cmp byte [r12+r14], 0
		je finCopiar

		;el char que quiero copiar
		mov al, [r12 + r14]
		;lo copio en la nueva direccion creada
		mov [r13 + r14], al
		inc r14
		jmp cicloCopiar

	finCopiar:
		;copio el ultimo char
		add r13, r14
		mov al, [r12 + r14]	
		mov [r13], al
		
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
		sub rsp, 8

		;guardo el string e inicializo el contador en r13 en 0
		mov r12, rdi
		xor r13, r13 
		jmp cicloStringLongitud

	cicloStringLongitud:
		;chequeo si llegue al final del string
		mov al, [r12 + r13] 
		cmp al, 0
		je finStringLongitud

		;incremento contador e itero
		inc r13
		jmp cicloStringLongitud

	finStringLongitud:
		mov rax, r13	
		add rsp, 8
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
		push r12
		push r13
		push r14
		push rbx


		;guardo los strings: r12 = s1 y r13 = s2
		mov r12, rdi
		mov r13, rsi

		;miro si son iguales
		call string_iguales
		cmp al, TRUE
		je sonIgualesStringMenor
		
		;si no son iguales, inicializo en r14 un contador en 0 y loopeo
		xor r14, r14
		mov al, FALSE
		jmp cicloStringMenor

	cicloStringMenor:
		;comparo los dos primeros chars
		mov bl, [r12 + r14]
		mov cl, [r13 + r14]

		;si s1[0] es igual a 0 llegue al final del primer string
		cmp bl, 0
		je maguitoTeAmo
		
		;si s2[0] es igual a 0 llegue al final del segundo string
		cmp cl, 0
		je teHagoTodoMaguito
 
 		;me fijo si (s1[i]>s2[i]) o  (s1[i]<s2[i])
		cmp bl, cl
		jl s1MenorAs2
		jg s1MayorAs2
		mov al, TRUE

		;sino incremento el contador y vuelvo al loop
		inc r14
		jmp cicloStringMenor

	s1MenorAs2:
		mov al, TRUE
		jmp finStringMenor
 	
	s1MayorAs2:
		mov al, FALSE		
		jmp finStringMenor

	finStringMenor:
		pop rbx
		pop r14
		pop r13
		pop r12	
		pop rbp
		ret

	sonIgualesStringMenor:
		mov al, FALSE
		jmp finStringMenor

	maguitoTeAmo:
		mov al, TRUE
		jmp finStringMenor

	teHagoTodoMaguito:
		mov al, FALSE
		jmp finStringMenor



	;/** OTRAS FUNCIONES AUXILIARES**/ 
	;---------------------------------------------------------------------------------------------------------------
	
 	;int cantidadDeNodos (altaLista* l)-----------------------------------------------------
 	cantidadDeNodos:
		;rdi = l
		push rbp
		mov rbp, rsp

		;inicializo contador en r13 en 0
		xor r13, r13
		mov r14, [rdi + OFFSET_PRIMERO]	
		
		;miro si es la lista vacia
		cmp r14, 0
		je finCantidadDeNodos
		jmp cicloCantidadDeNodos
	
	cicloCantidadDeNodos:
		;si el nodo actual es NULL, termine
		cmp r14, 0
		je finCantidadDeNodos
		
		;sino, avanzo el nodo e incremento el contador y vuelvo al ciclo
		inc r13
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

		;inicializo acumulador en r8d en 0 y obtengo el nodo actual
		xor r8d, r8d
		mov rsi, [rdi+OFFSET_PRIMERO]
		jmp cicloSumaEdades

	cicloSumaEdades:
		;si el nodo actual es NULL termine
		cmp rsi, 0
		je finSumaEdades

		;sino obtengo la edad y la sumo en r8d
		xor rdx, rdx
		mov rdx, [rsi+OFFSET_DATO]
		mov ecx, [rdx+OFFSET_EDAD]
		add r8d, ecx

		;avanzo el nodo
		mov rsi, [rsi + OFFSET_SIGUIENTE]
		jmp cicloSumaEdades
		
	finSumaEdades:
		mov eax, r8d
		pop rbp
		ret

	
