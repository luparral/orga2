; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
; definicion de rutinas de atencion de interrupciones

%include "imprimir.mac"

;interrupcion_0 db       'Divide error'
;interrupcion_0_len equ  $ - interrupcion_0
;
;interrupcion_2 db       'Not Maskable Int'
;interrupcion_2_len equ  $ - interrupcion_2
;
;interrupcion_3 db       'Breakpoint'
;interrupcion_3_len equ  $ - interrupcion_3
;
;interrupcion_4 db       'Overflow'
;interrupcion_4_len equ  $ - interrupcion_4
;
;interrupcion_5 db       'BOUND Range Exceeded'
;interrupcion_5_len equ  $ - interrupcion_5
;
;interrupcion_6 db       'Invalid Opcode (Undefined Opcode)'
;interrupcion_6_len equ  $ - interrupcion_6
;
;interrupcion_7 db       'Device Not Avaible'
;interrupcion_7_len equ  $ - interrupcion_7
;
;interrupcion_8 db       'Double fault'
;interrupcion_8_len equ  $ - interrupcion_8
;
;interrupcion_9 db       'Coprocessor segment Overrun'
;interrupcion_9_len equ  $ - interrupcion_9
;
;interrupcion_10 db      'Invalid TSS'
;interrupcion_10_len equ $ - interrupcion_10
;
;interrupcion_11 db      'Segment Not Present'
;interrupcion_11_len equ $ - interrupcion_11
;
;interrupcion_12 db     'Stack-segmet Fault'
;interrupcion_12_len equ    $ - interrupcion_12
;
;interrupcion_13 db     'General Protection'
;interrupcion_13_len equ    $ - interrupcion_13
;
;interrupcion_14 db     'Page fault'
;interrupcion_14_len equ    $ - interrupcion_14
;
;interrupcion_15 db     'Intel reserved'
;interrupcion_15_len equ    $ - interrupcion_15
;
;interrupcion_16 db     'FPU Error (Math fault)'
;interrupcion_16_len equ    $ - interrupcion_16
;
;interrupcion_17 db     'Alignement Check'
;interrupcion_17_len equ    $ - interrupcion_17
;
;interrupcion_18 db     'Machine Check'
;interrupcion_18_len equ    $ - interrupcion_18
;
;interrupcion_19 db     'SIMD FP exception'
;interrupcion_19_len equ    $ - interrupcion_19

BITS 32

;;
;; Definición de MACROS
;; -------------------------------------------------------------------------- ;;
extern load_screen
extern screen_pantalla_debug
extern modo_debug
extern game_pirata_exploto
%macro ISR 1
global _isr%1

_isr%1:
    mov eax, %1
    ;imprimir_texto_mp interrupcion_%1, interrupcion_%1_len, 0x07, 4, 25

    cmp byte [modo_debug], 0
    je .fin

    ;parametros para screen_pantalla_debug
    pushad
    call screen_pantalla_debug

    .ciclar:
        ; presiono y?
        xor eax, eax
        in al, 0x60
        cmp al, 0x15
        jne .ciclar

        ; cuando presiona y, se devuelve
        call load_screen

    .fin:
        call game_pirata_exploto
        ;despues de llamar a pantalla debug hay que desalojar la tarea actual, por lo que saltamos a idle
        mov ax, 14
        shl ax, 3
        mov [sched_tarea_selector], ax
        jmp far [sched_tarea_offset]

        popad
        iret


%endmacro

;;
;; Datos
sched_tarea_offset:     dd 0x00
sched_tarea_selector:   dw 0x00
;; -------------------------------------------------------------------------- ;;
; Scheduler

;;
;; Rutina de atención de las EXCEPCIONES
;; -------------------------------------------------------------------------- ;;
ISR 0
ISR 2
ISR 3
ISR 4
ISR 5
ISR 6
ISR 7
ISR 8
ISR 9
ISR 10
ISR 11
ISR 12
ISR 13
ISR 14
ISR 15
ISR 16
ISR 17
ISR 18
ISR 19

; Rutina de atención del RELOJ
extern fin_intr_pic1
extern sched_tick
global _isr32
_isr32:
    pusha
    cli
    call fin_intr_pic1
    call sched_tick
    shl ax, 3
    ;Me fijo si es la misma tarea
    str bx
    cmp ax, bx
    je .fin

    mov [sched_tarea_selector], ax
    jmp far [sched_tarea_offset]

    .fin:
    sti
    popa
    iret

; Rutina de atención del TECLADO
extern game_atender_teclado
global _isr33
_isr33:
    pusha
    in al, 0x60
    push eax
    call game_atender_teclado
    pop eax
    call fin_intr_pic1

    popa
    iret

;;
;; Rutinas de atención de las SYSCALLS
;; -------------------------------------------------------------------------- ;;
; Rutina de atención de 0x46
extern game_syscall_manejar
global _isr70
_isr70:
    pusha
    ;en eax tiene el tipo de syscall recibida
    ;en ecx esta la direccion?
    cli
    push ecx
    push eax
    call game_syscall_manejar
    add esp, 8
    ;saltar a la idle
    mov ax, 14
    shl ax, 3
    mov [sched_tarea_selector], ax
    jmp far [sched_tarea_offset]
    sti
    popa
    iret
;--------------------------------------------------------------------------------;;
