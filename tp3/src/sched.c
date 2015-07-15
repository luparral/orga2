/* ** por compatibilidad se omiten tildes **
================================================================================
TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
definicion de funciones del scheduler
*/

#include "sched.h"
#include "i386.h"

void sched_inicializar(){
	jugador_actual = 1; //0: A - 1:B

	game_inicializar();
}

//0 significa que no tiene que cambiar de tarea
uint sched_proxima_a_ejecutar(){
	//cambio de jugador
	jugador_actual = (jugador_actual+1) % 2;


	if ((jugadorA.cant_piratas == 0) && (jugadorB.cant_piratas == 0)) //estoy en el primer tick, voy a ir a la tarea inicial
		return 14; //tarea inicial?

	int gdt_offset = (jugador_actual == JUGADOR_A) ? GDT_OFFSET_TSS_JUG_A: GDT_OFFSET_TSS_JUG_B;

	//Tiene que ejecutar a partir de la siguiente de la tarea actual
	int i;
	for(i = 0; i < MAX_CANT_PIRATAS_VIVOS; i++){
		int siguiente = (pirata_actual + i +1) % MAX_CANT_PIRATAS_VIVOS;

		if(gdt[siguiente + gdt_offset].p == 1) {
			pirata_actual = siguiente;
			return pirata_actual + gdt_offset;
		}
	}

	return 0;
}
