#include "altaLista.h"




/** Funciones Auxiliares ya implementadas en C **/

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

void hola( char *s ){ 
  if(s[0] != 0) 
    s[0] = "b"; 
}

bool algunaFuncionBool(estudiante* v1, estudiante*v2){

  return(v1->edad < v2->edad);
}





// void filtrarAltaLista (altaLista* l, tipoFuncionCompararDato f, void *datoComp){
// //dato actual > dato comp HAY QUE BORRARLOS
//   nodo* nodoActual = l->primero;
//   if(l->primero == NULL){
//     return;
//   }
//   void* datoActual = nodoActual->dato;
//   if(l->primero == l->ultimo){ //LISTA DE UN SOLO NODO
//     nodoBorrar(nodoActual, (tipoFuncionBorrarDato)estudianteBorrar);
//     l->primero = NULL;
//     l->ultimo = NULL;
//     return;
//   }
// //  printf("datoComp %s\n", ((estudiante*)datoComp)->nombre);
//   while(nodoActual != NULL){
//     //printf("Entre al while\n");
//     if(f(datoComp, datoActual)) {
//       if(l->primero == l->ultimo){ //LISTA DE UN SOLO NODO
//         nodoBorrar(nodoActual, (tipoFuncionBorrarDato)estudianteBorrar);
//         l->primero = NULL;
//         l->ultimo = NULL;
//         return;
//       }
//       if(nodoActual == l->primero){
//         l->primero = l->primero->siguiente;
//         nodoActual->siguiente->anterior = NULL;
//       } else if(nodoActual == l->ultimo){
//         l->ultimo = l->ultimo->anterior;
//         nodoActual->anterior->siguiente = NULL;
//         nodoBorrar(nodoActual, (tipoFuncionBorrarDato)estudianteBorrar);
//         return;
//       }else{
//         nodoActual->anterior->siguiente = nodoActual->siguiente;
//         nodoActual->siguiente->anterior = nodoActual->anterior;      
//       }
//         nodo* nodoABorrar = nodoActual;
//         nodoActual = nodoActual->siguiente;
//         datoActual = nodoActual->dato;
//         nodoBorrar(nodoABorrar, (tipoFuncionBorrarDato)estudianteBorrar);   

//     }else{
//       nodoActual = nodoActual->siguiente;
//       datoActual = nodoActual->dato;
//     };
//   }
// }











// void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f ){
//   printf("Voy a insertar a %s\n", ((estudiante*)dato)->nombre);
//   nodo* nodoActual = l->primero;
//   if(nodoActual == NULL){
//     insertarAtras(l, dato);
//   }else{
    
//     nodo* nuevoNodo = nodoCrear(dato);
    

//     while(nodoActual!= NULL){
//       if(f(dato, (nodoActual->dato))){
//         if(nodoActual == l->primero){
//           l->primero = nuevoNodo;
//           nuevoNodo->siguiente = nodoActual;
//           nuevoNodo->anterior = NULL;
//           nodoActual->anterior = nuevoNodo;
//           break;
       
//         }else{
//           nuevoNodo->siguiente = nodoActual;
//           nuevoNodo->anterior = nodoActual->anterior;
//           nodoActual->anterior->siguiente = nuevoNodo;
//           nodoActual->anterior = nuevoNodo;
//           break;  
//         } 
//       }else{
//         nodoActual = nodoActual->siguiente;
//       } 
//     }
//     if(f(l->ultimo->dato, dato)){
//       nodoActual = l->ultimo;
//       nuevoNodo->siguiente = NULL;
//       nuevoNodo->anterior = nodoActual;
//       nodoActual->siguiente = nuevoNodo;
//       l->ultimo = nuevoNodo;    
//     }
//   }
// }