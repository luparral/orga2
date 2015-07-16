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

}

coord_t getStatusCoords(uint id){
    coord_t res;

    if(id == 0){
        //print("0", 5, 10, C_BG_LIGHT_GREY | C_FG_RED );
        res.x = 4;
        res.y = 48;
    }else if(id==1){
        //print("1", 5, 12, C_BG_LIGHT_GREY | C_FG_RED );
        res.x = 6;
        res.y = 48;
    }else if(id==2){
        //print("2", 5, 14, C_BG_LIGHT_GREY | C_FG_RED );
        res.x = 8;
        res.y = 48;
    }else if(id==3){
        //print("3", 5, 16, C_BG_LIGHT_GREY | C_FG_RED );
        res.x = 10;
        res.y = 48;
    }else if(id==4){
        //print("4", 5, 18, C_BG_LIGHT_GREY | C_FG_RED );
        res.x = 12;
        res.y = 48;
    }else if(id==5){
        //print("5", 5, 20, C_BG_LIGHT_GREY | C_FG_RED );
        res.x = 14;
        res.y = 48;
    }else if(id==6){
        //print("6", 5, 22, C_BG_LIGHT_GREY | C_FG_RED );
        res.x = 16;
        res.y = 48;
    }else if(id==7){
        //print("7", 5, 24, C_BG_LIGHT_GREY | C_FG_R&ED );
        res.x = 18;
        res.y = 48;
    }

    return res;
}

void screen_actualizar(){
    // ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO; //magia
    print_hex(jugadorA.monedas, 1, 36, 47, C_BG_BLUE + C_FG_WHITE);
    print_hex(jugadorB.monedas, 1, 41, 47, C_BG_RED + C_FG_WHITE);

    //print_hex(screen_actualizar_reloj_posicion(4,8), 1 , 4, 48 ,C_FG_WHITE);
    int suma=0;
    if(jugador_actual == jugadorB.id)
        suma = 56;

    // for (i = 0; i < MAX_CANT_PIRATAS_VIVOS; ++i) {
    //     pirata_t myPirate = game_get_jugador_actual()->piratas[i];
    //     coord_t coord = getStatusCoords(myPirate.id);

    //     if(pirata_actual == myPirate.id)
    //         if(myPirate.vivo){
    //             screen_actualizar_reloj_pirata(coord.x, coord.y);
    //         } else {
    //             screen_pintar(0x78, C_FG_RED, 48, suma + (4+i*2));
    //         }
    // }
    coord_t coord = getStatusCoords(pirata_actual);
    if(id_pirata2pirata(pirata_actual)->vivo){
        screen_actualizar_reloj_pirata(coord.x, coord.y);
    } else {
        screen_pintar(0x78, C_FG_RED, 48, suma + (4+pirata_actual*2));
    }
    
    //56
    // print_hex(2, 1 , 6, 48 ,C_FG_WHITE);
    // print_hex(3, 1 , 8, 48 ,C_FG_WHITE);
    // print_hex(4, 1 , 10, 48 ,C_FG_WHITE);
    // print_hex(5, 1 , 12, 48 ,C_FG_WHITE);
    // print_hex(6, 1 , 14, 48 ,C_FG_WHITE);
    // print_hex(7, 1 , 16, 48 ,C_FG_WHITE);
    // print_hex(8, 1 , 18, 48 ,C_FG_WHITE);
    

    //46 5

    //print_hex(20-jugadorA.cant_piratas, 2, 30, 47, C_BG_RED + C_FG_WHITE);
    //print_hex(20-jugadorB.cant_piratas, 2, 47, 47, C_BG_BLUE + C_FG_WHITE);
    
    
    // if (current_player == 0){
    //     if (gdt[current_zombi+15].p == 1){
    //         p[48][4+current_zombi*2].c = timer[(int)info_zombiA[current_zombi].clock];
    //         p[48][4+current_zombi*2].a = C_FG_WHITE | C_BG_BLACK;
    //         info_zombiA[current_zombi].clock ++;
    //         info_zombiA[current_zombi].clock = info_zombiA[current_zombi].clock%3;
    //     }
    // } else {
    //     if (gdt[current_zombi+23].p == 1){
    //         p[48][59+current_zombi*2].c = timer[(int)info_zombiB[current_zombi].clock];
    //         p[48][59+current_zombi*2].a = C_FG_WHITE | C_BG_BLACK;
    //         info_zombiB[current_zombi].clock++;
    //         info_zombiB[current_zombi].clock = info_zombiB[current_zombi].clock%3;
    //     }
    // }
    
    // int i;
    // for (i = 0; i < 8; ++i){
    //     if (gdt[i+15].p == 1){
    //         print(&info_zombiA[i].tipo, info_zombiA[i].x, info_zombiA[i].y, C_BG_RED | C_FG_WHITE);
    //     }
    //     if (gdt[i+23].p == 1){
    //         print(&info_zombiB[i].tipo, info_zombiB[i].x, info_zombiB[i].y, C_BG_BLUE | C_FG_WHITE);
    //     }
    // }
    
    // if (((jugadorA.zombis_totales == 20 || jugadorA.zombis_restantes == 0) 
    //     && (jugadorB.zombis_restantes == 0 || jugadorB.zombis_totales == 20))){
    //         contador_inactivos++;
    // }
    
    // print_hex(1000 - contador_inactivos, 4, 0, 49, C_FG_WHITE);
    
    // if ((jugadorA.zombis_muertos == 20 && jugadorB.zombis_muertos == 20) || (contador_inactivos == 1000) || 
    //     (jugadorA.puntos > 8 || jugadorB.puntos > 8)) {
    //     if (jugadorA.puntos > jugadorB.puntos) {
    //         print("Ganaste! Jugador A", 32, 40, C_FG_RED | C_BG_CYAN | C_BLINK);
    //     } else if (jugadorA.puntos < jugadorB.puntos) {
    //         print("Ganaste! Jugador B", 32, 40, C_FG_BLUE | C_BG_CYAN | C_BLINK);
    //     } else {
    //         print("Empate!", 32, 40, C_FG_LIGHT_GREEN | C_BG_CYAN | C_BLINK);
    //     }
    //     while(1);
    // }
}