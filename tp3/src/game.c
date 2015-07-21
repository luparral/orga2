/* ** por compatibilidad se omiten tildes **
================================================================================
TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/
#include "game.h"

uint botines[BOTINES_CANTIDAD][3] = { // TRIPLAS DE LA FORMA (X, Y, MONEDAS)
                                        {30,  3, 50}, {30, 38, 50}, {15, 21, 100}, {45, 21, 100} ,
                                        {49,  3, 50}, {49, 38, 50}, {64, 21, 100}, {34, 21, 100}
                                    };

void* error(){
	__asm__ ("int3");
	return 0;
}

uint game_xy2lineal (uint x, uint y) {
	return (y * MAPA_ANCHO + x);
}

uint game_posicion_valida(int x, int y) {
	return (x >= 0 && y >= 1 && x < MAPA_ANCHO-1 && y < MAPA_ALTO);
}

pirata_t* id_pirata2pirata(jugador_t* j, uint id_pirata){
    return &j->piratas[id_pirata];
}

jugador_t* game_get_jugador_actual(){
    if(jugador_actual == JUGADOR_A)
        return &jugadorA;
    else
        return &jugadorB;
}


jugador_t* id_jugador2jugador(uint id){
    if(id == JUGADOR_A)
        return &jugadorA;
    else
        return &jugadorB;
}

uint game_dir2xy(direccion dir, int *x, int *y){
	switch (dir)
	{
		case IZQ: *x = -1; *y =  0; break;
		case DER: *x =  1; *y =  0; break;
		case ABA: *x =  0; *y =  1; break;
		case ARR: *x =  0; *y = -1; break;
    	default: return -1;
	}

	return 0;
}

uint game_valor_tesoro(uint x, uint y){
	int i;
	for (i = 0; i < BOTINES_CANTIDAD; i++)
	{
		if (botines[i][0] == x && botines[i][1] == y)
			return botines[i][2];
	}
	return 0;
}

void game_inicializar(){
    game_jugador_inicializar(&jugadorA, JUGADOR_A);
    game_jugador_inicializar(&jugadorB, JUGADOR_B);
    return;
}

void game_inicializar_botines(){
    //pinto los botines
    int i;
    for (i = 0; i < BOTINES_CANTIDAD; i++) {
        screen_pintar('o', C_BG_BLACK | C_FG_WHITE, botines[i][1], botines[i][0]);
    }
}

void game_jugador_inicializar_mapa(jugador_t *jug){
}


void game_jugador_inicializar(jugador_t* j, uint id){
    j->id = id;
    int i;
    for(i = 0; i<MAX_CANT_PIRATAS_VIVOS; i++){
        j->piratas[i].id = i;
        j->piratas[i].vivo = FALSE;
    }
    j->monedas = 0;
    j->cant_piratas = 0;
    j->cant_exploradores = 0;
    j->mineros_disponibles = 0;

    if(j->id == JUGADOR_A){
        j->coord_puerto = (coord_t){
            .x = POS_INIT_A_X,
            .y = POS_INIT_A_Y
        };
        j->codigo_explorador = (uint*)CODIGO_TAREA_A_E;
        j->codigo_minero = (uint*)CODIGO_TAREA_A_M;
    } else {
        j->coord_puerto = (coord_t){
            .x = POS_INIT_B_X,
            .y = POS_INIT_B_Y
        };
        j->codigo_explorador = (uint*)CODIGO_TAREA_B_E;
        j->codigo_minero = (uint*)CODIGO_TAREA_B_M;
    }

    for (i = 0; i < MAPA_ALTO*MAPA_ANCHO; i++) {
        j->explorado[i] = FALSE;
    }
    return;
}

//devuelve el indice del pirata
pirata_t* game_pirata_inicializar(jugador_t *j, uint tipo){
    //busco que pirata esta libre
    int i;
    for(i = 0; i < MAX_CANT_PIRATAS_VIVOS; i++){
        if(j->piratas[i].vivo == FALSE)
            break;
    }

    j->piratas[i].id = i;
    j->piratas[i].coord = j->coord_puerto;
    j->piratas[i].tipo = tipo;
    j->piratas[i].ticks = 0;
    j->piratas[i].vivo = TRUE;
    j->piratas[i].codigo = (tipo == PIRATA_E) ? j->codigo_explorador : j->codigo_minero;
    return &j->piratas[i];
}

void game_tick(){
    screen_actualizar();
    jugador_t* jugador = id_jugador2jugador(jugador_actual);
    if((jugador->mineros_disponibles > 0) & (jugador->cant_piratas<8)){
        game_jugador_lanzar_pirata(jugador, PIRATA_M);
        jugador->mineros_disponibles--;
        jugador->cant_piratas++;
    }
}

void game_pirata_relanzar(jugador_t *j, pirata_t *pirata, uint tipo){
}

void game_jugador_lanzar_pirata(jugador_t *j, uint tipo){
    if(j->cant_piratas < MAX_CANT_PIRATAS_VIVOS){
        //inicializo todas las estructuras necesarias
        pirata_t* p = game_pirata_inicializar(j, tipo);
        int gdt_offset;
        if(j->id == JUGADOR_A){
            gdt_offset = GDT_OFFSET_TSS_JUG_A;
        } else {
            gdt_offset = GDT_OFFSET_TSS_JUG_B;
        }

        //Busco tss libre para el pirata
        int i;
        for(i = 0; i < MAX_CANT_PIRATAS_VIVOS; i++){
            if(gdt[gdt_offset+i].p == 0) break;
        }

        uint* dir_tss = (uint*)tss_inicializar_pirata(j->id, p->id);
        gdt_incializar_pirata(gdt_offset+i, dir_tss);
        screen_pintar_pirata(j, p);

        //actualizo variables de juego
        j->cant_piratas++;
        if(tipo == PIRATA_E){
            j->cant_exploradores++;
        } else {
            //muevo coordenadas al stack para los mineros
            uint cr3 = rcr3();
            lcr3(((tss_t*)dir_tss)->cr3);
            int* botin_x = (int*)(CODIGO_BASE+PAGE_SIZE-8);
            int* botin_y = (int*)(CODIGO_BASE+PAGE_SIZE-4);
            *botin_x = j->botin.x;
            *botin_y = j->botin.y;
            lcr3(cr3);
        }
    }
    return;
}

void game_jugador_habilitar_posicion(jugador_t *j, pirata_t *p){
    int i, k;
    for (i = -1; i <= 1; i++) {
        for (k = -1; k <= 1; k++) {
            int x = p->coord.x + i;
            int y = p->coord.y + k;
            if(game_posicion_valida(x, y)){
                j->explorado[game_xy2lineal(x, y)] = TRUE;
                mmu_mapear_pagina(game_xy2lineal(x, y) * PAGE_SIZE + MAPA_BASE_VIRTUAL, rcr3(), game_xy2lineal(x, y) * PAGE_SIZE + MAPA_BASE_FISICA, 1);
                if(game_valor_tesoro(x, y)){
                    j->mineros_disponibles++;
                    j->botin = (coord_t){
                        .x = x,
                        .y = y
                    };
                }
            }
        }
    }
    return;
}


void game_explorar_posicion(jugador_t *jugador, int c, int f){
}

coord_t game_dir2coord(direccion dir) {
	coord_t coord;
    switch(dir){
        case IZQ:
            coord.x = -1;
            coord.y = 0;
            break;
        case DER:
            coord.x = 1;
            coord.y =0;
            break;
        case ARR:
            coord.x = 0;
            coord.y =-1;
            break;
        case ABA:
            coord.x = 0;
            coord.y =1;
            break;
        default:
            break;
    }
    return coord;
}


uint game_syscall_pirata_mover(uint id, direccion dir){
    jugador_t* j = game_get_jugador_actual();
    pirata_t* p = id_pirata2pirata(j, id);
    coord_t c = game_dir2coord(dir);

    if(!game_posicion_valida(p->coord.x + c.x, p->coord.y + c.y)){
        return 0;
    }
    //chequeo si es minero y la posicion no fue mapeada
    if(p->tipo == PIRATA_M && !j->explorado[game_xy2lineal(p->coord.x, p->coord.y)]){
        return 0;
    }

    //actualizo posicion del pirata
    int x = p->coord.x;
    int y = p->coord.y;
    p->coord.x += c.x;
    p->coord.y += c.y;

    //guardar las posiciones exploradas si es explorador
    if(p->tipo == PIRATA_E && !j->explorado[game_xy2lineal(p->coord.x, p->coord.y)])
        game_jugador_habilitar_posicion(j, p);

    //mover el codigo de la posicion anterior a la nueva
    mmu_unmapear_pagina(CODIGO_BASE, rcr3());
    mmu_mapear_pagina(CODIGO_BASE, rcr3(), game_xy2lineal(p->coord.x, p->coord.y) * PAGE_SIZE + MAPA_BASE_FISICA, 1);
	mmu_copiar_pagina((uint*)CODIGO_BASE, (uint*)(game_xy2lineal(x,y) * PAGE_SIZE + MAPA_BASE_VIRTUAL));

    // actualizar color de la posicion anterior
    char color = j->id == JUGADOR_A ? C_BG_GREEN : C_BG_CYAN;
    char tipo = (p->tipo == PIRATA_E) ? 'E' : 'M';
    screen_pintar(tipo, color | C_FG_BLACK, y, x);
    // pintar el pirata en la nueva posicion
    screen_pintar_pirata(j, p);

    return 0;
}

uint game_buscar_botin(uint id_pirata){
    jugador_t* j = id_jugador2jugador(jugador_actual);
    pirata_t* p = id_pirata2pirata(j, id_pirata);

    int i;
    for(i = 0; i < BOTINES_CANTIDAD; i++)
        if(p->coord.x == botines[i][0] && p->coord.y == botines[i][1])
            return i;

    return -1;
}

uint game_syscall_cavar(uint id_pirata) {
    jugador_t* j = id_jugador2jugador(jugador_actual);
    pirata_t* p = id_pirata2pirata(j, id_pirata);
    uint monedas = game_valor_tesoro(p->coord.x, p->coord.y);
    if(monedas == 0){
        game_pirata_exploto();
        return 0;
    }
    j->monedas++;
    int id_botin = game_buscar_botin(p->id);
    botines[id_botin][2]--;
    monedas = game_valor_tesoro(p->coord.x, p->coord.y);
    if(monedas == 0){
        game_pirata_exploto();
    }

    return 0;
}

uint game_syscall_pirata_posicion(uint id_pirata, int param){
    jugador_t* j = id_jugador2jugador(jugador_actual);
    int id = (param == -1) ? pirata_actual : param;
    pirata_t* p = id_pirata2pirata(j, id);
    return p->coord.y << 8 | p->coord.x;
}

uint game_syscall_manejar(uint syscall, uint param1){
    uint id_pirata = pirata_actual;
    switch(syscall){
        case 1: return game_syscall_pirata_mover(id_pirata, param1);
        case 2: return game_syscall_cavar(id_pirata);
        case 3: return game_syscall_pirata_posicion(id_pirata, param1);
        default: break;
    }
    return 0;
}

void game_pirata_exploto(){
    uint id_pirata = pirata_actual;
    jugador_t* j= game_get_jugador_actual();
    pirata_t* p = id_pirata2pirata(j, id_pirata);
    p->vivo = FALSE;
    j->cant_piratas--;

    gdt[pirata_actual + jugador_actual*8 + 15].p = 0;

    char text;
    if(p->tipo == PIRATA_E){
        text = 'E';
        j->cant_exploradores--;
    } else {
        text = 'M';
    }

    char color_bg = (j->id == JUGADOR_A) ? C_BG_RED : C_BG_BLUE;
    char color_txt = (j->id == JUGADOR_A) ? C_FG_LIGHT_RED : C_FG_LIGHT_BLUE;
    screen_pintar(text, color_bg | color_txt, p->coord.y, p->coord.x);
    screen_actualizar_reloj_pirata(j, p);
}

pirata_t* game_pirata_en_posicion(uint x, uint y){
	return NULL;
}


void game_jugador_anotar_punto(jugador_t *j){
    j->monedas++;
    return;
}



void game_terminar_si_es_hora(){
}

void game_atender_teclado(unsigned char tecla){
    jugador_t* j;
    //debug de teclado
    print_hex(tecla, 3, 30, 30, C_BG_LIGHT_GREY | C_FG_RED);
    if(tecla == KB_shiftA){
        j = id_jugador2jugador(JUGADOR_A);
        game_jugador_lanzar_pirata(j,0);
    }
    if(tecla == KB_shiftB){
        j = id_jugador2jugador(JUGADOR_B);
        game_jugador_lanzar_pirata(j,0);
    }
    if(tecla == KB_y){
        modo_debug = !modo_debug;
    }

    //TODO: DEBUG pirata exploto
    if(tecla == 0x20){
        game_pirata_exploto();
    }

    return;
}
