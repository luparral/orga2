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
    tss_idle.eflags = 0x202;
    tss_idle.iomap = 0xFFFF;
    tss_idle.eip = 0x16000;
    tss_idle.esp = 0x27000;
	tss_idle.ebp = 0x27000;
    tss_idle.cs = GDT_IDX_CS_OS_DESC << 3;
    tss_idle.es = GDT_IDX_DS_OS_DESC << 3;
    tss_idle.ss = GDT_IDX_DS_OS_DESC << 3;
    tss_idle.ds = GDT_IDX_DS_OS_DESC << 3;
    tss_idle.gs = GDT_IDX_DS_OS_DESC << 3;
    tss_idle.fs = GDT_IDX_DS_OS_DESC << 3;
}

void tss_inicializar_pirata(jugador_t* j, pirata_t* p){
    if(j->index == JUGADOR_A){
        tss_jugadorA[p->index].cr3 = mmu_inicializar_dir_pirata(j, p);
        tss_jugadorA[p->index].eflags = 0x202;
        tss_jugadorA[p->index].iomap = 0xFFFF;
        tss_jugadorA[p->index].eip = 0x800000;
        tss_jugadorA[p->index].esp = 0x801000;
        tss_jugadorA[p->index].ebp = 0x801000;
        tss_jugadorA[p->index].cs = (GDT_IDX_CS_USR_DESC << 3) + 3;
        tss_jugadorA[p->index].es = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[p->index].ss = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[p->index].ds = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[p->index].gs = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[p->index].fs = (GDT_IDX_DS_USR_DESC << 3) + 3;
    } else {
        
    }

    return;
}
