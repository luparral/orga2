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

#define CODIGO_BASE       0X400000

#define MAPA_BASE_FISICA  0x500000
#define MAPA_BASE_VIRTUAL 0x800000

#define IDT_KERNEL      0x27000
#define PAGE_KERNEL     0x28000
#define AREA_LIBRE      0x100000

uint* mmu_inicializar();
void mmu_inicializar_dir_pirata();
page_entry* mmu_inicializar_dir_kernel();

/*Auxiliar functions*/
uint* get_page();
page_entry* init_empty_dir(page_entry* pdt);
page_entry* identity_mapping(page_entry* pet);


#endif	/* !__MMU_H__ */
