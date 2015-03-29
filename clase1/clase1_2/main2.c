#include <stdio.h>

// Declaro la aridad de la funcion de ASM
extern double suma2Doubles(double a, double b);

int main(){
	
	double suma;
	suma = suma2Doubles(2,41);
	
	printf("\nLa suma es %5.2f\n\n",suma);
	
	return 0;
}
