/* ** por compatibilidad se omiten tildes **
================================================================================
TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
definicion de funciones del scheduler
*/

#include "screen.h"
#include "game.h"


extern jugador_t jugadorA, jugadorB;


static ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO;

const char reloj[] = "|/-\\";
#define reloj_size 4


void screen_actualizar_reloj_global()
{
    static uint reloj_global = 0;

    reloj_global = (reloj_global + 1) % reloj_size;

    screen_pintar(reloj[reloj_global], C_BW, 49, 79);
}

void screen_actualizar_reloj_pirata(uint x, uint y){
    static uint reloj_global = 0;

    reloj_global = (reloj_global + 1) % reloj_size;

    screen_pintar(reloj[reloj_global], C_BW, x, y);
}


void screen_pintar(uchar c, uchar color, uint fila, uint columna){
    p[fila][columna].c = c;
    p[fila][columna].a = color;
}

uchar screen_valor_actual(uint fila, uint columna)
{
    return p[fila][columna].c;
}

void print(const char * text, uint x, uint y, unsigned short attr) {
    int i;
    for (i = 0; text[i] != 0; i++){
        screen_pintar(text[i], attr, y, x);

        x++;
        if (x == VIDEO_COLS) {
            x = 0;
            y++;
        }
    }
}

void print_hex(uint numero, int size, uint x, uint y, unsigned short attr) {
    int i;
    char hexa[8];
    char letras[16] = "0123456789ABCDEF";
    hexa[0] = letras[ ( numero & 0x0000000F ) >> 0  ];
    hexa[1] = letras[ ( numero & 0x000000F0 ) >> 4  ];
    hexa[2] = letras[ ( numero & 0x00000F00 ) >> 8  ];
    hexa[3] = letras[ ( numero & 0x0000F000 ) >> 12 ];
    hexa[4] = letras[ ( numero & 0x000F0000 ) >> 16 ];
    hexa[5] = letras[ ( numero & 0x00F00000 ) >> 20 ];
    hexa[6] = letras[ ( numero & 0x0F000000 ) >> 24 ];
    hexa[7] = letras[ ( numero & 0xF0000000 ) >> 28 ];
    for(i = 0; i < size; i++) {
        p[y][x + size - i - 1].c = hexa[i];
        p[y][x + size - i - 1].a = attr;
    }
}

void print_dec(uint numero, int size, uint x, uint y, unsigned short attr) {
    int i;
    char letras[16] = "0123456789";

    for(i = 0; i < size; i++) {
        int resto  = numero % 10;
        numero = numero / 10;
        p[y][x + size - i - 1].c = letras[resto];
        p[y][x + size - i - 1].a = attr;
    }
}

void screen_pintar_rect(unsigned char c, unsigned char color, int fila, int columna, int alto, int ancho){
    int i;
    int j = 0;

        for(i = 0; i < alto; i++){
            for(j = 0; j < ancho; j++){
                screen_pintar(c, color, fila+i, columna+j);
            }
        }
}

void screen_pintar_linea_h(unsigned char c, unsigned char color, int fila, int columna, int ancho){
    int i;

    for(i = 0; i < ancho; i++){
        screen_pintar(c, color, fila, columna+i);
    }

}

void screen_inicializar(){
    int i;
    int j;
    //pintar fondo
    for (i = 0; i < VIDEO_FILS; i++) {
        for (j = 0; j < VIDEO_COLS; j++) {
            p[i][j].c = 0;
            p[i][j].a = C_BG_LIGHT_GREY;
        }
    }
    print("SnakeII/Nokia1100", 63, 0, C_BG_LIGHT_GREY | C_FG_RED );
    //pintar panel de jugador
    for (i = 45; i < VIDEO_FILS ; i++) {
        for (j = 0; j < VIDEO_COLS; j++) {
            p[i][j].c = 0;
            p[i][j].a = C_BG_BLACK;
        }
        for(j = 30; j < 40; j++){
            p[i][j].c = 0;
            p[i][j].a = C_BG_RED;
        }
        for(j = 40; j < 50; j++){
            p[i][j].c = 0;
            p[i][j].a = C_BG_BLUE;
        }
    }

    //pinto el numero de jugadores
    for (i = 0; i < 8; i++) {
        screen_pintar(0x31+i, C_FG_WHITE, 46, 4+i*2);
        screen_pintar(0x78, C_FG_RED, 48, 4+i*2);
        //-4 for the margin, -16 for the text start
        screen_pintar(0x31+i, C_FG_WHITE, 46, VIDEO_COLS-20+i*2);
        screen_pintar(0x78, C_FG_RED, 48, VIDEO_COLS-20+i*2);
    }

    return;
}

coord_t getStatusCoords(uint id){
    return (coord_t){
        .x = 4+id*2,
        .y = 48
    };
}

void screen_actualizar(){
    print_hex(jugadorA.monedas, 1, 36, 47, C_BG_RED + C_FG_WHITE);
    print_hex(jugadorB.monedas, 1, 46, 47, C_BG_BLUE + C_FG_WHITE);

    int suma=0;
    if(jugador_actual == jugadorB.id)
        suma = 56;

    coord_t coord = getStatusCoords(pirata_actual);
    if(id_pirata2pirata(pirata_actual)->vivo){
        screen_actualizar_reloj_pirata(coord.y, coord.x);
    } else {
        screen_pintar(0x78, C_FG_RED, 48, suma + (4+pirata_actual*2));
    }
}



void save_screen(){
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO;
    int i = 0, j = 0;

    for (j = 0; j < VIDEO_FILS; j++){
        for (i = 0; i < VIDEO_COLS; i++){
            temp[j][i] = p[j][i];
        }
    }
}

void screen_pantalla_debug(unsigned int edi, unsigned int esi, unsigned int ebp, unsigned int falsoesp, unsigned int ebx, unsigned int edx, unsigned int ecx, unsigned int eax, unsigned int errorCode, unsigned int eip, unsigned int cs, unsigned int eflags, unsigned int esp, unsigned int ss){

    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO;
    int i = 0, j = 0;

    save_screen();

    //Recuadro
    for (i = 25; i< 55; i++){
        p[6][i].c = ' ';
        p[6][i].a = C_BG_BLACK;
        p[41][i].c = ' ';
        p[41][i].a = C_BG_BLACK;
    }

    for (j = 7; j<42; j++){
        p[j][25].c = ' ';
        p[j][25].a = C_BG_BLACK;
        p[j][54].c = ' ';
        p[j][54].a = C_BG_BLACK;
    }

    //Fondo gris
    for (j = 8; j<41; j++){
        for (i = 26; i<54; i++){
            p[j][i].c = ' ';
            p[j][i].a = C_BG_LIGHT_GREY;
        }
    }


    tss pirata;
    if (jugador_actual == JUGADOR_A){
        pirata = tss_jugadorA[pirata_actual];
    }else{
        pirata = tss_jugadorB[pirata_actual];
    }

////////////////////////

    uint num;
    num = eax;
    print("eax", 27, 9, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(eax, 8, 31, 9, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("ebx", 27, 11, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(ebx, 8, 31, 11, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("ecx", 27, 13, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(ecx, 8, 31, 13, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("edx", 27, 15, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(edx, 8, 31, 15, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("esi", 27, 17, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(esi, 8, 31, 17, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("edi", 27, 19, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(edi, 8, 31, 19, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("ebp", 27, 21, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(ebp, 8, 31, 21, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("esp", 27, 23, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(esp, 8, 31, 23, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("eip", 27, 25, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(eip, 8, 31, 25, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("cs", 28, 27, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(cs, 8, 31, 27, C_BG_LIGHT_GREY | C_FG_WHITE);

    num = pirata.ds;
    print("ds", 28, 29, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(num, 8, 31, 29, C_BG_LIGHT_GREY | C_FG_WHITE);

    num = pirata.es;
    print("es", 28, 31, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(num, 8, 31, 31, C_BG_LIGHT_GREY | C_FG_WHITE);

    num = pirata.fs;
    print("fs", 28, 33, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(num, 8, 31, 33, C_BG_LIGHT_GREY | C_FG_WHITE);

    num = pirata.gs;
    print("gs", 28, 35, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(num, 8, 31, 35, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("ss", 28, 37, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(ss, 8, 31, 37, C_BG_LIGHT_GREY | C_FG_WHITE);

    print("eflags", 28, 39, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(eflags, 8, 34, 39, C_BG_LIGHT_GREY | C_FG_WHITE);


    num = rcr0();
    print("cr0", 41, 9, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(num, 8, 45, 9, C_BG_LIGHT_GREY | C_FG_WHITE);

    num = rcr2();
    print("cr2", 41, 11, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(num, 8, 45, 11, C_BG_LIGHT_GREY | C_FG_WHITE);

    num = pirata.cr3;
    print("cr3", 41, 13, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(num, 8, 45, 13, C_BG_LIGHT_GREY | C_FG_WHITE);

    num = rcr4();
    print("cr4", 41, 15, C_BG_LIGHT_GREY | C_FG_BLACK);
    print_hex(num, 8, 45, 15, C_BG_LIGHT_GREY | C_FG_WHITE);

    uint* stack = (uint*) esp;

    print("stack", 41, 26, C_BG_LIGHT_GREY | C_FG_BLACK);

    num = *stack;
    print_hex(num, 8, 41, 29, C_BG_LIGHT_GREY | C_FG_WHITE);

    stack++;
    num = *stack;
    print_hex(num, 8, 41, 30, C_BG_LIGHT_GREY | C_FG_WHITE);

    stack++;
    num = *stack;
    print_hex(num, 8, 41, 31, C_BG_LIGHT_GREY | C_FG_WHITE);

    stack++;
    num = *stack;
    print_hex(num, 8, 41, 32, C_BG_LIGHT_GREY | C_FG_WHITE);
}

void load_screen(){
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO;
    int i = 0, j = 0;

    for (j = 0; j < VIDEO_FILS; j++){
        for (i = 0; i < VIDEO_COLS; i++){
            p[j][i] = temp[j][i];
        }
    }
}
