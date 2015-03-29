#include <stdio.h>

// Declaro la aridad de la funcion de ASM
extern void imprime_parametros(int a, double f, char* s);

int main(){
	
	printf('%d, %5.2f, %c', imprime_parametros(a,f,s));
	
	return 0;
}
