/* ** por compatibilidad se omiten tildes **
================================================================================
TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
definicion de funciones del scheduler
*/

#include "sched.h"
#include "screen.h"
#include "i386.h"

void sched_inicializar(){
	jugador_actual = 1; //0: A - 1:B
	jugadorA_pirata_actual = 0;
	jugadorB_pirata_actual = 0;
	game_inicializar();
}

//0 significa que no tiene que cambiar de tarea
uint sched_proxima_a_ejecutar(){
	//cambio de jugador
	jugador_actual = !jugador_actual;

	//TODO: hay que ir a la tarea inicial?
	if ((jugadorA.cant_piratas == 0) && (jugadorB.cant_piratas == 0)){
		return 14;
	}

	int gdt_offset;

	//Dectecto que jugador esta corriendo, asigno las variables pertinentes
	if(jugador_actual == JUGADOR_A){
		gdt_offset = GDT_OFFSET_TSS_JUG_A;
		pirata_actual = jugadorA_pirata_actual;
	} else {
		gdt_offset = GDT_OFFSET_TSS_JUG_B;
		pirata_actual = jugadorB_pirata_actual;
	}

	//Si hay un solo jugador corriendo, devuelvo el offset de el
	if(jugadorA.cant_piratas == 0){
		jugador_actual = JUGADOR_B;
		gdt_offset = GDT_OFFSET_TSS_JUG_B;
		pirata_actual = jugadorB_pirata_actual;
	}
	if(jugadorB.cant_piratas == 0){
		jugador_actual = JUGADOR_A;
		gdt_offset = GDT_OFFSET_TSS_JUG_A;
		pirata_actual = jugadorA_pirata_actual;
	}

	//Tiene que ejecutar a partir de la siguiente de la tarea actual
	int i;
	for(i = 0; i < MAX_CANT_PIRATAS_VIVOS; i++){
		int siguiente = (pirata_actual + i +1) % MAX_CANT_PIRATAS_VIVOS;

		if(gdt[siguiente + gdt_offset].p == 1) {
			//TODO: ELIMINAR DEBUG
			// print_hex(siguiente, 10, 10, 10, (0x7 << 4) | 0x4);
			// __asm__ ("xchg %bx, %bx");
			pirata_actual = siguiente;
			return siguiente + gdt_offset;
		}
	}
	return 0;
}
