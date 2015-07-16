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

uint* tss_inicializar_pirata(jugador_t* j, pirata_t* p){
    uint id = p->id;
    if(j->id == JUGADOR_A){
        tss_jugadorA[id].cr3 = mmu_inicializar_dir_pirata(j, p);
        tss_jugadorA[id].eflags = 0x202;
        tss_jugadorA[id].iomap = 0xFFFF;
        tss_jugadorA[id].eip = 0x800000;
        tss_jugadorA[id].esp = 0x801000;
        tss_jugadorA[id].ebp = 0x801000;
        tss_jugadorA[id].cs = (GDT_IDX_CS_USR_DESC << 3) + 3;
        tss_jugadorA[id].es = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[id].ss = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[id].ds = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[id].gs = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[id].fs = (GDT_IDX_DS_USR_DESC << 3) + 3;

        tss_jugadorA[id].eax = 0;
        tss_jugadorA[id].ecx = 0;
        tss_jugadorA[id].edx = 0;
        tss_jugadorA[id].ebx = 0;
        tss_jugadorA[id].esi = 0;
        tss_jugadorA[id].edi = 0;
        tss_jugadorA[id].esp0 = (uint)new_page() + 4096;
        tss_jugadorA[id].ss0 = GDT_IDX_DS_OS_DESC << 3;

        return (uint*)&tss_jugadorA[id];
    } else {
        tss_jugadorB[id].cr3 = mmu_inicializar_dir_pirata(j, p);
        tss_jugadorB[id].eflags = 0x202;
        tss_jugadorB[id].iomap = 0xFFFF;
        tss_jugadorB[id].eip = 0x800000;
        tss_jugadorB[id].esp = 0x801000;
        tss_jugadorB[id].ebp = 0x801000;
        tss_jugadorB[id].cs = (GDT_IDX_CS_USR_DESC << 3) + 3;
        tss_jugadorB[id].es = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorB[id].ss = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorB[id].ds = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorB[id].gs = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorB[id].fs = (GDT_IDX_DS_USR_DESC << 3) + 3;

        tss_jugadorB[id].eax = 0;
        tss_jugadorB[id].ecx = 0;
        tss_jugadorB[id].edx = 0;
        tss_jugadorB[id].ebx = 0;
        tss_jugadorB[id].esi = 0;
        tss_jugadorB[id].edi = 0;
        tss_jugadorB[id].esp0 = (uint)new_page() + 4096;
        tss_jugadorB[id].ss0 = GDT_IDX_DS_OS_DESC << 3;

        return (uint*)&tss_jugadorB[id];
    }
}
