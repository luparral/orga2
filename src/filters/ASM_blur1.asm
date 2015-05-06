; **************************************************************************;
; Organizacion del Computador II                                            ;
;                                                                           ;
;   Implementacion de la funcion Blur 1                                     ;
;                                                                           ;
; **************************************************************************;
extern malloc
extern free

;char* copiar_row(uint8_t* dest, uint8_t* src, uint32_t w)
%macro copiar_row 3
    ;codigo
    xor r8, r8
    lea r9, [%2]
    mov rcx, %3
    shr rcx, 2

    %%ciclo:
        movdqu xmm0, [r9+r8]
        movdqu [%1+r8], xmm0
        add r8, 16
    loop %%ciclo
    ;end_codigo
%endmacro

%define SIZE    4

section .data

packed_nueve: dd 9.0,9.0,9.0,9.0
azul_y_rojo: db 0xFF, 0xFF, 0xFF, 0xFF, 0xff, 0x00, 0x00, 0x00

section .text

; void ASM_blur1( uint32_t w, uint32_t h, uint8_t* data )
global ASM_blur1

ASM_blur1:
push rbp
mov rbp, rsp
sub rsp, 8
push rbx
push r12
push r13
push r14
push r15

;codigo
    ;rdi: width
    ;rsi: height
    ;rdx: *data

    ;la idea del algoritmo es usar los primeros 4 pixeles de la primer, segunda y tercer fila y sumarlos
    ;luego avanzar 8 pixeles en la columna, obtener los pixeles de la primer, segunda y tercer fila
    ;es decir, asi voy a tener la informacion de los primeros 6 pixeles de arriba, del medio y de abajo
    ;sumar el primer resultado con el segundo resultado, con eso ya voy a tener la informacion para hacer los 4 pixeles del medio
    ;
    ;   |  |  |  |  |  |  |
    ;   |  |--|--|--|--|  |
    ;   |  |  |  |  |  |  |

    ;primero hay que dejar un offset para no tocar los pixeles sobre la linea (rdx+width*4)
    ;hay que tenerlo en cuenta tambien para los pixeles en la linea de la columna, rdx +4 debe alcanzar
    ;luego ya se puede ir sumando de a width*4, hasta que este en la anteultima linea (height-1)

    mov r12, rdi                    ;r12: ancho de la imagen en pixeles
    mov r13, rsi                    ;r13: alto de la imagen en pixeles
    mov rbx, rdx                    ;rbx; *imagen

    lea rdi, [r12*4+4]                ;rdi: ancho de la imagen en bytes :)
    call malloc                     ;rbp: *vector1 de una linea de ancho
    mov rbp, rax
    lea rdi, [r12*4+4]
    call malloc                     ;rax: *vector2 de una linea de ancho

    xor r14, r14                    ;r14: contador para el alto
    add r14, 2

    copiar_row rbp, rbx, r12
    copiar_row rax, rbx+r12*4, r12  ;rax: vector con linea siguiente

    pxor xmm15, xmm15

    .ciclo_alto:
        xor r15, r15                ;r15: contador para el ancho
        add r15, 2

        .ciclo_ancho:

            ;traigo los 4 pixeles de top y les hago unpck
            movdqu xmm0, [rbp+r15*4-8]  ;xmm0: |3p|2p|1p|0p|
            ;movdqu xmm0, [rbx]
            pxor xmm1, xmm1
            movdqu xmm1, xmm0
            punpcklbw xmm0, xmm15       ;xmm0: |00|r1|00|g1|00|b1|00|a1|00|r0|00|g0|00|b0|00|a0| 1ra fila
            punpckhbw xmm1, xmm15       ;xmm1: |00|r3|00|g3|00|b3|00|a3|00|r2|00|g2|00|b2|00|a2| 1ra fila

            ;traigo los 4 pixeles de middle y les hago unpck
            movdqu xmm2, [rax+r15*4-8]
            ;movdqu xmm2, [rbx+r12*4]
            pxor xmm3, xmm3
            movdqu xmm3, xmm2
            punpcklbw xmm2, xmm15       ;xmm2: |00|r1|00|g1|00|b1|00|a1|00|r0|00|g0|00|b0|00|a0| 2da fila
            punpckhbw xmm3, xmm15       ;xmm3: |00|r3|00|g3|00|b3|00|a3|00|r2|00|g2|00|b2|00|a2| 2da fila

            ;traigo los 4 pixeles de bottom y les hago unpck
            movdqu xmm4, [rbx+r12*8-4]  ;xmm4: |2p|2p|2p|2p|1p|1p|1p|1p|0p|0p|0p|0p|xx|xx|xx|xx|
            psrldq xmm4, 4              ;xmm4  |00|00|00|00|2p|2p|2p|2p|1p|1p|1p|1p|0p|0p|0p|0p|
            pxor xmm5, xmm5
            movdqu xmm5, xmm4
            punpcklbw xmm4, xmm15       ;xmm4: |00|r1|00|g1|00|b1|00|a1|00|r0|00|g0|00|b0|00|a0| 3ra fila
            punpckhbw xmm5, xmm15       ;xmm5: |00|00|00|00|00|00|00|00|00|r2|00|g2|00|b2|00|a2| 3ra fila

            ;suma vertical sobre la parte baja de los primeros 4px
            paddw xmm0, xmm2
            paddw xmm0, xmm4            ;xmm0: |r1|g1|b1|a1|r0|g0|b0|a0| 1ra*2da+3ra fila

            ;suma vertical sobre la parte alta de los primeros 4px
            paddw xmm1, xmm3
            paddw xmm1, xmm5            ;xmm1: |00|00|00|00|r2|g2|b2|a2| 1ra*2da+3ra fila

            ;suma vertical sobre xmm0 y xmm1
            movdqu xmm2, xmm0           ;xmm2: |r1|g1|b1|a1|r0|g0|b0|a0| 1ra*2da+3ra fila
            paddw xmm0, xmm1            ;xmm0: |r1+0|g1+0|b1+0|a1+0|r0+r2|g0+g2|b0+b2|a0+a2|

            ;busco sumar 3 pixeles contiguos
            pslldq xmm1, 8              ;xmm1: |r2|g2|b2|a2|00|00|00|00|
            psrldq xmm2, 8              ;xmm2: |00|00|00|00|r1|g1|b1|a1| 1ra*2da+3ra fila
            paddw xmm0, xmm1            ;xmm0: |r1+0+r2|g1+0+g2|b1+0+b2|a1+0+a2|r0+r2|g0+g2|b0+b2|a0+a2|
            paddw xmm0, xmm2            ;xmm0: |r1+0+r2|g1+0+g2|b1+0+b2|a1+0+a2|r0+r2+r1|g0+g2+g1|b0+b2+b1|a0+a2+a1|

            ;extiendo a dwords
            movdqu xmm1, xmm0
            punpcklwd xmm0, xmm15       ;xmm0: |00|r0+r2+r1|00|b0+b2+b1|00|g0+g2+g1|00|a0+a2+a1|
            punpckhwd xmm1, xmm15       ;xmm1: |00|0+r2+r1|00|0+b2+b1|00|0+g2+g1|00|0+a2+a1|

            ;convierto a floats para poder dividir
            cvtdq2ps xmm0, xmm0         ;xmm0: |r0+r2+r1|b0+b2+b1|g0+g2+g1|a0+a2+a1|
            cvtdq2ps xmm1, xmm1         ;xmm1: |0+r2+r1|0+b2+b1|0+b2+b1|0+a2+a1|

            ;divido por 9
            movdqu xmm2, [packed_nueve]
            divps xmm0, xmm2
            divps xmm1, xmm2

            ;convierto de float a integer
            cvtps2dq xmm0, xmm0         ;xmm0: resultado del 1er pixel |00|r0
            cvtps2dq xmm1, xmm1         ;xmm1: resultado del 2do pixel

            packusdw xmm0, xmm1         ;xmm0: |00r1|00b1|00g1|00a1|00r0|00b0|00g0|00a0|
            packuswb xmm0, xmm0         ;xmm0: |00|00|00|00|00|00|00|r1|b1|g1|a1|r0|b0|g0|a0|

            ;movq xmm0, [azul_y_rojo]
            movd [rbx+r12*4+4], xmm0
            add rbx, 4
            inc r15
            cmp r15, r12
        jne .ciclo_ancho
        add rbx, 8

        copiar_row rbp, rax, r12
        copiar_row rax, rbx+r12*4, r12  ;rax: vector con linea siguiente

        inc r14
        cmp r14, r13
    jne .ciclo_alto

    mov rdi, rbp
    mov r12, rax
    call free
    mov rdi, r12
    call free
;end codigo



pop r15
pop r14
pop r13
pop r12
pop rbx
add rsp, 8
pop rbp
ret
