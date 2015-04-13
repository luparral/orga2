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

	char* nombre4 = "Totoro";
	char* grupo4 = "Gatitos";
	int edad4 = 2;
	estudiante* estudiante4 = estudianteCrear(nombre4, grupo4, edad4);

	// bool menor1 = menorEstudiante(estudiante2, estudiante3);//true
	// bool menor2 = menorEstudiante(estudiante1, estudiante2);//false
	// bool menor3 = menorEstudiante(estudiante4, estudiante3);//true
	// printf("Eddie es menor que Totoro: %d\n", menor1);
	// printf("Pepe es menor que Eddie: %d\n", menor2);
	// printf("Totoro de 2 es menor que Totoro de 3: %d\n", menor3);


	altaLista* nuevaLista = altaListaCrear();
	// insertarAtras(nuevaLista, estudiante1);
	// insertarAtras(nuevaLista, estudiante2);
	// insertarAtras(nuevaLista, estudiante3);
	//altaListaImprimir(nuevaLista, "/home/lu/OrgaII/orga2/tp1/salida.txt", (tipoFuncionImprimirDato)estudianteImprimir);

	// printf("Tests de string_menor \n");
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

	// bool res2 = string_menor(mercurio,merced);
	// printf("mercurio es menor a merced: %d \n",res2);

	// bool res3 = string_menor(perro,zorro);
	// printf("perro es menor que zorro: %d \n",res3);

	// bool res4 = string_menor(senior,seniora);
	// printf("senior es menor que seniora: %d \n",res4);

	// bool res5 = string_menor(caZa,casa);
	// printf("caZa es menor que casa: %d \n",res5);

	// bool res6 = string_menor(hola1,hola2);
	// printf("hola es menor que hola: %d \n",res6);

	// int cantidadNodos = cantidadDeNodos(nuevaLista);
	// printf("Cantidad de nodos: %d\n", cantidadNodos);

	// int sumaNodos = sumaEdades(nuevaLista);
	// printf("Suma de edades: %d\n", sumaNodos);

	// float edadPromedio = edadMedia(nuevaLista);
	// printf("%.3f \n", edadPromedio);
	

	char* nombre5 = "Andres";
	char* grupo5 = "Blabla";
	int edad5 = 50;

	estudiante* estudiante5 = estudianteCrear(nombre5, grupo5, edad5);

	// insertarOrdenado(nuevaLista, estudiante1, (tipoFuncionCompararDato)menorEstudiante);
	// insertarOrdenado(nuevaLista, estudiante2, (tipoFuncionCompararDato)menorEstudiante);	
	// bool menor4 = menorEstudiante(estudiante5, estudiante3);//true
	// printf("test: %d\n", menor4);
	// bool res7 = string_menor("andres","totoro");
	// 	printf("Test nombres %d \n",res7);
	// bool res8 = string_menor("Andres","Totoro");
	// printf("Test nombres con may %d \n",res8);

	// insertarOrdenado(nuevaLista, estudiante3, (tipoFuncionCompararDato)menorEstudiante); //totoro 3
	// insertarOrdenado(nuevaLista, estudiante5, (tipoFuncionCompararDato)menorEstudiante); //andres
	// insertarOrdenado(nuevaLista, estudiante4, (tipoFuncionCompararDato)menorEstudiante); //totoro 2
	// insertarOrdenado(nuevaLista, estudiante2, (tipoFuncionCompararDato)menorEstudiante);//Eddieie

	// altaListaImprimir(nuevaLista, "/home/lu/OrgaII/orga2/tp1/salida.txt", (tipoFuncionImprimirDato)estudianteImprimir);

	return 0;
}
