/* ************************************************************************* */
/* Organizacion del Computador II                                            */
/*                                                                           */
/*   Funciones para ejecutar los filtros y sobre las imagenes                */
/*                                                                           */
/* ************************************************************************* */
#include "rdtsc.h"
#include "run.h"
#include <string.h>

void printAverage(unsigned long acumulador, unsigned int cantidadDeMediciones){
  // float promedio = acumulador/cantidadDeMediciones;
  // printf("Promedio final: %f\n\n",promedio);
}

void printPartial(char* type, unsigned int iteracion, unsigned int cantidadDeMediciones, unsigned long diferencia){
  // printf("[%s] Iteracion %d de %d OK.. [Ciclos = %d]\n", type, iteracion, cantidadDeMediciones, diferencia);
}

int run_blur(int c, char* src, char* dst){
  unsigned int cantidadDeMediciones = 1;
  unsigned long acumulador = 0;
  unsigned long diferencia;
  for (unsigned int i = 1; i <= cantidadDeMediciones; ++i)  {

    BMP* bmp = bmp_read(src);
    if(bmp==0) { return -1;}  // open error
    
    uint8_t* data = bmp_get_data(bmp);
    uint32_t h = *(bmp_get_h(bmp));
    uint32_t w = *(bmp_get_w(bmp));
    if(w%4!=0) { return -1;}  // do not support padding
    
    uint8_t* dataC = 0;
    if(*(bmp_get_bitcount(bmp)) == 24) {
      dataC = malloc(sizeof(uint8_t)*4*h*w);
      to32(w,h,data,dataC);
    } else {
      dataC = data;
    }

    unsigned long start;
    unsigned long end;
    RDTSC_START(start);
    if(c==0)         C_blur(w,h,dataC);
    else if(c==1) ASM_blur1(w,h,dataC);
    else if(c==2) ASM_blur2(w,h,dataC);
    else {return -1;}
    RDTSC_STOP(end);
    diferencia = end - start;
    acumulador += diferencia;
    
    if(*(bmp_get_bitcount(bmp)) == 24) {
      to24(w,h,dataC,data);
      free(dataC);
    }
    bmp_save(dst,bmp);
    bmp_delete(bmp);

    printPartial("blur", i, cantidadDeMediciones, diferencia);
  }

  printAverage(acumulador, cantidadDeMediciones);
  return 0;
}

int run_merge(int c, char* src1, char* src2, char* dst, float value){
  unsigned int cantidadDeMediciones = 1;
  unsigned long acumulador = 0;
  unsigned long diferencia;
  for (unsigned int i = 1; i <= cantidadDeMediciones; ++i)  {

    if(dst==0) { return -1;}  // non destine
    if(value>1) value=1; else if(value<0) value=0;
    BMP* bmp1 = bmp_read(src1);
    BMP* bmp2 = bmp_read(src2);
    if(bmp1==0 || bmp2==0) { return -1;}  // open error
    
    uint8_t* data1 = bmp_get_data(bmp1);
    uint8_t* data2 = bmp_get_data(bmp2);
    uint32_t h1 = *(bmp_get_h(bmp1));
    uint32_t w1 = *(bmp_get_w(bmp1));
    uint32_t h2 = *(bmp_get_h(bmp2));
    uint32_t w2 = *(bmp_get_w(bmp2));
    if(w1%4!=0 || w2%4!=0) { return -1;}  // do not support padding
    if( w1!=w2 || h1!=h2 ) { return -1;}  // different image size
    
    uint8_t* data1C = 0;
    uint8_t* data2C = 0;
    if(*(bmp_get_bitcount(bmp1)) == 24) {
      data1C = malloc(sizeof(uint8_t)*4*h1*w1);
      data2C = malloc(sizeof(uint8_t)*4*h2*w2);
      to32(w1,h1,data1,data1C);
      to32(w2,h2,data2,data2C);
    } else {
      data1C = data1;
      data2C = data2;
    }
    
    unsigned long start;
    unsigned long end;
    RDTSC_START(start);
    if(c==0)         C_merge(w1,h1,data1C,data2C,value);
    else if(c==1) ASM_merge1(w1,h1,data1C,data2C,value);
    else if(c==2) ASM_merge2(w1,h1,data1C,data2C,value);
    else {return -1;}
    RDTSC_STOP(end);
    diferencia = end - start;
    acumulador += diferencia;

    if(*(bmp_get_bitcount(bmp1)) == 24) {
      to24(w1,h1,data1C,data1);
      free(data1C);
      free(data2C);
    }
    bmp_save(dst,bmp1);
    bmp_delete(bmp1);
    bmp_delete(bmp2);

    printPartial("merge", i, cantidadDeMediciones, diferencia);
  }

  printAverage(acumulador, cantidadDeMediciones);
  return 0;
}

int run_hsl(int c, char* src, char* dst, float hh, float ss, float ll) {
  unsigned int cantidadDeMediciones = 1;
  unsigned long acumulador = 0;
  unsigned long diferencia;
  for (unsigned int i = 1; i <= cantidadDeMediciones; ++i){
   
    BMP* bmp = bmp_read(src);
    if(bmp==0) { return -1;}  // open error
    if(ss>1) ss=1; else if(ss<-1) ss=-1;
    if(ll>1) ll=1; else if(ll<-1) ll=-1;
    uint8_t* data = bmp_get_data(bmp);
    uint32_t h = *(bmp_get_h(bmp));
    uint32_t w = *(bmp_get_w(bmp));
    if(w%4!=0) { return -1;}  // do not support padding
    
    uint8_t* dataC = 0;
    if(*(bmp_get_bitcount(bmp)) == 24) {
      dataC = malloc(sizeof(uint8_t)*4*h*w);
      to32(w,h,data,dataC);
    } else {
      dataC = data;
    }
    
    unsigned long start;
    unsigned long end;
    RDTSC_START(start);
    if(c==0)         C_hsl(w,h,dataC,hh,ss,ll);
    else if(c==1) ASM_hsl1(w,h,dataC,hh,ss,ll);
    else if(c==2) ASM_hsl2(w,h,dataC,hh,ss,ll);
    else {return -1;}
    RDTSC_STOP(end);
    diferencia = end - start;
    acumulador += diferencia;
    
    
    if(*(bmp_get_bitcount(bmp)) == 24) {
      to24(w,h,dataC,data);
      free(dataC);
    }
    bmp_save(dst,bmp);
    bmp_delete(bmp);

    printPartial("hsl", i, cantidadDeMediciones, diferencia);
  }

  printAverage(acumulador, cantidadDeMediciones);
  return 0;
}

