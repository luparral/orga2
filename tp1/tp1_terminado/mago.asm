; void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f )
	insertarOrdenado:
		;Building the stack frame
		push rbp
		mov	rbp, rsp
		;Backuping registers, for the C convention
		push r12
		push r13
		push r14
		push r15
		push rbx
		sub rsp, 8	;Aligning the misaligned stack

			mov r12, rdi ;lista						
			mov r13, rsi ;dato				
			mov r15, rdx ;funcion
			
			;r14 contendra siempre el puntero al próximo elemento a comparar
			mov r14, [r12 + OFFSET_PRIMERO]
			
			compararSiguienteNodo:
				cmp r14 , NULL 						;Si en un momento determinado, r14 == NULL
				je insertarAtrasYSalir				;entonces ya no quedan nodos a comparar, debo insertar al final
				
				; mov rbx, [r14 + OFFSET_SIGUIENTE]
				mov rdi, r13
				mov rsi, [r14 + OFFSET_DATO]
				call r15
				cmp al, TRUE
				je insertarAntesDeR14
				
				mov r14, [r14 + OFFSET_SIGUIENTE]	;r14 = r14.siguiente()

				jmp compararSiguienteNodo		

			insertarAtrasYSalir:
				mov rdi, r12
				mov rsi, r13
				call insertarAtras
				jmp terminarInsertarOrdenado

			insertarAntesDeR14:
				mov rdi, r13
				call nodoCrear
				mov r15,rax

				mov rbx, [r14 + OFFSET_ANTERIOR]	;Me guardo el anterior a r14 en rbx

				mov [r15 + OFFSET_ANTERIOR], rbx	;r15.anterior() = r14.anterior();
				mov [r15 + OFFSET_SIGUIENTE], r14 	;Linkeo r14 y r15
				mov [r14 + OFFSET_ANTERIOR], r15	

				cmp rbx, NULL
				je insertarAdelante
				
				mov [rbx + OFFSET_SIGUIENTE], r15
				jmp terminarInsertarOrdenado		

			insertarAdelante:
				mov [r12 + OFFSET_PRIMERO], r15

			terminarInsertarOrdenado:

		;Poping registers, for the C convention
		add rsp, 8
		pop rbx
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbp
		ret


	; void filtrarAltaLista( altaLista *l, tipoFuncionCompararDato f, void *datoCmp )
	filtrarAltaLista:
		;Building the stack frame
		push rbp
		mov	rbp, rsp
		;Backuping registers, for the C convention
		push r12
		push r13
		push r14
		push r15
		push rbx
		sub rsp, 8	;Aligning the misaligned stack

			mov r12, rdi
			mov r13, rsi
			mov r14, rdx

			cmp r12, NULL
			je filtradoTerminado

			mov rbx, [r12 + OFFSET_PRIMERO]

			revisarSiguienteParaFiltrar:
				cmp rbx, NULL
				je filtradoTerminado

				mov rdi, [rbx + OFFSET_DATO]
				mov rsi, r14
				call r13
				cmp al, FALSE
				je filtrarNodoRBX

				mov rbx, [rbx + OFFSET_SIGUIENTE]
				jmp revisarSiguienteParaFiltrar

			filtrarNodoRBX:
				mov rsi, [rbx + OFFSET_ANTERIOR]		;rsi = rbx.anterior()
				mov r15, [rbx + OFFSET_SIGUIENTE]		;r15 = rbx.siguiente()
				
				cmp rsi, NULL 							;Si estoy borrado el primero
				je sacarPrimero

				cmp r15, NULL 							;Si estoy borrado el último
				je sacarUltimo

				
				mov [r15 + OFFSET_ANTERIOR], rsi		;r15.anterior() = rsi
				mov [rsi + OFFSET_SIGUIENTE], r15		;rsi.siguiente() = r15
				
				mov rdi, rbx 							;Borramos el nodo rbx
				mov rsi, estudianteBorrar
				call nodoBorrar
				
				mov rbx, r15							;Continúo la iteración desde el nodo siguiente
				jmp revisarSiguienteParaFiltrar				;al que eliminé

			sacarPrimero:
				mov rdi, r12
				call popFront
				mov rbx, r15							;Continúo la iteración desde el nodo siguiente
				jmp revisarSiguienteParaFiltrar				;al que eliminé

			sacarUltimo:
				mov rdi, r12
				call popBack
				mov rbx, r15							;Continúo la iteración desde el nodo siguiente
				jmp revisarSiguienteParaFiltrar				;al que eliminé

			filtradoTerminado:
			
		;Poping registers, for the C convention
		add rsp, 8
		pop rbx
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbp
		ret


	;void popFront( altaLista *l );
	popFront:
		;Building the stack frame
		push rbp
		mov	rbp, rsp
		;Backuping registers, for the C convention
		push r12
		push r13

			mov r12, rdi

			cmp r12, NULL
			je terminarPopFront
			cmp qword [r12 + OFFSET_PRIMERO], NULL
			je terminarPopFront

			mov r13, [r12 + OFFSET_PRIMERO]			;r13 es el primer elemento de la lista
			mov r13, [r13 + OFFSET_SIGUIENTE]		;r13 es el segundo elemento de la lista
			cmp r13, NULL
			je eliminarUnicoNodo1

			mov rdi, [r12 + OFFSET_PRIMERO]			;Borramos el primer nodo
			mov rsi, estudianteBorrar
			call nodoBorrar

			mov qword [r13 + OFFSET_ANTERIOR], NULL
			mov [r12 + OFFSET_PRIMERO], r13
			jmp terminarPopFront

			eliminarUnicoNodo1:				
				mov rdi, [r12 + OFFSET_PRIMERO]
				mov rsi, estudianteBorrar
				call nodoBorrar
				; mov qword [rdi + OFFSET_EDAD], 5000

				mov qword [r12 + OFFSET_PRIMERO], NULL
				mov qword [r12 + OFFSET_ULTIMO], NULL

			terminarPopFront:

		;Poping registers, for the C convention
		pop r13
		pop r12
		pop rbp
		ret

	;void popBack( altaLista *l );
	popBack:
		;Building the stack frame
		push rbp
		mov	rbp, rsp
		;Backuping registers, for the C convention
		push r12
		push r13

			mov r12, rdi

			cmp r12, NULL
			je terminarPopBack
			cmp qword [r12 + OFFSET_ULTIMO], NULL
			je terminarPopBack

			mov r13, [r12 + OFFSET_ULTIMO]			;r13 es el último elemento de la lista
			mov r13, [r13 + OFFSET_ANTERIOR]		;r13 es el anteúltimo elemento de la lista
			cmp r13, NULL
			je eliminarUnicoNodo2

			mov rdi, [r12 + OFFSET_ULTIMO]			;Borramos el último nodo
			mov rsi, estudianteBorrar
			call nodoBorrar
			; mov qword [rdi + OFFSET_EDAD], 5000

			mov qword [r13 + OFFSET_SIGUIENTE], NULL
			mov [r12 + OFFSET_ULTIMO], r13
			jmp terminarPopBack

			eliminarUnicoNodo2:				
				mov rdi, [r12 + OFFSET_PRIMERO]
				mov rsi, estudianteBorrar
				call nodoBorrar

				mov qword [r12 + OFFSET_PRIMERO], NULL
				mov qword [r12 + OFFSET_ULTIMO], NULL

			terminarPopBack:

		;Poping registers, for the C convention
		pop r13
		pop r12
		pop rbp
		ret