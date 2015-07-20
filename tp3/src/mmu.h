/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#ifndef __MMU_H__
#define __MMU_H__

#include "defines.h"
#include "game.h"

typedef struct str_page_entry{
    uint    p:1;
    uint    rw:1;
    uint    us:1;
    uint    attr:9;
    uint    dir_base:20;
} __attribute__((__packed__)) page_entry;

#define CODIGO_BASE       0x400000

#define MAPA_BASE_FISICA  0x500000
#define MAPA_BASE_VIRTUAL 0x800000

#define PD_KERNEL      0x27000
#define PAGE_KERNEL     0x28000
#define AREA_LIBRE      0x100000

void mmu_inicializar();
void mmu_inicializar_dir_kernel();
uint mmu_inicializar_dir_pirata(jugador_t* jugador, pirata_t* pirata);
void mmu_copiar_pagina(uint* destino, uint* fuente);
void mmu_mapear_pagina(uint virtual, uint cr3, uint fisica, uint rw);
void mmu_unmapear_pagina(uint virtual, uint cr3);
void mmu_identity_mapping(page_entry* pt);
void mmu_empty_mapping(page_entry* pt);
uint* mmu_new_page();

#endif	/* !__MMU_H__ */
