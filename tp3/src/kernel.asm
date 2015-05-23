; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================


%include "imprimir.mac"

global start


;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
iniciando_mr_msg db     'Iniciando kernel (Modo Real)...'
iniciando_mr_len equ    $ - iniciando_mr_msg

iniciando_mp_msg db     'Iniciando kernel (Modo Protegido)...'
iniciando_mp_len equ    $ - iniciando_mp_msg

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; Deshabilitar interrupciones
    cli

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; Imprimir mensaje de bienvenida
    imprimir_texto_mr iniciando_mr_msg, iniciando_mr_len, 0x07, 0, 0

    ; Habilitar A20
    call habilitar_A20

    ; Cargar la GDT
    lgdt [GDT_DESC]
    ; Setear el bit PE del registro CR0
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    ; Saltar a modo protegido
    jmp 0x40:modo_protegido         ;index 8, gdt/ldt 0, rpl 00

BITS 32
modo_protegido:

    ; Establecer selectores de segmentos
    xor eax, eax
    mov ax, 0x48                ;index 9, gdt/ldt 0, rpl 00
    mov ds, ax
    mov ss, ax                  ; stack segment same as data segment

    ; Cargo video
    xor eax, eax
    mov ax, 01100000b           ;index 12, video
    mov fs, ax

    ; Establecer la base de la pila
    xor eax, eax
    mov eax, 0x27000
    mov esp, eax
    mov ebp, eax

    ; Imprimir mensaje de bienvenida
    imprimir_texto_mp iniciando_mp_msg, iniciando_mp_len, 0x07, 0, 0

    ; Inicializar el juego


    ; Inicializar pantalla

    ;pinto fondo de gris
    push 80
    push 50
    push 0
    push 0
    push 0x77
    push 0x00
    call screen_pintar_rect
    add esp, 6*4

    ;pinto lineas con comandos abajo en negro
    push 80
    push 50
    push 0
    push 45
    push 0x00
    push 0x00
    call screen_pintar_rect
    add esp, 6*4

    ;pinto panel primer jugador
    push 10                 ;ancho
    push 5                  ;alto
    push 30                 ;columna
    push 45                 ;fila
    push 0x99
    push 0x00
    call screen_pintar_rect
    add esp, 6*4

    ;pinto panel segundo jugador
    push 10                 ;ancho
    push 5                  ;alto
    push 40                 ;columna
    push 45                 ;fila
    push 0xCC
    push 0x00
    call screen_pintar_rect
    add esp, 6*4

    ; Inicializar el manejador de memoria

    ; Inicializar el directorio de paginas

    ; Cargar directorio de paginas

    ; Habilitar paginacion

    ; Inicializar tss

    ; Inicializar tss de la tarea Idle

    ; Inicializar el scheduler

    ; Inicializar la IDT
    call idt_inicializar

    ; Cargar IDT
    lidt [IDT_DESC]

    ; Configurar controlador de interrupciones

    ; Cargar tarea inicial

    ; Habilitar interrupciones
    sti

    ; Saltar a la primera tarea: Idle

    ; Ciclar infinitamente (por si algo sale mal...)
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
extern GDT_DESC
extern IDT_DESC
extern idt_inicializar
extern screen_pintar_rect
extern screen_pintar_linea_h
