/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de estructuras para administrar tareas
*/

#include "tss.h"
#include "mmu.h"


tss tss_inicial;
tss tss_idle;

tss tss_jugadorA[MAX_CANT_PIRATAS_VIVOS];
tss tss_jugadorB[MAX_CANT_PIRATAS_VIVOS];

void tss_inicializar() {
    tss_idle.cr3 = rcr3();
    tss_idle.eip = 0x16000;
    tss_idle.eflags = 0x202;
    tss_idle.esp = 0x27000;
	tss_idle.ebp = 0x27000;
    tss_idle.es = GDT_IDX_DS_OS_DESC << 3;
    tss_idle.cs = GDT_IDX_CS_OS_DESC << 3;
    tss_idle.ss = GDT_IDX_DS_OS_DESC << 3;
    tss_idle.ds = GDT_IDX_DS_OS_DESC << 3;
    tss_idle.gs = GDT_IDX_DS_OS_DESC << 3;
    tss_idle.fs = GDT_IDX_DS_OS_DESC << 3;
    tss_idle.iomap = 0xFFFF;
}

void tss_inicializar_pirata(jugador_t* jugador){
    if(jugador->index == JUGADOR_A){

    } else {

    }

    return;
}
