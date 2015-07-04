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
    uint    attr:9;
    uchar   available:3;
    uint    dir_base:20;
} __attribute__((__packed__)) page_entry;

#define CODIGO_BASE       0x400000

#define MAPA_BASE_FISICA  0x500000
#define MAPA_BASE_VIRTUAL 0x800000

#define PDT_KERNEL      0x27000
#define PAGE_KERNEL     0x28000
#define AREA_LIBRE      0x100000

uint* mmu_inicializar();
page_entry* mmu_inicializar_dir_pirata(uint* dir_tarea);
page_entry* mmu_inicializar_dir_kernel();
void mmu_mapear_pagina(uint virtual, uint cr3, uint fisica);
void mmu_unmapear_pagina(uint virtual, uint cr3);

/*Auxiliar functions*/
uint* new_page();
page_entry* empty_mapping(page_entry* pdt);
page_entry* identity_mapping(page_entry* pet);


#endif	/* !__MMU_H__ */
