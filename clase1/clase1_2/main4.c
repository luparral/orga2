#include <stdio.h>

// Declaro la aridad de la funcion de ASM
extern int operacion(int a0, int a1, int a2, int a3, int a4, int a5, int a6, int a7);

int main(){
	
	int res;
	res = operacion(10,1,1,1,1,1,1) //res = 10;
	return 0;
}
