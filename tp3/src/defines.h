/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

    Definiciones globales del sistema.
*/

#ifndef __DEFINES_H__
#define __DEFINES_H__

/* Tipos basicos */
/* -------------------------------------------------------------------------- */
#define NULL                    0
#define TRUE                    1
#define FALSE                   0
#define ERROR                   1

typedef unsigned char  uchar;
typedef unsigned short ushort;
typedef unsigned int   uint;

typedef enum direccion_e { ARR = 0x4, ABA = 0x7, DER = 0xA, IZQ = 0xD} direccion;

#define MAX_CANT_PIRATAS_VIVOS           8

#define JUGADOR_A                         0
#define JUGADOR_B                         1

#define PIRATA_E            0
#define PIRATA_M            1

#define CODIGO_TAREA_A_E    0x10000
#define CODIGO_TAREA_A_M    0x11000
#define CODIGO_TAREA_B_E    0x12000
#define CODIGO_TAREA_B_M    0x13000

#define MAPA_ANCHO                       80
#define MAPA_ALTO                        44


#define POS_INIT_A_X                      1
#define POS_INIT_A_Y                      1
#define POS_INIT_B_X         MAPA_ANCHO - 2
#define POS_INIT_B_Y          MAPA_ALTO - 2

#define CANT_POSICIONES_VISTAS            9
#define MAX_SIN_CAMBIOS                 999

#define BOTINES_CANTIDAD 8

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
    pirata_t piratas[MAX_CANT_PIRATAS_VIVOS];
    uint cant_piratas;
    uint cant_exploradores;
    uint cant_mineros;
    coord_t coord_puerto;
    coord_t coord_exploradas[MAPA_ALTO*MAPA_ANCHO];
    uint* codigo_explorador;
    uint* codigo_minero;
    // coordenadas puerto, posiciones exploradas, mineros pendientes, etc
} jugador_t;

/* Constantes basicas */
/* -------------------------------------------------------------------------- */
#define PAGE_SIZE               0x00001000
#define TASK_SIZE               4096

#define BOOTSECTOR              0x00001000 /* direccion fisica de comienzo del bootsector (copiado) */
#define KERNEL                  0x00001200 /* direccion fisica de comienzo del kernel */


/* Indices en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_COUNT 30

#define GDT_IDX_NULL_DESC           0
#define GDT_IDX_CS_OS_DESC          8
#define GDT_IDX_DS_OS_DESC          9
#define GDT_IDX_CS_USR_DESC         10
#define GDT_IDX_DS_USR_DESC         11
#define GDT_IDX_VIDEO_DESC          12
#define GDT_IDX_TSS_INICIAL_DESC    13
#define GDT_IDX_TSS_IDLE_DESC       14

/* Offsets en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_OFF_NULL_DESC           (GDT_IDX_NULL_DESC      << 3)
#define GDT_OFF_TSS_INICIAL_DESC    (GDT_IDX_TSS_INICIAL_DESC << 3)
#define GDT_OFF_TSS_IDLE_DESC    (GDT_IDX_TSS_IDLE_DESC << 3)

/* Selectores de segmentos */
/* -------------------------------------------------------------------------- */

void* error();

#define ASSERT(x) while(!(x)) {};


#endif  /* !__DEFINES_H__ */
