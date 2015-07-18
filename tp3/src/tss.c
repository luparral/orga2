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
    tss_idle.fs = GDT_IDX_VIDEO_DESC << 3;
}

uint* tss_inicializar_pirata(uint id_jugador, uint id_pirata){
    jugador_t* j = game_id_jugador2jugador(id_jugador);
    pirata_t* p = id_pirata2pirata(id_pirata);

    tss* pointerTss;
    if(id_jugador == JUGADOR_A){
        pointerTss = &tss_jugadorA[id_pirata];
    } else {
        pointerTss = &tss_jugadorB[id_pirata];
    }

    pointerTss->eflags = 0x202;
    pointerTss->cr3 = mmu_inicializar_dir_pirata(j, p);
    pointerTss->iomap = 0xFFFF;
    pointerTss->eip = 0x400000;
    pointerTss->esp = 0x401000-12;
    pointerTss->ebp = 0x401000-12;
    pointerTss->cs = (GDT_IDX_CS_USR_DESC << 3) + 3;
    pointerTss->es = (GDT_IDX_DS_USR_DESC << 3) + 3;
    pointerTss->ss = (GDT_IDX_DS_USR_DESC << 3) + 3;
    pointerTss->ds = (GDT_IDX_DS_USR_DESC << 3) + 3;
    pointerTss->gs = (GDT_IDX_DS_USR_DESC << 3) + 3;
    pointerTss->fs = (GDT_IDX_VIDEO_DESC << 3) + 3;

    pointerTss->eax = 0;
    pointerTss->ecx = 0;
    pointerTss->edx = 0;
    pointerTss->ebx = 0;
    pointerTss->esi = 0;
    pointerTss->edi = 0;
    pointerTss->esp0 = (uint)mmu_new_page() + 0x1000;
    pointerTss->ss0 = GDT_IDX_DS_OS_DESC << 3;
    return (uint*)pointerTss;
}
