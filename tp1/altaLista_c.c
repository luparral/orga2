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
  free(l);
}


//ToDo: Chequear
void altaListaImprimir( altaLista *l, char *archivo, tipoFuncionImprimirDato f ){
  FILE* file;
  file = fopen(archivo, "w");
  printf("a");
  if(l->primero!=NULL){
    f(l->primero->dato, file);
    nodo* nodoSiguiente = l->primero->siguiente; //2do Nodo
    while(nodoSiguiente!= NULL){
      nodo* nodoActual = nodoSiguiente;
      nodo* nodoSiguiente = nodoActual->siguiente;
      f(nodoActual->dato, file);
    }

  }

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
  file = (fopen("/home/lucy/OrgaII/tp1/salida.txt", "w"));
  fprintf(file, "%s \n \t %s \n \t %d \n", e->nombre, e->grupo, e->edad);
  fclose(file);

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
	nodo *nuevoNodo = nodoCrear( dato );
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
  int i = 0;
  while(s1[i] != 0 || s2[i] != 0){ //se termino alguno de los strings
    if(s1[i]>s2[i])
      break;
     i++;
  }
     if( s1[i] == 0)
      return true;
   else
      return false;
}