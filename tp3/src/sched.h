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
#include "gdt.h"
#include "screen.h"

void sched_inicializar();
uint sched_tick();
uint sched_proxima_a_ejecutar();

#endif	/* !__SCHED_H__ */
