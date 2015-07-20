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
	jugador_actual = JUGADOR_A; //0: A - 1:B
	jugadorA_pirata_actual = 0;
	jugadorB_pirata_actual = 0;
}

uint sched_tick(){
	game_tick();
	return sched_proxima_a_ejecutar();
}

int game_proximo_pirata(int id_jugador, uint id_pirata){
	int i;
	jugador_t* j = (id_jugador == JUGADOR_A) ? &jugadorA : &jugadorB;
	for (i = 0; i < MAX_CANT_PIRATAS_VIVOS; i++) {
		int siguiente = (id_pirata + 1 + i) % MAX_CANT_PIRATAS_VIVOS;
		if(gdt[j->piratas[siguiente].id + j->id*8 + 15].p){
			return siguiente;
		}
	}
	return -1;
}

// //TODO: ELIMINAR DEBUG
// print_hex(id_jugador, 10, 10, 8, (0x7 << 4) | 0x4);
// __asm__ ("xchg %bx, %bx");


uint sched_proxima_a_ejecutar(){
	jugador_actual = (jugador_actual == JUGADOR_A) ? JUGADOR_B : JUGADOR_A;
	if(game_proximo_pirata(JUGADOR_B, jugadorB_pirata_actual) == -1 && game_proximo_pirata(JUGADOR_A, jugadorA_pirata_actual) == -1){
		return GDT_IDX_TSS_IDLE_DESC;
	}

	int gdt_offset;
	int proximoA = game_proximo_pirata(JUGADOR_A, jugadorA_pirata_actual);
	int proximoB =  game_proximo_pirata(JUGADOR_B, jugadorB_pirata_actual);
	if(proximoA == -1 || jugador_actual == JUGADOR_B){
		jugador_actual = JUGADOR_B;
		gdt_offset = GDT_OFFSET_TSS_JUG_B;
		pirata_actual = proximoB;
		jugadorB_pirata_actual = proximoB;
	}
	if(proximoB == -1 || jugador_actual == JUGADOR_A){
		jugador_actual = JUGADOR_A;
		gdt_offset = GDT_OFFSET_TSS_JUG_A;
		pirata_actual = proximoA;
		jugadorA_pirata_actual = proximoA;
	}

	//tengo que obtener el pirata que viene para poder devolverlo en la gdt
	//ademas intercambiar entre jugadores y el siguiente pirata a iterar de cada uno

	//cambio de jugador
	return pirata_actual + gdt_offset;
}
