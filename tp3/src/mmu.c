/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#include "mmu.h"
#include "i386.h"
/* Atributos paginas */
/* -------------------------------------------------------------------------- */
page_dir_entry* dir_table = (page_dir_entry*)DIRECTORIO_PAGINAS;
page_entry* page_table = (page_entry*)PAGINAS;

page_dir_entry* mmu_inicializar(){

	dir_table->dir_base = 0x28000;
	dir_table->available = 0x0;
	dir_table->attr = 0x03;
	dir_table++;

	int i;

	for (i = 1; i < 1024; i++) {
		dir_table->dir_base = 0x00000;
		dir_table->available = 0x00;
		dir_table->attr = 0x00;
		dir_table++;
	}


	for (i = 0; i < 1024; i++) {
		page_table->dir_base = i;
		page_table->available = 0x00;
		page_table->attr = 0x03;
		page_table++;
	}

	return (page_dir_entry*)DIRECTORIO_PAGINAS;
}
/* Direcciones fisicas de codigos */
/* -------------------------------------------------------------------------- */
/* En estas direcciones estan los códigos de todas las tareas. De aqui se
 * copiaran al destino indicado por TASK_<i>_CODE_ADDR.
 */

/* Direcciones fisicas de directorios y tablas de paginas del KERNEL */
/* -------------------------------------------------------------------------- */
