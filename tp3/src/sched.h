/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#ifndef __SCHED_H__
#define __SCHED_H__

#include "game.h"
#include "tss.h"

uint jugador_actual;
uint pirata_actual;

void sched_inicializar();
uint sched_proxima_a_ejecutar();

#endif	/* !__SCHED_H__ */
