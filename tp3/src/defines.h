/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

    Definiciones globales del sistema.
*/

#ifndef __DEFINES_H__
#define __DEFINES_H__

#include "i386.h"
/* Tipos basicos */
/* -------------------------------------------------------------------------- */
#define NULL                    0
#define TRUE                    1
#define FALSE                   0
#define ERROR                   1

/* Botones */
/* -------------------------------------------------------------------------- */
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
#define KB_y        0x15


/* Constantes del juego */
/* -------------------------------------------------------------------------- */
#define MAX_CANT_PIRATAS_VIVOS          8
#define JUGADOR_A                       0
#define JUGADOR_B                       1
#define PIRATA_E                        0
#define PIRATA_M                        1
#define CODIGO_TAREA_A_E                0x10000
#define CODIGO_TAREA_A_M                0x11000
#define CODIGO_TAREA_B_E                0x12000
#define CODIGO_TAREA_B_M                0x13000
#define MAPA_ANCHO                      80
#define MAPA_ALTO                       44
#define POS_INIT_A_X                    1
#define POS_INIT_A_Y                    2
#define POS_INIT_B_X       MAPA_ANCHO - 2
#define POS_INIT_B_Y        MAPA_ALTO - 1
#define CANT_POSICIONES_VISTAS          9
#define MAX_SIN_CAMBIOS                 999
#define BOTINES_CANTIDAD 8

/* Constantes basicas */
/* -------------------------------------------------------------------------- */
#define PAGE_SIZE               0x00001000
#define TASK_SIZE               4096
#define BOOTSECTOR              0x00001000 /* direccion fisica de comienzo del bootsector (copiado) */
#define KERNEL                  0x00001200 /* direccion fisica de comienzo del kernel */

/* Indices en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_COUNT 31
#define GDT_IDX_NULL_DESC           0
#define GDT_IDX_CS_OS_DESC          8
#define GDT_IDX_DS_OS_DESC          9
#define GDT_IDX_CS_USR_DESC         10
#define GDT_IDX_DS_USR_DESC         11
#define GDT_IDX_VIDEO_DESC          12
#define GDT_IDX_TSS_INICIAL_DESC    13
#define GDT_IDX_TSS_IDLE_DESC       14
#define GDT_OFFSET_TSS_JUG_A        15
#define GDT_OFFSET_TSS_JUG_B        23

void* error();

#define ASSERT(x) while(!(x)) {};

typedef unsigned char  uchar;
typedef unsigned short ushort;
typedef unsigned int   uint;

typedef enum direccion_e { ARR = 0x4, ABA = 0x7, DER = 0xA, IZQ = 0xD} direccion;

typedef struct coord_t{
    uint x;
    uint y;
} coord_t;

struct jugador_t;

typedef struct pirata_t{
    uint id;
    coord_t coord;
    uint tipo;
    uint ticks;
    uint vivo;
    uint* codigo;
} pirata_t;

typedef struct jugador_t{
    uint id;
    uint monedas;
    pirata_t piratas[MAX_CANT_PIRATAS_VIVOS];
    uint cant_piratas;
    uint cant_exploradores;
    uint mineros_disponibles;
    coord_t coord_puerto;
    coord_t botin;
    uint* codigo_explorador;
    uint* codigo_minero;
    unsigned char explorado[MAPA_ALTO*MAPA_ANCHO];
} jugador_t;

#endif  /* !__DEFINES_H__ */
