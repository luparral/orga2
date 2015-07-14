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

nombre_grupo     db     'SnakeII/Nokia1100'
nombre_grupo_len equ    $ - nombre_grupo

offset: dd 0
selector: dw 0
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
    mov ax, 9                ;index 9, gdt/ldt 0, rpl 00
    shl ax, 3
    mov ds, ax
    mov ss, ax                  ; stack segment same as data segment

    ; Cargo video
    xor eax, eax
    mov ax, 12           ;index 12, video
    shl ax, 3
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
    pintar_rect 0x00, 0x77, 0, 0, 50, 80
    ;pinto lineas con comandos abajo en negro
    pintar_rect 0x00, 0x00, 45, 0, 50, 80
    ;pinto panel primer jugador
    pintar_rect 0x00, 0x99, 45, 30, 5, 10
    ;pinto panel segundo jugador
    pintar_rect 0x00, 0xCC, 45, 40, 5, 10

    ; Inicializar el manejador de memoria

    ; Inicializar el directorio de paginas
    ; Cargar directorio de paginas

    ; Habilitar paginacion
    call mmu_inicializar_dir_kernel
    mov cr3, eax
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

    ;Imprimir nombre de grupo en borde derecho
    imprimir_texto_mp nombre_grupo, nombre_grupo_len, 0x07, 0, 63


    ;Inicializar mmu
    call mmu_inicializar

    ; Inicializar tss
    call gdt_inicializar_tareas
    call tss_inicializar

    ; Inicializar tss de la tarea Idle

    ; Inicializar el scheduler
    call sched_inicializar

    ; Inicializar la IDT
    call idt_inicializar

    ; Cargar IDT
    lidt [IDT_DESC]

    ; Configurar controlador de interrupciones
    call resetear_pic
    call habilitar_pic

    ; Cargar tarea inicial
    mov ax, 13
    shl ax, 3
	ltr ax

    ; Habilitar interrupciones
    sti

    ; Saltar a la primera tarea: Idle
    mov ax, 14
    shl ax, 3
    mov [selector], ax
    jmp far [offset]

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
extern gdt_inicializar_tareas
extern IDT_DESC
extern idt_inicializar
extern screen_pintar_rect
extern screen_pintar_linea_h
extern mmu_inicializar_dir_kernel
extern mmu_inicializar
extern mmu_inicializar_dir_pirata
extern tss_inicializar
extern sched_inicializar

extern resetear_pic
extern habilitar_pic
