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

typedef struct str_page_dir_entry{
    unsigned int    dir_base:20;
    unsigned char   available:3;
    unsigned int    attr:9;
} __attribute__((__packed__)) page_dir_entry;

typedef struct str_page_entry{
    unsigned int    dir_base:20;
    unsigned char   available:3;
    unsigned int    attr:9;
} __attribute__((__packed__)) page_entry;

#define CODIGO_BASE       0X400000

#define MAPA_BASE_FISICA  0x500000
#define MAPA_BASE_VIRTUAL 0x800000

#define DIRECTORIO_PAGINAS 0x27000
#define PAGINAS           0x28000

extern page_dir_entry* dir_table;
extern page_entry* page_table;

page_dir_entry* mmu_inicializar();


#endif	/* !__MMU_H__ */
