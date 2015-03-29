#include "altaLista.h"
#include <stdio.h>

int main (void){
	char* nombre1 = "Pepe";
	char* grupo1 = "Pepitos";
	int edad1 = 20;
	estudiante* estudiante1 = estudianteCrear(nombre1, grupo1, edad1);

	char* nombre2 = "Eddie";
	char* grupo2 = "Gatitos";
	int edad2 = 2;
	estudiante* estudiante2 = estudianteCrear(nombre2, grupo2, edad2);

	char* nombre3 = "Totoro";
	char* grupo3 = "Gatitos";
	int edad3 = 3;
	estudiante* estudiante3 = estudianteCrear(nombre3, grupo3, edad3);

	estudianteImprimir(estudiante1, stdout);

	//nodo* nuevoNodo = nodoCrear(estudiante1);
	printf("%s \n", estudiante1->nombre);
	estudianteBorrar(estudiante1);
	printf("%s \n", estudiante1->nombre);

	altaLista* nuevaLista = altaListaCrear();
	insertarAtras(nuevaLista, estudiante1);
	insertarAtras(nuevaLista, estudiante2);
	insertarAtras(nuevaLista, estudiante3);

	altaListaImprimir(nuevaLista, "/home/lucy/OrgaII/tp1/salida.txt", (tipoFuncionImprimirDato)estudianteImprimir);

	// //test1
	// char* char1 = "a";
	// char* char2 = "z";
	// //test2
	// char* merced = "merced";
	// char* mercurio = "mercurio";
	// //test3
	// char* perro = "perro";
	// char* zorro = "zorro";
	// //test4
	// char* senior = "senior";
	// char* seniora = "seniora";
	// //test5
	// char* caZa = "caZa";
	// char* casa = "casa";
	// //test6
	// char* hola1 = "hola";
	// char* hola2 = "hola"; 

	// bool res1 = string_menor(char1,char2);
	// printf("a es menor que z: %d \n",res1);

	// bool res2 = string_menor(merced,mercurio);
	// printf("merced es menor a mercurio: %d \n",res2);

	// bool res3 = string_menor(perro,zorro);
	// printf("perro es menor que zorro: %d \n",res3);

	// bool res4 = string_menor(senior,seniora);
	// printf("senior es menor que seniora: %d \n",res4);

	// bool res5 = string_menor(caZa,casa);
	// printf("caZa es menor que casa: %d \n",res5);

	// bool res6 = string_menor(hola1,hola2);
	// printf("hola es menor que hola: %d \n",res6);



	return 0;
}
