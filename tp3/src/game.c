/* ** por compatibilidad se omiten tildes **
================================================================================
TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#include "game.h"
#include "mmu.h"
#include "tss.h"
#include "screen.h"

#include <stdarg.h>


uint botines[BOTINES_CANTIDAD][3] = { // TRIPLAS DE LA FORMA (X, Y, MONEDAS)
                                        {30,  3, 50}, {30, 38, 50}, {15, 21, 100}, {45, 21, 100} ,
                                        {49,  3, 50}, {49, 38, 50}, {64, 21, 100}, {34, 21, 100}
                                    };

jugador_t jugadorA;
jugador_t jugadorB;


void* error()
{
	__asm__ ("int3");
	return 0;
}

uint game_xy2lineal (uint x, uint y) {
	return (y * MAPA_ANCHO + x);
}

uint game_posicion_valida(int x, int y) {
	return (x >= 0 && y >= 0 && x < MAPA_ANCHO && y < MAPA_ALTO);
}

pirata_t* id_pirata2pirata(uint id_pirata)
{
    // ~ completar ~
	return NULL;
}

uint game_dir2xy(direccion dir, int *x, int *y)
{
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

uint game_valor_tesoro(uint x, uint y)
{
	int i;
	for (i = 0; i < BOTINES_CANTIDAD; i++)
	{
		if (botines[i][0] == x && botines[i][1] == y)
			return botines[i][2];
	}
	return 0;
}

// dada una posicion (x,y) guarda las posiciones de alrededor en dos arreglos, uno para las x y otro para las y
void game_calcular_posiciones_vistas(int *vistas_x, int *vistas_y, int x, int y)
{
	int next = 0;
	int i, j;
	for (i = -1; i <= 1; i++)
	{
		for (j = -1; j <= 1; j++)
		{
			vistas_x[next] = x + j;
			vistas_y[next] = y + i;
			next++;
		}
	}
}


void game_inicializar(){
    game_jugador_inicializar(&jugadorA);
    game_jugador_inicializar(&jugadorB);
}

void game_jugador_inicializar_mapa(jugador_t *jug)
{
}

//TODO:inicializar jugador detectando que codigo usar
void game_jugador_inicializar(jugador_t* j){
    static int id = 0;
    j->id = id++;

    int i;
    for(i = 0; i<MAX_CANT_PIRATAS_VIVOS; i++){
        j->piratas[i].vivo = FALSE;
    }
    j->cant_piratas = 0;
    j->cant_exploradores = 0;
    j->cant_mineros = 0;

    if(id == JUGADOR_A){
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

    return;
}

pirata_t* game_pirata_inicializar(jugador_t *j, uint tipo){
    //busco que pirata esta libre
    int i;
    for(i = 0; i < MAX_CANT_PIRATAS_VIVOS; i++){
        if(j->piratas[i].vivo == FALSE)
            break;
    }

    //TODO: que onda con devolver referencias a variables locales?
    pirata_t* p = &(pirata_t){
        .id = i,
        .coord = j->coord_puerto,
        .tipo = tipo,
        .ticks = 0,
        .vivo = TRUE,
        .codigo = (tipo == PIRATA_E) ? j->codigo_explorador : j->codigo_minero
    };

    return p;
}

void game_tick(uint id_pirata)
{
}


void game_pirata_relanzar(jugador_t *j, pirata_t *pirata, uint tipo)
{
}

pirata_t* game_jugador_erigir_pirata(jugador_t *j, uint tipo){
    pirata_t* p = game_pirata_inicializar(j, tipo);

    int gdt_offset;
    if(j->id == JUGADOR_A){
        gdt_offset = 15;
    } else {
        gdt_offset = 23;
    }

    //Busco tss libre para el pirata
    int i;
    for(i = 0; i < MAX_CANT_PIRATAS_VIVOS; i++){
        if(gdt[gdt_offset+i].p == 0) break;
    }

    uint* dir_tss = tss_inicializar_pirata(j, p);
    gdt_incializar_pirata(gdt_offset+i, dir_tss);

	return p;
}


void game_jugador_lanzar_pirata(jugador_t *j, uint tipo){
    if(j->cant_piratas <= MAX_CANT_PIRATAS_VIVOS){
        j->cant_piratas++;
        if(tipo == PIRATA_E){
            j->cant_exploradores++;
        }else{
            j->cant_mineros++;
        }
        pirata_t* p = game_jugador_erigir_pirata(j, tipo);
        //TODO: esto pierde memoria? conviene que piratas sea un array de pirata_t*?
        j->piratas[p->id] = *p;
    }

    return;


}

void game_pirata_habilitar_posicion(jugador_t *j, pirata_t *pirata, int x, int y)
{
}


void game_explorar_posicion(jugador_t *jugador, int c, int f)
{
}


uint game_syscall_pirata_mover(uint id, direccion dir)
{
    // ~ completar
    return 0;
}

uint game_syscall_cavar(uint id)
{
    // ~ completar ~

	return 0;
}

uint game_syscall_pirata_posicion(uint id, int idx)
{
    // ~ completar ~
    return 0;
}

uint game_syscall_manejar(uint syscall, uint param1)
{
    // ~ completar ~
    return 0;
}

void game_pirata_exploto(uint id)
{
}

pirata_t* game_pirata_en_posicion(uint x, uint y)
{
	return NULL;
}


void game_jugador_anotar_punto(jugador_t *j)
{
}



void game_terminar_si_es_hora()
{
}


#define KB_w_Aup    0x11 // 0x91
#define KB_s_Ado    0x1f // 0x9f
#define KB_a_Al     0x1e // 0x9e
#define KB_d_Ar     0x20 // 0xa0
#define KB_e_Achg   0x12 // 0x92
#define KB_q_Adir   0x10 // 0x90
#define KB_i_Bup    0x17 // 0x97
#define KB_k_Bdo    0x25 // 0xa5
#define KB_j_Bl     0x24 // 0xa4
#define KB_l_Br     0x26 // 0xa6
#define KB_shiftA   0x2a // 0xaa
#define KB_shiftB   0x36 // 0xb6


void game_atender_teclado(unsigned char tecla)
{
}
