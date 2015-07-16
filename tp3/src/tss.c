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

uint* tss_inicializar_pirata(uint id_jugador, uint id_pirata){
    jugador_t* j = game_id_jugador2jugador(id_jugador);
    pirata_t* p = id_pirata2pirata(id_pirata);

    if(id_jugador == JUGADOR_A){
        tss_jugadorA[id_pirata].eflags = 0x202;
        tss_jugadorA[id_pirata].cr3 = mmu_inicializar_dir_pirata(j, p);
        tss_jugadorA[id_pirata].iomap = 0xFFFF;
        tss_jugadorA[id_pirata].eip = 0x800000;
        tss_jugadorA[id_pirata].esp = 0x801000;
        tss_jugadorA[id_pirata].ebp = 0x801000;
        tss_jugadorA[id_pirata].cs = (GDT_IDX_CS_USR_DESC << 3) + 3;
        tss_jugadorA[id_pirata].es = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[id_pirata].ss = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[id_pirata].ds = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[id_pirata].gs = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorA[id_pirata].fs = (GDT_IDX_DS_USR_DESC << 3) + 3;

        tss_jugadorA[id_pirata].eax = 0;
        tss_jugadorA[id_pirata].ecx = 0;
        tss_jugadorA[id_pirata].edx = 0;
        tss_jugadorA[id_pirata].ebx = 0;
        tss_jugadorA[id_pirata].esi = 0;
        tss_jugadorA[id_pirata].edi = 0;
        tss_jugadorA[id_pirata].esp0 = (uint)new_page() + 4096;
        tss_jugadorA[id_pirata].ss0 = GDT_IDX_DS_OS_DESC << 3;
        return (uint*)&tss_jugadorA[id_pirata];
    } else {
        tss_jugadorB[id_pirata].cr3 = mmu_inicializar_dir_pirata(j, p);
        tss_jugadorB[id_pirata].eflags = 0x202;
        tss_jugadorB[id_pirata].iomap = 0xFFFF;
        tss_jugadorB[id_pirata].eip = 0x800000;
        tss_jugadorB[id_pirata].esp = 0x801000;
        tss_jugadorB[id_pirata].ebp = 0x801000;
        tss_jugadorB[id_pirata].cs = (GDT_IDX_CS_USR_DESC << 3) + 3;
        tss_jugadorB[id_pirata].es = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorB[id_pirata].ss = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorB[id_pirata].ds = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorB[id_pirata].gs = (GDT_IDX_DS_USR_DESC << 3) + 3;
        tss_jugadorB[id_pirata].fs = (GDT_IDX_DS_USR_DESC << 3) + 3;

        tss_jugadorB[id_pirata].eax = 0;
        tss_jugadorB[id_pirata].ecx = 0;
        tss_jugadorB[id_pirata].edx = 0;
        tss_jugadorB[id_pirata].ebx = 0;
        tss_jugadorB[id_pirata].esi = 0;
        tss_jugadorB[id_pirata].edi = 0;
        tss_jugadorB[id_pirata].esp0 = (uint)new_page() + 4096;
        tss_jugadorB[id_pirata].ss0 = GDT_IDX_DS_OS_DESC << 3;

        return (uint*)&tss_jugadorB[id_pirata];
    }
}
