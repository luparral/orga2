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
page_entry* pdt_kernel;
page_entry* pet_kernel;
uint* next_page;

void mmu_inicializar_dir_kernel(){
	pdt_kernel = (page_entry*)PDT_KERNEL;
	pet_kernel = (page_entry*)PAGE_KERNEL;

	mmu_empty_mapping(pdt_kernel);
	mmu_identity_mapping(pet_kernel);

	pdt_kernel->dir_base = (uint)pet_kernel >> 12;
	pdt_kernel->available = 0x00;
	pdt_kernel->attr = 0x03;

	return;
}

void mmu_inicializar(){
	next_page = (uint*)AREA_LIBRE;
}


uint mmu_inicializar_dir_pirata(jugador_t* j, pirata_t* p){
	page_entry* pdt_tarea = (page_entry*)mmu_new_page();
	mmu_empty_mapping(pdt_tarea);

	page_entry* pet = (page_entry*)mmu_new_page();
	mmu_identity_mapping(pet);

	//pierdo los primeros 3 hexa
	pdt_tarea->dir_base = (uint)pet >> 12;
	pdt_kernel->available = 0x00;
	pdt_tarea->attr = 0x03;

	uint* destino = (uint*)CODIGO_BASE;
	uint* destino_fisico = (uint*)(game_xy2lineal(p->coord.x, p->coord.y) + MAPA_BASE_FISICA);
	uint* codigo = p->codigo;

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
		destino[i] = fuente[i];
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
		page_entry* page = (page_entry*)mmu_new_page();
		//vacio pagina
		mmu_empty_mapping(page);
		pdt_entry->dir_base = (uint)page >> 12;
		pdt_entry->available = 0x00;
		pdt_entry->attr = 0x03;
	}

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

uint* mmu_new_page(){
	uint* aux = next_page;
	next_page += PAGE_SIZE/sizeof(int);
	return aux;
}
void mmu_empty_mapping(page_entry* entry){
	int i;
	for (i = 1; i < 1024; i++) {
		entry[i].dir_base = 0x00000;
		entry[i].available = 0x00;
		entry[i].attr = 0x00;
	}
}

void mmu_identity_mapping(page_entry* pet){
	int i;
	for (i = 0; i < 1024; i++) {
		pet[i].dir_base = i;
		pet[i].available = 0x00;
		pet[i].attr = 0x03;
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
