#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct Tabla {
     struct Tabla * sig;
     char nombre [20];
     int tipo; /*Tipo 0 -> NO DECLARADO ; Tipo 1 -> ENTERO ; Tipo 2 -> Cadena */
     int valorint;
     char valorcad[100];
};

//Inicializar la estructura de datos de la tabla de símbolos
struct Tabla * inicializar ()
{
     return NULL;
};

//Busca un registro en la tabla de símbolos
struct Tabla * buscar(struct Tabla *t,char *nombre)
{
     while ( (t != NULL) && (strcmp(nombre, t->nombre)) )
          t = t->sig;
     return (t);
};

//Inserta un nuevo nodo a la tabla de símbolos | t guarda direcciones de memoria
void insertar(struct Tabla **t,struct Tabla *s)
{
     s->sig = *t;
     *t = s;
};

//Imprime la tabla de símbolos
void imprimir(struct Tabla *t)
{
     printf("\n\nTABLA DE SIMBOLOS\n\n");
     while (t != NULL)
     {
          if(t->tipo == 1)
          {
                    printf("NOMBRE: %s , VALOR: %d , TIPO: INT\n", t->nombre,t->valorint);
          }
          else if(t->tipo == 2)
          {
                    printf("NOMBRE: %s , VALOR: %s , TIPO: STRING\n", t->nombre,t->valorcad);
          }
          t = t->sig;
     }
     printf("\n\n");
};
