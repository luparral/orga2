/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#ifndef __SCHED_H__
#define __SCHED_H__

#include "game.h"

uint proximoA;
uint proximoB;

unsigned char jugador_actual;
unsigned char pirata_actual;

void sched_inicializar();
uint sched_proxima_a_ejecutar();

#endif	/* !__SCHED_H__ */
