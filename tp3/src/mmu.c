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
page_entry* pdt_kernel = (page_entry*)IDT_KERNEL;
uint* next_page = (uint*)AREA_LIBRE;

page_entry* mmu_inicializar_dir_kernel(){

	pdt_kernel = init_empty_dir(pdt_kernel);

	pdt_kernel->dir_base = 0x28;
	pdt_kernel->available = 0x0;
	pdt_kernel->attr = 0x03;

	page_entry* pet_kernel = (page_entry*)PAGE_KERNEL;

	identity_mapping(pet_kernel);

	return pdt_kernel;
}

uint* mmu_inicializar(){
	return next_page;
}


void mmu_inicializar_dir_pirata(){
	page_entry* pdt = (page_entry*)get_page();
	init_empty_dir(pdt);

	page_entry* pet = (page_entry*)get_page();
	identity_mapping(pet);

	pdt->dir_base = (uint)next_page >> 12;
	pdt->available = 0x00;
	pdt->attr = 0x03;

	//pet->dir_base;
}

/*Auxiliar functions*/

uint* get_page(){
	uint* aux = next_page;
	next_page += PAGE_SIZE;
	return aux;
}
page_entry* init_empty_dir(page_entry* pdt){
	page_entry* aux = pdt;
	int i;

	for (i = 1; i < 1000; i++) {
		pdt->dir_base = 0x00000;
		pdt->available = 0x00;
		pdt->attr = 0x00;
		pdt++;
	}
	return aux;
}

page_entry* identity_mapping(page_entry* pet){
	page_entry* aux = pet;
	int i;

	for (i = 0; i < 1000; i++) {
		pet->dir_base = i;
		pet->available = 0x00;
		pet->attr = 0x03;
		pet++;
	}

	return aux;
}
/* Direcciones fisicas de codigos */
/* -------------------------------------------------------------------------- */
/* En estas direcciones estan los códigos de todas las tareas. De aqui se
 * copiaran al destino indicado por TASK_<i>_CODE_ADDR.
 */

/* Direcciones fisicas de directorios y tablas de paginas del KERNEL */
/* -------------------------------------------------------------------------- */
