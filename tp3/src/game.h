/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#ifndef __GAME_H__
#define __GAME_H__

#include "defines.h"
#include "sched.h"

extern jugador_t jugadorA, jugadorB;

// ~ auxiliares dadas ~
uint game_xy2lineal();
coord_t game_dir2coord(direccion dir);
uint game_posicion_valida(int x, int y);
pirata_t* id_pirata2pirata(jugador_t* j, uint id);
jugador_t* id_jugador2jugador(uint id);

// ~ auxiliares sugeridas o requeridas (segun disponga enunciado) ~
void game_inicializar();

pirata_t* game_pirata_inicializar(jugador_t *jugador, uint tipo);
void game_pirata_exploto();
jugador_t* game_get_jugador_actual();

void game_jugador_inicializar(jugador_t* j, uint id);
void game_jugador_habilitar_posicion(jugador_t *j, pirata_t *pirata);
void game_jugador_lanzar_pirata(jugador_t *j, uint tipo);
void game_jugador_anotar_punto(jugador_t *j);
void game_explorar_posicion(jugador_t *jugador, int x, int y);

uint game_valor_tesoro(uint x, uint y);
pirata_t* game_pirata_en_posicion(uint x, uint y);

uint game_syscall_pirata_posicion(uint id, int idx);
uint game_syscall_pirata_mover(uint id, direccion key);
uint game_syscall_manejar(uint syscall, uint param1);
void game_tick();
void game_terminar_si_es_hora();
void game_atender_teclado(unsigned char tecla);


#endif  /* !__GAME_H__ */
