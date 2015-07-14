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

	jugadorA.puntos = 0;
	jugadorA.piratas_restantes = 8;
	jugadorA.piratas_totales = 0;
	jugadorA.piratas_muertos = 0;

	jugadorB.puntos = 0;
	jugadorB.piratas_restantes = 8;
	jugadorB.piratas_totales = 0;
	jugadorB.piratas_muertos = 0;
	
	int i = 0;
	
	proximoA = 15; //primer pirata de A
	proximoB = 23; //primer pirata de B

}

unsigned short sched_proxima_a_ejecutar(){
	//cambio de jugador
	if (jugador_actual){
		jugador_actual = 0;
	} else {
		jugador_actual = 1;
	}

	if ((jugadorA.piratas_restantes == 8) && (jugadorB.piratas_restantes == 8)) //estoy en el primer tick, voy a ir a la tarea inicial
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