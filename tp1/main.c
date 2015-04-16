#include "altaLista.h"
#include <stdio.h>

extern estudiante* estudianteCrear(char*, char*, int);
extern void estudianteBorrar(estudiante*);
extern nodo* nodoCrear(void*);
extern void nodoBorrar(nodo*, tipoFuncionBorrarDato);
extern unsigned char string_longitud(char*);
extern int sumaEdades (altaLista*);
extern int cantidadDeNodos (altaLista*);
extern void altaListaBorrar(altaLista*, tipoFuncionBorrarDato);
extern altaLista* altaListaCrear (void);
extern float edadMedia(altaLista*);
extern void estudianteConFormato(estudiante*, tipoFuncionModificarString);
extern char* string_copiar(char*);
extern void altaListaImprimir(altaLista*, char*, tipoFuncionImprimirDato);
extern void insertarOrdenado(altaLista*, void*, tipoFuncionCompararDato);

 
int main (){
	
	// // char* test = "hola";

	// // printf("%s \n",test);

	// estudiante* e1 = estudianteCrear("Pepe", "Grupo", 42);
	// estudiante* e2 = estudianteCrear("Zorro", "OtroGrupo", 10);
	// bool menor1 = menorEstudiante(e1, e2);//true
	// bool menor2 = menorEstudiante(e2, e1);//false
	// estudiante* e3 = estudianteCrear("Pepe", "OtroGrupoDistinto", 10);
	// estudiante* e4 = estudianteCrear("Ana", "algo", 140);
	// estudiante* e5 = estudianteCrear("Ana", "algo", 1);
	// estudiante* e6 = estudianteCrear("Zzz", "algo", 1);
	// estudiante* e7 = estudianteCrear("Ana", "algo", 1);
	// // bool menor3 = menorEstudiante(e3, e1);//true
	// // bool menor4 = menorEstudiante(e4, e3);//true
	// printf("------------Tests de estudianteMenor \n");
	// printf("e1 < e2: %d\n", menor1);
	// printf("e2 < e1: %d\n", menor2);
	// // printf("e3 < e1: %d\n", menor3);
	// // printf("e4 < e3: %d\n", menor4); //true
	

	// //printf("------------Tests de alta lista crear \n");
	// altaLista* nuevaLista = altaListaCrear();
	// //insertarAtras(nuevaLista, e1);
	// insertarOrdenado(nuevaLista, e1, menorEstudiante);
	// insertarOrdenado(nuevaLista, e2, menorEstudiante);
	// //insertarOrdenado(nuevaLista, e1, algunaFuncionBool);
	// //insertarOrdenado(nuevaLista, e2, algunaFuncionBool);
	// insertarOrdenado(nuevaLista, e3, (tipoFuncionCompararDato)menorEstudiante);
	// insertarOrdenado(nuevaLista, e4, (tipoFuncionCompararDato)menorEstudiante);
	// insertarOrdenado(nuevaLista, e5, (tipoFuncionCompararDato)menorEstudiante);
	// insertarOrdenado(nuevaLista, e6, (tipoFuncionCompararDato)menorEstudiante);
	// insertarOrdenado(nuevaLista, e7, (tipoFuncionCompararDato)menorEstudiante);
	// //altaListaBorrar(nuevaLista, (tipoFuncionBorrarDato)estudianteBorrar);
	// //insertarAtras(nuevaLista, e2);
	// //insertarAtras(nuevaLista, e3);



	// // printf("------------Tests de edad media \n");
	// // int suma = sumaEdades(nuevaLista);
	// // printf("Suma de edades: %d\n", suma);
	
	// // int cant = cantidadDeNodos(nuevaLista);
	// // printf("Cantidad de nodods: %d\n", cant);

	// // float prom = edadMedia(nuevaLista);
	// // printf("Edad Media: %f \n", prom);

	// // FILE *file = fopen("testEstudianteImprimir.txt","a");
	// // // // estudianteImprimir(e1,file);

	// // // // estudianteConFormato(e1, (tipoFuncionModificarString)hola);
	// // estudianteImprimir(e1,file);


	// // printf("------------Tests para imprimir alta lista \n");
	// // printf("Dir lista: %d \n", nuevaLista);
	// // printf("Dir primer nodo: %d \n", (nodo*)nuevaLista->primero);
	// // //printf("Dir estudiante: %d \n", ((estudiante*)nuevaLista->primero->dato));

	// altaListaImprimir(nuevaLista, "testImprimirLista.txt", (tipoFuncionImprimirDato)estudianteImprimir);
	// // printf("%s %s %d\n", e1->nombre, e1->grupo, e1->edad);
	// // estudianteBorrar(e1);
	// // estudianteBorrar(e2);
	// // estudianteBorrar(e3);
	
	// // // nodo* nuevoNodo = nodoCrear(e1);
	// // // printf("%s %s %d \n", ((estudiante*)nuevoNodo->dato)->nombre, ((estudiante*)nuevoNodo->dato)->grupo, ((estudiante*)nuevoNodo->dato)->edad);
	// // // nodoBorrar(nuevoNodo, (tipoFuncionBorrarDato)estudianteBorrar);
	// // // unsigned char test = string_longitud("Lucia");
	// // // printf("%u\n", test);


	// // printf("------------Tests de string_menor \n");
	// // //test1
	// // char* char1 = "a";
	// // char* char2 = "z";
	// // //test2
	// // char* merced = "merced";
	// // char* mercurio = "mercurio";
	// // //test3
	// // char* perro = "perro";
	// // char* zorro = "zorro";
	// // //test4
	// // char* senior = "senior";
	// // char* seniora = "seniora";
	// // //test5
	// // char* caZa = "caZa";
	// // char* casa = "casa";
	// // //test6
	// // char* hola1 = "hola";
	// // char* hola2 = "hola"; 

	// //test7
	// // char* ana = "Ana";
	// // char* pepe = "Pepe"; 



	// // bool res1 = string_menor(char1,char2);
	// // printf("a es menor que z: %d \n",res1);

	// // bool res2 = string_menor(mercurio,merced);
	// // printf("mercurio es menor a merced: %d \n",res2);

	// // bool res3 = string_menor(perro,zorro);
	// // printf("perro es menor que zorro: %d \n",res3);

	// // bool res4 = string_menor(senior,seniora);
	// // printf("senior es menor que seniora: %d \n",res4);

	// // bool res5 = string_menor(caZa,casa);
	// // printf("caZa es menor que casa: %d \n",res5);

	// // bool res6 = string_menor(hola1,hola2);
	// // printf("hola es menor que hola: %d \n",res6);


	// // bool res7 = string_menor(ana,pepe);
	// // printf("Ana es menor que Pepe: %d \n",res7);
	

//insertarOrdenado
	 	altaLista *listaParafiltrar = altaListaCrear();
	 	// insertarOrdenado(listaParaInsertarOrdenado1, estudianteCrear("SanataNombre","SanataGrupo", 3), algunaFuncionBool);
	 	// insertarOrdenado(listaParaInsertarOrdenado1, estudianteCrear("SanataNombre","SanataGrupo", 25), algunaFuncionBool);
	 	// insertarOrdenado(listaParaInsertarOrdenado1, estudianteCrear("SanataNombre","SanataGrupo", 125), algunaFuncionBool);
	 	// insertarOrdenado(listaParaInsertarOrdenado1, estudianteCrear("SanataNombre","SanataGrupo", 255), algunaFuncionBool);
	 	// insertarOrdenado(listaParaInsertarOrdenado1, estudianteCrear("SanataNombre","SanataGrupo", 1), algunaFuncionBool);
	 	// insertarOrdenado(listaParaInsertarOrdenado1, estudianteCrear("SanataNombre","SanataGrupo", 2), algunaFuncionBool);
	 	
	 	// altaListaImprimir(listaParaInsertarOrdenado1, "LUCIA.txt", estudianteImprimir);

	 	// altaListaBorrar(listaParaInsertarOrdenado1, estudianteBorrar);
	 	





	 	estudiante* e6 = estudianteCrear("Pepe", "algo", 10);
		estudiante* e7 = estudianteCrear("Rafael", "algo", 10);
		estudiante* e8 = estudianteCrear("Zorro", "algo", 10);
		// estudiante* e9 = estudianteCrear("R", "algo", 10);
		estudiante* e10 = estudianteCrear("A", "algo", 10);
		// bool menor1 = menorEstudiante(e9, e6);//true
		// bool menor2 = menorEstudiante(e9, e7);//true
		// bool menor3 = menorEstudiante(e9, e8);//true
		// printf("------------Tests de estudianteMenor \n");
		// printf("R < Pepe: %d\n", menor1);
		// printf("R < Rafael: %d\n", menor2);
		// printf("R < Zorro: %d\n", menor3);

	 	insertarOrdenado(listaParafiltrar, e6, menorEstudiante);
	 	insertarOrdenado(listaParafiltrar, e7, menorEstudiante);
	 	//insertarOrdenado(listaParafiltrar, e8, menorEstudiante);
	 	altaListaImprimir(listaParafiltrar, "LUCIA.txt", estudianteImprimir);
	 	filtrarAltaLista(listaParafiltrar, menorEstudiante, e7);
	 	altaListaImprimir(listaParafiltrar, "filtrado.txt", estudianteImprimir);



	return 0;
}
