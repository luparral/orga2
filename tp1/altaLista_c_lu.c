#include "altaLista.h"

//Funciones de nodo
nodo *nodoCrear( void *dato ){
  nodo* nuevoNodo = (nodo*) malloc(sizeof(nodo));
  nuevoNodo->dato = dato;
  nuevoNodo->anterior = NULL;
  nuevoNodo->siguiente = NULL;
  return nuevoNodo;
}

void nodoBorrar( nodo *n, tipoFuncionBorrarDato f ){
  n->anterior = NULL;
  n->siguiente = NULL;
  f(n->dato);
  free(n);
}

//Funciones de alta lista
altaLista *altaListaCrear( void ){
  altaLista* nuevaLista = (altaLista*) malloc(sizeof(altaLista));
  nuevaLista-> primero = NULL;
  nuevaLista-> ultimo = NULL;
  return nuevaLista;
}

void altaListaBorrar( altaLista *l, tipoFuncionBorrarDato f ){
  if(l->primero != NULL){ //hay un elemento
    nodo* nodoActual = l->primero; //1er Nodo
    nodo* nodoSiguiente = l->primero->siguiente; //2do Nodo
    nodo* nodoABorrar = nodoActual;    
    while(nodoSiguiente != NULL){//hay mas que uno, no va a entrar cuando quede un unico nodo por borrar
      nodoActual = nodoSiguiente;
      nodoSiguiente = nodoSiguiente->siguiente;//3er nodo
      nodoBorrar(nodoABorrar,f);
      nodoABorrar = nodoActual;
    }
    nodoBorrar(nodoActual,f);
  }

  l->primero = NULL;
  l->ultimo = NULL;
  /*
  Tengo una lista con dos
  1, 2
  actual 1
  siguiente 2
  borrar 1
  siguiente es nul? no
  actual 2
  siguiente nul
  borrar 2
  sigiente es nul? si
  borrar actual
  


  */


//ToDo: Chequear
void altaListaImprimir( altaLista *l, char *archivo, tipoFuncionImprimirDato f ){
  FILE* file;
  file = fopen(archivo, "a");
  nodo* nodoActual = l->primero;
  if(nodoActual == NULL){//hay 0 nodos
    char* vacio= "<vacio>";
    fprintf(file, "%s\n", vacio);
  } else if(nodoActual->siguiente == NULL){//hay 1 nodo
    f(((estudiante*)nodoActual->dato), file); //imprimo unico nodo
  } else{
    nodo* nodoSiguiente = nodoActual->siguiente;
    while(nodoSiguiente!=NULL){
      f(((estudiante*)nodoActual->dato), file); //imprimo nodo actual
      nodoActual = nodoSiguiente;
      nodoSiguiente = nodoSiguiente->siguiente;
    }
    f(((estudiante*)nodoActual->dato), file);//imprimo ultimo nodo
  }

  fclose(file);
}

// //Funciones de estudiante

estudiante *estudianteCrear(char *nombre, char *grupo, unsigned int edad){
  estudiante* nuevoEstudiante = (estudiante*) malloc(sizeof(estudiante));
  nuevoEstudiante->nombre = nombre;
  nuevoEstudiante->grupo = grupo;
  nuevoEstudiante->edad = edad;
  return nuevoEstudiante;
}
void estudianteBorrar(estudiante *e){
  e->nombre = NULL;
  e->grupo = NULL;
  e->edad = NULL;
  free(e);
}

void estudianteImprimir( estudiante *e, FILE *file ){
  file = (fopen("/home/lu/OrgaII/orga2/tp1/salida.txt", "a"));
  fprintf(file, "%s \n \t %s \n \t %d \n", e->nombre, e->grupo, e->edad);
  fclose(file);

}

bool menorEstudiante( estudiante *e1, estudiante *e2 ){
  if(string_menor(e1->nombre, e2->nombre)){
    return true;
  }else if(string_iguales(e1->nombre, e2->nombre)){
    if(e1->edad <= e2->edad){
      return true;
    }else{
      return false;
    }
  }else{
    return false;
  }
}

/** Funciones Auxiliares ya implementadas en C **/
//dadas por la catedra

bool string_iguales( char *s1, char *s2 ){
   int i = 0;
   while( s1[i] == s2[i] ){
      if( s1[i] == 0 || s2[i] == 0 )
         break;
      i++;
   }
   if( s1[i] == 0 && s2[i] == 0 )
      return true;
   else
      return false;
}

void insertarAtras( altaLista *l, void *dato ){
	nodo *nuevoNodo = nodoCrear(dato);
  nodo *ultimoNodo = l->ultimo;
  if( ultimoNodo == NULL )
      l->primero = nuevoNodo;
  else
      ultimoNodo->siguiente = nuevoNodo;
  nuevoNodo->anterior = l->ultimo;
  l->ultimo = nuevoNodo;
}

bool string_menor(char *s1, char *s2){ //s1 < s2
  //merced < mercurio, perro < zorro, senior < seniora
  //andres < totoro
  if(string_iguales(s1, s2)){
    return false;
  }else{
    int i = 0;
    bool res = false;
    while(s1[i]!=0){
      if(s2[i]==0){
        return res;
      }else if(s1[i]>s2[i]){
        res = false;
        break;
      }else if(s1[i]<s2[i]){
        res = true;
        break;
      }
      res = true;
      i++;
    }
    return res;  
  }
}

unsigned char string_longitud (char* string){
  int res = 0;
  int i = 0;
  while(string[i] != 0){
  res++;
  i++;
  }
  return res;
}


//Funciones avanzadas
float edadMedia(altaLista *l){
  float cantidadEstudiantes = (float)cantidadDeNodos(l);
  float sumaDeEdades = (float)sumaEdades(l);
  float res = sumaDeEdades/cantidadEstudiantes;
  return res;
}

/////////////////////////////////////////
int cantidadDeNodos (altaLista* l){
  int cantidadEstudiantes = 0;
  if(l->primero != NULL){ //hay un elemento
    nodo* nodoActual = l->primero; 
    while(nodoActual != NULL){
      cantidadEstudiantes++;
      nodoActual = nodoActual->siguiente;
    }
  }
  return cantidadEstudiantes;
}

int sumaEdades (altaLista* l){
  int suma = 0;
  if(l->primero != NULL){
    nodo* nodoActual = l->primero;
    while(nodoActual != NULL){
      suma += ((estudiante*)nodoActual->dato)->edad;
      nodoActual = nodoActual->siguiente;
    }
  }
  return suma;
}

void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f ){
  printf("Va a insertar a: %s de: %d \n", ((estudiante*)dato)->nombre, ((estudiante*)dato)->edad);
  if(cantidadDeNodos(l)==0){
    //char* test2 = "Inserta al primero de la lista";
    //printf("%s\n\n", test2);
    insertarAtras(l, dato);
  }else if(f(dato, (estudiante*)l->primero->dato)){ //es menor que el primero
    //printf("Primero de la lista %s\n", ((estudiante*)l->primero->dato)->nombre);
    //printf("menor que el primero %s de %d \n\n", ((estudiante*)l->primero->dato)->nombre, ((estudiante*)l->primero->dato)->edad);
    insertarNodoAdelanteDeNodo(l, dato, l->primero);
  }else if(f((estudiante*)l->ultimo->dato, dato)){ //es mayor que el ultimo
    //printf("Primero de la lista %s\n", ((estudiante*)l->primero->dato)->nombre);
    //printf("mayor que el ultimo %s de %d \n\n", ((estudiante*)l->ultimo->dato)->nombre, ((estudiante*)l->ultimo->dato)->edad);
    insertarNodoDetrasDeNodo(l, dato, l->ultimo);
  }else{
    nodo* nodoActual = l->primero;
    while(f((estudiante*)nodoActual->dato, dato)){
      nodoActual = nodoActual->siguiente;
    }
    //printf("Primero de la lista %s\n", ((estudiante*)l->primero->dato)->nombre);
    //printf("insertar adelante de %s de %d \n\n", ((estudiante*)nodoActual->dato)->nombre, ((estudiante*)nodoActual->dato)->edad);
    insertarNodoAdelanteDeNodo(l, dato, nodoActual);
  }
}


void insertarNodoDetrasDeNodo(altaLista *l, void* dato, nodo* nodoActual){
  nodo *nuevoNodo = nodoCrear(dato);
  if(nodoActual->siguiente == NULL){
    l->ultimo = nuevoNodo;
  }
  nuevoNodo->anterior = nodoActual;
  nuevoNodo->siguiente = nodoActual->siguiente;
  nodoActual->siguiente = nuevoNodo;
  nodoActual-> siguiente -> anterior = nuevoNodo;
}

void insertarNodoAdelanteDeNodo(altaLista* l, void* dato, nodo* nodoActual){
  // nodo* nuevoNodo = nodoCrear(dato);
  // if(nodoActual->anterior == NULL){
  //   printf("hola\n");
  //   l->primero = nuevoNodo;
  // }
  // if(cantidadDeNodos(l)>2){
  //   printf("hey\n");
  //   printf("Nodo actual anterior: %s de edad: %d \n", ((estudiante*)nodoActual->anterior->dato)->nombre,  ((estudiante*)nodoActual->anterior->dato)->edad);    
  // }
  // nuevoNodo->anterior = nodoActual->anterior;
  // nuevoNodo->siguiente = nodoActual;
  // nodoActual->anterior->siguiente = nuevoNodo;
  // nodoActual->anterior = nuevoNodo;
  //printf("-----Insertar adelante nodo actual: %s de edad: %d \n", ((estudiante*)nodoActual->dato)->nombre, ((estudiante*)nodoActual->dato)->edad);
  //printf("-----Insertar adelante nodo nuevo: %s de edad: %d \n\n", ((estudiante*)nuevoNodo->dato)->nombre, ((estudiante*)nuevoNodo->dato)->edad);

}
