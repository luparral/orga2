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
page_entry* pdt_kernel = (page_entry*)PDT_KERNEL;
uint* next_page = (uint*)AREA_LIBRE;

page_entry* mmu_inicializar_dir_kernel(){

	pdt_kernel = empty_mapping(pdt_kernel);

	//link to the dir of PAGE_KERNEL
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


uint mmu_inicializar_dir_pirata(jugador_t* jugador, pirata_t* pirata){
	page_entry* pdt_tarea = (page_entry*)new_page();
	empty_mapping(pdt_tarea);

	page_entry* pet = (page_entry*)new_page();
	identity_mapping(pet);

	//pierdo los primeros 3 hexa
	pdt_tarea->dir_base = (uint)pet >> 12;
	pdt_tarea->available = 0x00;
	pdt_tarea->attr = 0x03;

	uint* destino = (uint*)CODIGO_BASE;
	//TODO: hay que copiarlo a la direccion del puerto
	uint* destino_fisico;
	uint* codigo;

	//TODO: mover funcionalidad hacia init jugador que tenga el codigo de cada uno de los piratas, o que cada pirata tenga su propio codigo?
	if(jugador->index == JUGADOR_A){
		destino_fisico = (uint*)(game_xy2lineal(POS_INIT_A_X, POS_INIT_A_Y) + MAPA_BASE_FISICA);
		if(pirata->tipo == PIRATA_E){
			codigo = (uint*)CODIGO_TAREA_A_E;
		} else {
			codigo = (uint*)CODIGO_TAREA_A_M;
		}
	} else{
		destino_fisico = (uint*)(game_xy2lineal(POS_INIT_B_X, POS_INIT_B_Y) + MAPA_BASE_FISICA);
		if(pirata->tipo == PIRATA_E){
			codigo = (uint*)CODIGO_TAREA_B_E;
		} else {
			codigo = (uint*)CODIGO_TAREA_B_M;
		}
	}

	mmu_mapear_y_copiar_pagina(destino, (uint*)pdt_tarea, destino_fisico, codigo);

	return (uint)pdt_tarea;
}

void mmu_mapear_y_copiar_pagina(uint* destino_virtual, uint* pdt_tarea, uint* destino_fisico, uint* fuente){
	mmu_mapear_pagina((uint)destino_virtual, (uint)pdt_tarea, (uint)destino_fisico);
	//tengo que cambiar de cr3 para mapearlo, copiarlo y luego desmapearlo
	uint cr3 = rcr3();
	lcr3((uint)pdt_tarea);
	mmu_copiar_pagina(fuente, destino_virtual);
	//desmapeo y vuelvo al viejo cr3
	mmu_unmapear_pagina((uint)destino_virtual, (uint)pdt_tarea);
	lcr3(cr3);

	return;
}

void mmu_copiar_pagina(uint* fuente, uint* destino){
	int i;
	for (i = 0; i < 1024; i++) {
		*destino = *fuente;
		destino++;
		fuente++;
	}

	return;
}

void mmu_mapear_pagina(uint virtual, uint cr3, uint fisica){

	//pierdo los ultimos 12 bits queson de attributos, queda direccion de 4k
	page_entry* pdt_base = (page_entry*)(cr3 & 0xFFFFF000);
	//separo la direccion virtual en los diferentes offset

	uint pdt_offset = virtual >> 22;
	uint pet_offset = (virtual << 10) >> 22;

	//JA! gotcha: si copiaba simplemente el valor, no se asignaba, tenia que tenerlo como un puntero asi lo escribia efectivamente
	page_entry* pdt_entry = (page_entry*)&pdt_base[pdt_offset];

	//si no hay una entrada presente, pedir 4k y crear una nueva pagina
	if(pdt_entry->attr == 0x00){
		//pido pagina nueva
		page_entry* page = (page_entry*)new_page();
		//vacio pagina
		empty_mapping(page);
		pdt_entry->dir_base = (uint)page >> 12;
		pdt_entry->available = 0x00;
		pdt_entry->attr = 0x03;
	}

	// __asm__ ("xchg %bx, %bx");
	page_entry* pet_base = (page_entry*)(pdt_entry->dir_base << 12);

	//asignar la entrada a la direccion fisica
	pet_base[pet_offset].dir_base = (uint)fisica >> 12;
	pet_base[pet_offset].available = 0x00;
	pet_base[pet_offset].attr = 0x03;
	tlbflush();

	return;
}

void mmu_unmapear_pagina(uint virtual, uint cr3){
	//IDEA: tiene que escribir con 0s la direccion virtual
	//pierdo los ultimos 12 bits queson de attributos, queda direccion de 4k
	page_entry* pdt_base = (page_entry*)(cr3 & 0xFFFFF000);
	//separo la direccion virtual en los diferentes offset
	uint pdt_offset = virtual >> 22;
	uint pet_offset = (virtual << 10) >> 22;

	page_entry* pdt_entry = (page_entry*)&pdt_base[pdt_offset];

	//si no existe, ya esta desmapeado
	if(pdt_entry->attr == 0){
		return;
	}

	page_entry* pet_base = (page_entry*)(pdt_entry->dir_base << 12);

	//limpiar entrada en la pet
	pet_base[pet_offset].dir_base = 0x00000;
	pet_base[pet_offset].available = 0x00;
	pet_base[pet_offset].attr = 0x00;

	//limpiar entrada en la pdt
	pdt_entry->dir_base = 0x00000;
	pdt_entry->available = 0x00;
	pdt_entry->attr = 0x00;

	return;
}

/*Auxiliar functions*/

uint* new_page(){
	uint* aux = next_page;
	next_page += PAGE_SIZE/sizeof(int);
	return aux;
}
page_entry* empty_mapping(page_entry* entry){
	page_entry* aux = entry;
	int i;

	for (i = 1; i < 1024; i++) {
		entry->dir_base = 0x00000;
		entry->available = 0x00;
		entry->attr = 0x00;
		entry++;
	}
	return aux;
}

page_entry* identity_mapping(page_entry* pet){
	page_entry* aux = pet;
	int i;

	for (i = 0; i < 1024; i++) {
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
