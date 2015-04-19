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
	formatoApendear:db "a", 0

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
		mov r12, rdi ;lista
		mov r13, [r12 + OFFSET_PRIMERO] ;nodoActual
		mov rbx, rsi ;f

		;chequeo si la lista es vacia
		cmp r13, NULL 
		jne hayUnElemento ;l->primero != NULL
		jmp laListaEsVacia

	laListaEsVacia:
		jmp terminarDeBorrarLista


	hayUnElemento:
		;r14 nodoActual = l->primero
		;r15 nodoSiguiente = l->primero->siguiente
		;rbx nodoABorrar = nodoActual
		mov r14, [r12 + OFFSET_PRIMERO]
		mov r15, [r14 + OFFSET_SIGUIENTE]
		mov rdx, r14
		cmp r15, NULL
		jne cicloParaBorrar
		jmp borrarUnicoNodo

	cicloParaBorrar:
		;r14: nodoActual = nodoSiguiente
		;r15: nodoSiguiente = nodoSiguiente->siguiente
		;rbx: nodoABorrar = nodoActual
		mov r14, r15
		mov r15, [r14 + OFFSET_SIGUIENTE]
		mov rdi, rdx
		mov rsi, rbx
		call nodoBorrar
		mov rdx, r14
		cmp r15, NULL
		jne cicloParaBorrar
		jmp borrarUnicoNodo

	borrarUnicoNodo:
		mov rdi, r14
		mov rsi, rbx
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
		je finString1
		
		;si s2[0] es igual a 0 llegue al final del segundo string
		cmp cl, 0
		je finString2
 
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

	finString1:
		mov al, TRUE
		jmp finStringMenor

	finString2:
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


	; void filtrarAltaLista( altaLista *l, tipoFuncionCompararDato f, void *datoCmp )---------------------------------------------
	filtrarAltaLista:
		push rbp
		mov	rbp, rsp
		push rbx
		push r15
		push r14
		push r13
		push r12
		sub rsp, 8

		mov r12, rdi ;lista
		mov r14, rsi ;f
		mov r13, rdx ;datoCmp
		mov r15, [r12 + OFFSET_PRIMERO] ;nodoActual

	cicloFiltrarAltaLista:
		;si nodoActual es NULL termine la lista o es vacia
		cmp r15, NULL
		je finCicloFiltrarAltaLista

		;sino, comparo los datos
		mov rdi, [r15 + OFFSET_DATO] ;datoActual
		mov rsi, r13 ;datoCmp
		call r14 ;f(actual,cmp) 

		;si actual < cmp es false: voy a tener que borrar
		cmp al, FALSE
		je hayQueBorrarElNodo

		;sino, avanzo en la lista
		mov r15, [r15 + OFFSET_SIGUIENTE]
		jmp cicloFiltrarAltaLista

	hayQueBorrarElNodo:
		;guardo los nodos anterior y siguiente al actual
		mov rbx, [r15 + OFFSET_SIGUIENTE]
		mov rsi, [r15 + OFFSET_ANTERIOR]
		
		;si el siguiente es null, entonces estoy borrando el ultimo nodo
		cmp qword [r15 + OFFSET_SIGUIENTE], NULL
		je borrarElultimoNodo

		;si el anterior es null, entonces estoy borrando el primer nodo
		cmp qword [r15 + OFFSET_ANTERIOR], NULL
		je borrarElPrimerNodo
		
		;sino, no es ni el primero ni el ultimo		
		jmp elNodoABorrarNoEsPrimeroNiUltimo

	elNodoABorrarNoEsPrimeroNiUltimo:
		;reestablezco el invariante de la lista para los nodos vecinos del que voy a borrar
		;nodoActual->siguiente->anterior = nodoActual->anterior
		;nodoActual->anterior->siguiente = nodoActual->siguiente
		mov [rbx + OFFSET_ANTERIOR], rsi
		mov [rsi + OFFSET_SIGUIENTE], rbx
		
		;borro el nodo
		mov rdi, r15
		mov rsi, estudianteBorrar
		call nodoBorrar
		
		;avanzo en la lista
		mov r15, rbx
		jmp cicloFiltrarAltaLista

	borrarElultimoNodo:
		;si el nodo anterior al actual es null, entonces es la lista de un solo nodo, si no, hay mas nodos en la lista
		mov rbx, [r15 + OFFSET_ANTERIOR]
		cmp rbx, NULL
		je esUltimoYUnicoNodo
		jmp esUltimoPeroNoUnico

	esUltimoPeroNoUnico:
		;guardo el nodo anterior al ultimo.
		mov rbx, [r12+OFFSET_ULTIMO]
		mov rbx, [rbx + OFFSET_ANTERIOR]
		
		;borro el ultimo nodo
		mov rdi, [r12+OFFSET_ULTIMO]
		mov rsi, estudianteBorrar
		call nodoBorrar

		;el nodo anterior al borrado es ahora el ultimo de la lista. Se reestablece el invariante.
		mov qword [rbx + OFFSET_SIGUIENTE], NULL
		mov [r12 + OFFSET_ULTIMO], rbx

		;como borre al ultimo, termino
		jmp finCicloFiltrarAltaLista

	esUltimoYUnicoNodo:				
		;borro el ultimo nodo
		mov rdi, [r12 + OFFSET_ULTIMO]
		mov rsi, estudianteBorrar
		call nodoBorrar

		;reestablezco el invariante de lista vacia y salgo
		mov qword [r12 + OFFSET_PRIMERO], NULL
		mov qword [r12 + OFFSET_ULTIMO], NULL
		jmp finCicloFiltrarAltaLista	

	borrarElPrimerNodo:
		;si el nodo siguiente al actual es NULL entonces es la lista con un solo nodo, caso contrario, la lista tiene mas de un nodo
		mov rbx, [r15 + OFFSET_SIGUIENTE]
		cmp rbx, NULL
		je esPrimeroYUnicoNodo
		jmp esPrimeroPeroNoUnico

	esPrimeroPeroNoUnico:
		;guardo el siguiente al primero
		mov rbx, [r12+OFFSET_PRIMERO]
		mov rbx, [rbx + OFFSET_SIGUIENTE]
		
		;borro el primer nodo
		mov rdi, [r12+OFFSET_PRIMERO]
		mov rsi, estudianteBorrar
		call nodoBorrar

		;pongo al siguiente del nodo borrado como primero de la lista, reestableciendo el invariante.
		mov qword [rbx + OFFSET_ANTERIOR], NULL
		mov [r12 + OFFSET_PRIMERO], rbx
		
		;avanzo y vuelvo al ciclo
		mov r15, rbx
		jmp cicloFiltrarAltaLista

	esPrimeroYUnicoNodo:				
		;borro al primer y unico nodo
		mov rdi, [r12 + OFFSET_PRIMERO]
		mov rsi, estudianteBorrar
		call nodoBorrar

		;reestablezo invariante de lista vacia y salgo.
		mov qword [r12 + OFFSET_PRIMERO], NULL
		mov qword [r12 + OFFSET_ULTIMO], NULL
		jmp finCicloFiltrarAltaLista			


	finCicloFiltrarAltaLista:
		add rsp, 8
		pop r12
		pop r13
		pop r14		
		pop r15
		pop rbx
		pop rbp
		ret

	 ;void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f )---------------------------------
	insertarOrdenado:
		push rbp
		mov	rbp, rsp
		push rbx
		push r15
		push r14
		push r13
		push r12
		sub rsp, 8

		mov rbx, rdi ;lista						
		mov r12, rsi ;dato				
		mov r15, rdx ;funcion

		mov r14, [rbx + OFFSET_PRIMERO] ;nodoActual
			
	cicloInsertarOrdenado:
		;me fijo si termine de recorrer la lista, si es asi, tengo que insertar al final de la lista y terminar el ciclo.
		cmp r14 , NULL
		jne laListaNoTermino
		mov rdi, rbx
		mov rsi, r12
		call insertarAtras
		jmp terminarInsertarOrdenado

	laListaNoTermino:	
		;comparo el dato pasado por parametro con el dato actual:
		;f(dato, nodoActual->dato)
		mov rdi, r12
		mov rsi, [r14 + OFFSET_DATO]
		call r15
		;si es menor, voy a insertar adelante del nodoActual
		cmp al, TRUE
		je insertarAntesDelNodoActual
		
		;sino, avanzo en el ciclo
		mov r14, [r14 + OFFSET_SIGUIENTE]
		jmp cicloInsertarOrdenado		

	insertarAntesDelNodoActual:
		mov rdi, r12
		call nodoCrear
		mov r15,rax

		mov r13, [r14 + OFFSET_ANTERIOR]
		;chequeo si el nodo actual es el primero
		cmp r13, NULL
		jne insertarAdelanteDeUnNodoCualquiera
		jmp insertarAdelanteDelPrimero


	insertarAdelanteDeUnNodoCualquiera:
	;reestablezo el invariante de los nodos. La lista mantiene el mismo primero que antes
		mov [r14 + OFFSET_ANTERIOR], r15	
		mov [r15 + OFFSET_ANTERIOR], r13
		mov [r15 + OFFSET_SIGUIENTE], r14
		mov [r13 + OFFSET_SIGUIENTE], r15
		jmp terminarInsertarOrdenado	
	
	insertarAdelanteDelPrimero:
	;reestablezo el invariante de la lista y los nodos, el nodo agregado es el nuevo primero
		mov [r14 + OFFSET_ANTERIOR], r15	
		mov [r15 + OFFSET_ANTERIOR], r13
		mov [r15 + OFFSET_SIGUIENTE], r14
		mov [rbx + OFFSET_PRIMERO], r15
		jmp terminarInsertarOrdenado
	

	terminarInsertarOrdenado:
		add rsp, 8
		pop r12
		pop r13
		pop r14
		pop r15
		pop rbx
		pop rbp
		ret