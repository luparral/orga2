/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#ifndef __SCREEN_H__
#define __SCREEN_H__

/* Definicion de la pantalla */
#define VIDEO_FILS 50
#define VIDEO_COLS 80

#define VIDEO                   0x000B8000 /* direccion fisica del buffer de video */


#include "colors.h"
#include "defines.h"
#include "tss.h"
#include "sched.h"

/* Estructura de para acceder a memoria de video */
typedef struct ca_s {
    unsigned char c;
    unsigned char a;
} ca;

ca temp[VIDEO_FILS][VIDEO_COLS];

struct pirata_t;
typedef struct pirata_t pirata_t;

struct jugador_t;
typedef struct jugador_t jugador_t;

int ee_printf(const char *fmt, ...);


void screen_pintar(unsigned char c, unsigned char color, uint fila, uint columna);
void print(const char * text, unsigned int x, unsigned int y, unsigned short attr);
void print_dec(uint numero, int size, uint x, uint y, unsigned short attr);
void print_hex(unsigned int numero, int size, unsigned int x, unsigned int y, unsigned short attr);
void screen_pintar_rect(unsigned char c, unsigned char color, int fila, int columna, int alto, int ancho);
void screen_pintar_linea_h(unsigned char c, unsigned char color, int fila, int columna, int ancho);
void screen_pintar_linea_v(unsigned char c, unsigned char color, int fila, int columna, int alto);
void screen_inicializar();
void screen_pintar_puntajes();

void screen_actualizar_reloj_global();
void screen_actualizar_reloj_pirata (jugador_t* j, pirata_t* p);
unsigned char screen_color_jugador(jugador_t *j);
unsigned char screen_caracter_pirata(unsigned int tipo);
void screen_pintar_pirata(jugador_t *j, pirata_t *pirata);
void screen_pintar_3x3(unsigned char color, int f, int c);
void screen_cambiar_color(unsigned char color, uint f, uint c);

void screen_borrar_pirata(jugador_t *j, pirata_t *pirata);
void screen_pintar_reloj_pirata(jugador_t *j, pirata_t *pirata);
void screen_pintar_reloj_piratas(jugador_t *j);
void screen_pintar_relojes();
void screen_actualizar_posicion_mapa(uint x, uint y);
void screen_stop_game_show_winner(jugador_t *j);
void load_screen();
void screen_pantalla_debug(unsigned int edi, unsigned int esi, unsigned int ebp, unsigned int falsoesp, unsigned int ebx, unsigned int edx, unsigned int ecx, unsigned int eax, unsigned int errorCode, unsigned int eip, unsigned int cs, unsigned int eflags, unsigned int esp, unsigned int ss);

void screen_actualizar();


#endif  /* !__SCREEN_H__ */
