; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
; definicion de rutinas de atencion de interrupciones

%include "imprimir.mac"

interrupcion db     'Cargada interrupcion...'
interrupcion_len equ    $ - interrupcion

int_clock db        'Interrupcion reloj...'
int_clock_len equ   $ - int_clock

int_keyboard db        'Interrupcion teclado...'
int_keyboard_len equ   $ - int_keyboard

BITS 32

offset: dd 0
selector: dw 0
;; PIC
extern fin_intr_pic1

;; Sched
extern sched_tick
extern sched_tarea_actual

; Text print
extern print_hex

; Clock tick
extern screen_actualizar_reloj_global


; Atender interrupcion de teclado
extern game_atender_teclado
;;
;; Definición de MACROS
;; -------------------------------------------------------------------------- ;;

%macro ISR 1
global _isr%1

_isr%1:
    mov eax, %1
    imprimir_texto_mp interrupcion, interrupcion_len, 0x07, 0, 0
    iret

%endmacro

;;
;; Datos
;; -------------------------------------------------------------------------- ;;
; Scheduler

;;
;; Rutina de atención de las EXCEPCIONES
;; -------------------------------------------------------------------------- ;;

; Rutina de atención del RELOJ
global _isr32

_isr32:
    pusha
    call screen_actualizar_reloj_global
    call fin_intr_pic1
    call proximo_reloj
    popa
    iret


; Rutina de atención del TECLADO
global _isr33
;TODO: Test

_isr33:
    pusha
    in al, 0x60

    push 0x07   ;color
    push 0x00
    push 0x00
    push 3      ;size
    push eax
    call print_hex
    add esp, 5*4
    call fin_intr_pic1

    push eax
    call game_atender_teclado
    pop eax

    popa
    iret



; Rutina de atención de COSA
global _isr46

_isr46:
    pusha
    mov eax, 0x42
    popa
    iret

;;
;; Rutinas de atención de las SYSCALLS
;; -------------------------------------------------------------------------- ;;

ISR 0
ISR 1
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
;--------------------------------------------------------------------------------;;

proximo_reloj:
    call sched_proxima_a_ejecutar
    cmp ax, 0
    je .fin
    cmp ax, 14
    je .fin

    shl ax, 3
    mov [selector], ax
    jmp far [offset]

    ;fin scheduler
    .fin:
    ret

extern sched_proxima_a_ejecutar
