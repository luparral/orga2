/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#ifndef __SCHED_H__
#define __SCHED_H__

#include "game.h"

typedef struct str_jugador{
	unsigned int puntos;
	unsigned int piratas_restantes;	// Cantidad de piratas que quedan por lanzar de los 8
	unsigned int piratas_totales;	// Cantidad de piratas totales que usó
	unsigned int piratas_muertos;

} __attribute__((__packed__, aligned (8))) jugador;

jugador jugadorA;
jugador jugadorB;

unsigned short proximoA;
unsigned short proximoB;

unsigned char jugador_actual;
unsigned char pirata_actual;

void sched_inicializar();
unsigned short sched_proxima_a_ejecutar();

#endif	/* !__SCHED_H__ */
