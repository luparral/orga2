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

	proximoA = 15; //primer pirata de A
	proximoB = 23; //primer pirata de B

}

uint sched_proxima_a_ejecutar(){
	//cambio de jugador
	jugador_actual = (jugador_actual+1) % 2;

	if ((jugadorA.cant_piratas == 0) && (jugadorB.cant_piratas == 0)) //estoy en el primer tick, voy a ir a la tarea inicial
		return 13;

	int i;
	if (jugador_actual == 0){
		i = proximoA;

		do{
			i++;

			if (i > 22)
				i = 15;

			if (gdt[i].p == 1){
				proximoA = i;
				pirata_actual = i - 15;
				return proximoA;
			}

		}while(i != proximoA);

	} else{
		i = proximoB;

		do{
			i++;

			if (i > 30)
				i = 23;

			if (gdt[i].p == 1){
				proximoB = i;
				pirata_actual = i - 23;
				return proximoB;
			}

		} while(i != proximoB);
	}

	return 0;

}
