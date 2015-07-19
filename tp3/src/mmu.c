/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#include "mmu.h"
#include "i386.h"
#include "screen.h"
/* Atributos paginas */
/* -------------------------------------------------------------------------- */
uint* next_page;

void mmu_inicializar_dir_kernel(){
	pd_kernel = (page_entry*)PD_KERNEL;
	pt_kernel = (page_entry*)PAGE_KERNEL;

	mmu_empty_mapping(pd_kernel);
	mmu_identity_mapping(pt_kernel);
	pd_kernel[0].dir_base = (uint)pt_kernel >> 12;
	pd_kernel[0].p = 1;
	pd_kernel[0].rw = 1;
	pd_kernel[0].us = 0;

	return;
}

void mmu_inicializar(){
	next_page = (uint*)AREA_LIBRE;
}


uint mmu_inicializar_dir_pirata(jugador_t* j, pirata_t* p){
	page_entry* pd = (page_entry*)mmu_new_page();
	mmu_empty_mapping(pd);

	//pierdo los primeros 3 hexa
	pd[0].dir_base = (uint)pt_kernel >> 12;
	pd[0].p = 1;
	pd[0].rw = 1;
	pd[0].us = 0;

	//mapear todas las posiciones del mapa visitados
	// int i;
	// for (i = 0; i < MAPA_ALTO*MAPA_ANCHO}; i++) {
	// 	if(j->explorado[i] == 1){
	// 		mmu_mapear_pagina(i * PAGE_SIZE + MAPA_BASE_FISICA, (uint*)pd, i * PAGE_SIZE + MAPA_BASE_FISICA);
	// 	}
	// }

	//mover el codigo del pirata a la direccion 0x400000
	uint cr3 = rcr3();
	lcr3((uint)pd);
	mmu_mapear_pagina(CODIGO_BASE, rcr3(), game_xy2lineal(p->coord.x, p->coord.y) * PAGE_SIZE + MAPA_BASE_FISICA);
	mmu_copiar_pagina((uint*)CODIGO_BASE, p->codigo);
	lcr3(cr3);

	return (uint)pd;
}

void mmu_copiar_pagina(uint* destino, uint* fuente){
	int i;
	for (i = 0; i < 1024; i++) {
		destino[i] = fuente[i];
	}
}

void mmu_mapear_pagina(uint virtual, uint cr3, uint fisica){

	//pierdo los ultimos 12 bits queson de attributos, queda direccion de 4k
	page_entry* pd = (page_entry*)(cr3 & 0xFFFFF000);
	page_entry* pt;
	//separo la direccion virtual en los diferentes offset
	uint pd_offset = virtual >> 22;
	uint pt_offset = (virtual << 10) >> 22;
	//si no hay una entrada presente, pedir 4k y crear una nueva pagina
	if(!pd[pd_offset].p){
		//pido pagina nueva
		pt = (page_entry*)mmu_new_page();
		//vacio pagina
		mmu_empty_mapping(pt);
		pd[pd_offset].dir_base = (uint)pt >> 12;
		pd[pd_offset].us = 1;
		pd[pd_offset].p = 1;
		pd[pd_offset].rw = 1;
	}

	pt = (page_entry*)(pd[pd_offset].dir_base << 12);

	//asignar la entrada a la direccion fisica
	pt[pt_offset].dir_base = (uint)fisica >> 12;
	pt[pt_offset].us = 1;
	pt[pt_offset].p = 1;
	pt[pt_offset].rw = 1;
	tlbflush();

	return;
}

void mmu_unmapear_pagina(uint virtual, uint cr3){
	//IDEA: tiene que escribir con 0s la direccion virtual
	//pierdo los ultimos 12 bits queson de attributos, queda direccion de 4k
	page_entry* pd = (page_entry*)(cr3 & 0xFFFFF000);
	//separo la direccion virtual en los diferentes offset
	uint pd_offset = virtual >> 22;
	uint pt_offset = (virtual << 10) >> 22;

	//si no existe, ya esta desmapeado
	if(!pd[pd_offset].p){
		return;
	}

	page_entry* pt = (page_entry*)(pd[pd_offset].dir_base << 12);

	//limpiar entradas
	pt[pt_offset].p = 0;
	pd[pd_offset].p = 0;
	tlbflush();

	return;
}

/*Auxiliar functions*/

uint* mmu_new_page(){
	uint* aux = next_page;
	next_page += PAGE_SIZE;
	return aux;
}
void mmu_empty_mapping(page_entry* pt){
	int i;
	for (i = 0; i < 1024; i++) {
		pt[i].p = 0;
	}
	return;
}

void mmu_identity_mapping(page_entry* pt){
	int i;
	for (i = 0; i < 1024; i++) {
		pt[i].dir_base = i;
		pt[i].us = 0;
		pt[i].p = 1;
		pt[i].rw = 1;
	}
	return;
}
/* Direcciones fisicas de codigos */
/* -------------------------------------------------------------------------- */
/* En estas direcciones estan los códigos de todas las tareas. De aqui se
 * copiaran al destino indicado por TASK_<i>_CODE_ADDR.
 */

/* Direcciones fisicas de directorios y tablas de paginas del KERNEL */
/* -------------------------------------------------------------------------- */
