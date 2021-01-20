%{
     #include "TablaDeSimbolos.c"
     struct Tabla *t;
%}

/* Declaraciones de BISON */
%union{
    int entero;
    char *caracter;
    struct Tabla *apuntador_s;
    int comp;
    char *salida;
}

/*Tokens de inicialización*/
%token INT
%token STRING

/*Tokens para enteros*/
%token <entero> ENTERO
%type <entero> exp
%token MODULO

/*Tokens para obtener valores de la tabla*/
%token <apuntador_s> ID1
%token <apuntador_s> ID2

/*Tokens para cadenas*/
%token <caracter> CADENA
%type <caracter> cad

/*Token para comparaciones*/
%token SI
%token IGUAL
%token DIFERENTE
%type <comp> compara
%type <comp> explog
%type <comp> condicion

/*Tokens de salida estandar*/
%token IMPRIMIR
%token IMPRIME
%type <salida> impr
%type <salida> conj
%type <salida> xp

%left '+'
%left '-'
%left '*'
%left '/'
%left ','


/* Gramática */
%%

input:    /* cadena vacía */
        | input line
;

line:     '\n'
        | inivar '\n' {printf("\n\t Inicializar variable\n\n");}
        | IMPRIMIR '\n'{imprimir(t);}
        |reasigna '\n'{printf("\n\tReasignar valor a variable\n\n");}
        |condicion '\n'{
                            printf("\n\tCondicional: ");
                            if($1 == 1)
                                printf("VERDADERO\n\n");
                            else
                                printf("FALSO\n\n");
                        }
         | impr '\n' {printf("\t\nSTDOUT: %s\n\n",$1);}
;

exp:     ENTERO	{ $$ = $1; }
	| exp '+' exp        { $$ = $1 + $3;    }
	| exp '*' exp        { $$ = $1 * $3;	}
    | exp '/' exp        { $$ = $1 / $3;	}
    | exp '-' exp        { $$ = $1 - $3;	}
    | MODULO '(' exp ',' exp ')' { $$ = (int)$3 % (int)$5; }

;

cad:  CADENA { $$ = $1;}
    | cad '+' cad     { $$ = strcat($1,$3); }
;

inivar: INT ID1 '=' exp {
                              printf("\tINT %s = %d\n",$2->nombre,$4);
                              $2->valorint = $4;
                              $2->tipo = 1;
                           }
     | INT ID2 '=' exp {
                         printf("\tError, la variable %s ya ha sido declarada\n",$2->nombre);
     }
     | INT ID2 '=' cad {
                         printf("\tError, la variable %s ya ha sido declarada\n",$2->nombre);
     }
     | INT ID1 {
                    printf("\tINT %s = %d\n",$2->nombre,$2->valorint);
                    $2->tipo = 1;
     }
     | INT ID2 {
                         printf("\tError, la variable %s ya ha sido declarada\n",$2->nombre);
     }

     | STRING ID1 '=' cad {
                              printf("\tSTRING %s = %s\n",$2->nombre,$4);
                              strcpy($2->valorcad,$4);
                              $2->tipo = 2;
                           }
     | STRING ID2 '=' cad {
                         printf("\tError, la variable %s ya ha sido declarada\n",$2->nombre);
     }
     | STRING ID1 {
                    printf("\tSTRING %s = %s\n",$2->nombre,$2->valorcad);
                    $2->tipo = 2;
     }
     | STRING ID2 {
                         printf("\tError, la variable %s ya ha sido declarada\n",$2->nombre);
     }

     | STRING ID1 '=' exp {
                         printf("\tError de asignación, los tipos de datos no coinciden\n\n");
                         strcpy($2->nombre,"");
     }
     | INT ID1 '=' cad {
                         printf("\tError de asignación, los tipos de datos no coinciden\n\n");
                         strcpy($2->nombre,"");
     }
;

reasigna: ID2 '=' exp {
                         if($1->tipo == 1)
                         {
                              $1->valorint=$3;
                              printf("\t%s = %d\n",$1->nombre,$3);
                         }
                         else if ($1->tipo == 2)
                              printf("\tError, los tipos de datos no son compatibles\n\n");
                    }
     | ID1 '=' exp {
                         printf("\tError, la variable %s no se encuentra declarada\n\n",$1->nombre);
                         strcpy($1->nombre,"");
                    }
     | ID2 '=' cad {
                    if($1->tipo == 2)
                    {
                         strcpy($1->valorcad,$3);
                         printf("\t%s = %s\n",$1->nombre,$3);
                    }
                    else if ($1->tipo == 1)
                         printf("\tError, los tipos de datos no son compatibles\n\n");
               }
     | ID1 '=' cad {
                    printf("\tError, la variable %s no se encuentra declarada\n\n",$1->nombre);
                    strcpy($1->nombre,"");
               }

;

compara: ID2 '<' ID2 {
                         if($1->tipo != 1 || $3->tipo != 1)
                        {
                            printf("\tError, los tipos de datos no son compatibles\n\n");
                            $$=0;
                        }
                         else if($1->valorint < $3->valorint)
                         {
                              $$ = 1;
                              printf("\tVERDADERO\n\n");
                         }
                         else
                         {
                              $$ = 0;
                              printf("\tFALSO\n\n");
                         }
    }
    | ID2 '>' ID2 {
                             if($1->tipo != 1 || $3->tipo != 1)
                             {
                                  printf("\tError, los tipos de datos no son compatibles\n\n");
                                  $$ = 0;
                             }
                             else if($1->valorint > $3->valorint)
                             {
                                  $$ = 1;
                                  printf("\tVERDADERO\n\n");
                             }
                             else
                             {
                                  $$ = 0;
                                  printf("\tFALSO\n\n");
                            }
     }
     | ID2 IGUAL ID2 {
                              if($1->tipo !=  $3->tipo)
                              {
                                    printf("\tError, los tipos de datos no son compatibles\n\n");
                                    $$=0;
                              }
                              else
                              {
                                  if($1->tipo == 1)
                                  {
                                       if($1->valorint == $3->valorint)
                                       {
                                            $$=1;
                                            printf("\tVERDADERO\n\n");
                                       }
                                       else
                                       {
                                            $$ = 0;
                                            printf("\tFALSO\n\n");
                                        }
                                  }
                                  else
                                  {
                                      if(!strcmp($1->valorcad,$3->valorcad))
                                      {
                                           $$=1;
                                           printf("\tVERDADERO\n\n");
                                      }
                                      else
                                      {
                                           $$ = 0;
                                           printf("\tFALSO\n\n");
                                       }
                                   }
                               }
     }
     | ID2 DIFERENTE ID2 {
                              if($1->tipo !=  $3->tipo)
                              {
                                    printf("\tError, los tipos de datos no son compatibles\n\n");
                                    $$ = 0;
                              }
                              else
                              {
                                  if($1->tipo == 1)
                                  {
                                       if($1->valorint != $3->valorint)
                                       {
                                            $$=1;
                                            printf("\tVERDADERO\n\n");
                                       }
                                       else
                                       {
                                            $$ = 0;
                                            printf("\tFALSO\n\n");
                                        }
                                  }
                                  else
                                  {
                                      if(strcmp($1->valorcad,$3->valorcad))
                                      {
                                           $$=1;
                                           printf("\tVERDADERO\n\n");
                                      }
                                      else
                                      {
                                           $$ = 0;
                                           printf("\tFALSO\n\n");
                                       }
                                   }
                               }
     }

     | exp '<' ID2 {
                              if($3->tipo != 1)
                             {
                                 printf("\tError, los tipos de datos no son compatibles\n\n");
                                 $$=0;
                             }
                              else if($1 < $3->valorint)
                              {
                                   $$ = 1;
                                   printf("\tVERDADERO\n\n");
                              }
                              else
                              {
                                   $$ = 0;
                                   printf("\tFALSO\n\n");
                              }
         }
         | exp '>' ID2 {
                                  if($3->tipo != 1)
                                  {
                                        printf("\tError, los tipos de datos no son compatibles\n\n");
                                        $$=0;
                                   }
                                  else if($1 > $3->valorint)
                                  {
                                       $$ = 1;
                                       printf("\tVERDADERO\n\n");
                                  }
                                  else
                                  {
                                       $$ = 0;
                                       printf("\tFALSO\n\n");
                                 }
          }
          | exp IGUAL ID2 {
                                   if($3->tipo != 1)
                                   {
                                         printf("\tError, los tipos de datos no son compatibles\n\n");
                                         $$=0;
                                   }
                                   else
                                   {

                                       if($1 == $3->valorint)
                                       {
                                            $$= 1;
                                            printf("\tVERDADERO\n\n");
                                       }
                                       else
                                       {
                                            $$ = 0;
                                            printf("\tFALSO\n\n");
                                        }

                                    }
          }
          | exp DIFERENTE ID2 {
                                   if( $3->tipo != 1)
                                   {
                                         printf("\tError, los tipos de datos no son compatibles\n\n");
                                         $$=0;
                                   }
                                   else
                                   {
                                       if($1 != $3->valorint)
                                       {
                                            $$=1;
                                            printf("\tVERDADERO\n\n");
                                       }
                                       else
                                       {
                                            $$ = 0;
                                            printf("\tFALSO\n\n");
                                        }
                                    }
          }


          | ID2 '<' exp {
                                   if($1->tipo != 1)
                                  {
                                      printf("\tError, los tipos de datos no son compatibles\n\n");
                                      $$=0;
                                  }
                                   else if($1->valorint < $3)
                                   {
                                        $$ = 1;
                                        printf("\tVERDADERO\n\n");
                                   }
                                   else
                                   {
                                        $$ = 0;
                                        printf("\tFALSO\n\n");
                                   }
              }
              | ID2 '>' exp {
                                       if($1->tipo != 1)
                                        {
                                             printf("\tError, los tipos de datos no son compatibles\n\n");
                                             $$=0;
                                        }
                                       else if($1->valorint > $3)
                                       {
                                            $$ = 1;
                                            printf("\tVERDADERO\n\n");
                                       }
                                       else
                                       {
                                            $$ = 0;
                                            printf("\tFALSO\n\n");
                                      }
               }
               | ID2 IGUAL exp {
                                        if($1->tipo != 1)
                                        {
                                              printf("\tError, los tipos de datos no son compatibles\n\n");
                                              $$=0;
                                        }
                                        else
                                        {

                                            if($1->valorint == $3)
                                            {
                                                 $$ = 1;
                                                 printf("\tVERDADERO\n\n");
                                            }
                                            else
                                            {
                                                 $$ = 0;
                                                 printf("\tFALSO\n\n");
                                             }

                                         }
               }
               | ID2 DIFERENTE exp {
                                        if( $1->tipo != 1)
                                        {
                                              printf("\tError, los tipos de datos no son compatibles\n\n");
                                              $$=0;
                                        }
                                        else
                                        {
                                            if($1->valorint != $3)
                                            {
                                                 $$=1;
                                                 printf("\tVERDADERO\n\n");
                                            }
                                            else
                                            {
                                                 $$ = 0;
                                                 printf("\tFALSO\n\n");
                                             }
                                         }
               }


               | exp '<' exp {
                                        if($1 < $3)
                                        {
                                             $$ = 1;
                                             printf("\tVERDADERO\n\n");
                                        }
                                        else
                                        {
                                             $$ = 0;
                                             printf("\tFALSO\n\n");
                                        }
                   }
                   | exp '>' exp {
                                           if($1 > $3)
                                            {
                                                 $$ = 1;
                                                 printf("\tVERDADERO\n\n");
                                            }
                                            else
                                            {
                                                 $$ = 0;
                                                 printf("\tFALSO\n\n");
                                           }
                    }
                    | exp IGUAL exp {
                                            if($1 == $3)
                                            {
                                                 $$ = 1;
                                                 printf("\tVERDADERO\n\n");
                                            }
                                            else
                                            {
                                                 $$ = 0;
                                                 printf("\tFALSO\n\n");
                                             }
                    }
                    | exp DIFERENTE exp {
                                                 if($1 != $3)
                                                 {
                                                      $$=1;
                                                      printf("\tVERDADERO\n\n");
                                                 }
                                                 else
                                                 {
                                                      $$ = 0;
                                                      printf("\tFALSO\n\n");
                                                  }
                    }


                    | ID2 IGUAL cad {
                                                  if($1->tipo !=  2)
                                                  {
                                                        printf("\tError, los tipos de datos no son compatibles\n\n");
                                                        $$=0;
                                                  }
                                                  else
                                                  {

                                                     if(!strcmp($1->valorcad,$3))
                                                     {
                                                          $$=1;
                                                          printf("\tVERDADERO\n\n");
                                                     }
                                                     else
                                                     {
                                                          $$ = 0;
                                                          printf("\tFALSO\n\n");
                                                      }
                                                  }

                         }
                         | ID2 DIFERENTE cad {
                                                  if($1->tipo !=  2)
                                                  {
                                                        printf("\tError, los tipos de datos no son compatibles\n\n");
                                                        $$ = 0;
                                                  }
                                                  else
                                                  {
                                                          if(strcmp($1->valorcad,$3))
                                                          {
                                                               $$=1;
                                                               printf("\tVERDADERO\n\n");
                                                          }
                                                          else
                                                          {
                                                               $$ = 0;
                                                               printf("\tFALSO\n\n");
                                                           }
                                                  }
                         }

                         | cad IGUAL ID2 {
                                                       if($3->tipo !=  2)
                                                       {
                                                             printf("\tError, los tipos de datos no son compatibles\n\n");
                                                             $$=0;
                                                       }
                                                       else
                                                       {

                                                          if(!strcmp($1,$3->valorcad))
                                                          {
                                                               $$=1;
                                                               printf("\tVERDADERO\n\n");
                                                          }
                                                          else
                                                          {
                                                               $$ = 0;
                                                               printf("\tFALSO\n\n");
                                                           }
                                                       }

                              }
                              | cad DIFERENTE ID2 {
                                                       if($3->tipo !=  2)
                                                       {
                                                             printf("\tError, los tipos de datos no son compatibles\n\n");
                                                             $$ = 0;
                                                       }
                                                       else
                                                       {
                                                               if(strcmp($1,$3->valorcad))
                                                               {
                                                                    $$=1;
                                                                    printf("\tVERDADERO\n\n");
                                                               }
                                                               else
                                                               {
                                                                    $$ = 0;
                                                                    printf("\tFALSO\n\n");
                                                                }
                                                       }
                              }


                              | cad IGUAL cad {

                                                               if(!strcmp($1,$3))
                                                               {
                                                                    $$=1;
                                                                    printf("\tVERDADERO\n\n");
                                                               }
                                                               else
                                                               {
                                                                    $$ = 0;
                                                                    printf("\tFALSO\n\n");
                                                                }

                                   }
                                   | cad DIFERENTE cad {
                                                                    if(strcmp($1,$3))
                                                                    {
                                                                         $$=1;
                                                                         printf("\tVERDADERO\n\n");
                                                                    }
                                                                    else
                                                                    {
                                                                         $$ = 0;
                                                                         printf("\tFALSO\n\n");
                                                                     }
                                   }

;

condicion: SI '(' explog ')' { $$ = $3; }
;

explog: compara { $$ = $1; }
        | explog '&' explog { $$ = $1 && $3; }
        | explog '|' explog { $$ = $1 || $3; }

;

impr: IMPRIME '(' conj ')' {  $$ = $3; }
;

conj:   xp { $$ = $1; }
        | conj '.' conj { $$ = strcat($1,$3);}
;

xp:  ID2 {
                    if( $1->tipo == 1 )
                    {
                        char *num = (char*)malloc(12);
                         sprintf(num,"%d",$1->valorint);
                        int i;
                        char *aux=(char*)malloc(strlen(num));
                            
                        for(i=0;i<strlen(num);i++)
                            aux[i] = num[i];
                       $$ = aux;
                    }
                    else
                    {
                        char *aux = (char*)malloc(strlen($1->valorcad));
                        int i;

                        for(i=0 ; i < strlen($1->valorcad) ; i++)
                            aux[i] = $1->valorcad[i];

                        $$ = aux;
                    }
     }
     |cad { $$ = $1;}
     | exp {
                    char *num = (char*)malloc(12);
                    sprintf(num,"%d",$1);
                    int i;
                    char *aux=(char*)malloc(strlen(num));
                        
                    for(i=0;i<strlen(num);i++)
                        aux[i] = num[i];
                   $$ = aux;
          }
     | ID1 { 
                printf("\tError, la variable no se encuentra definida\n\n");
               $$ = "";
    }
    
;

%%

int main() {
     //Inicializar la tabla de símbolos
     t = inicializar();
     yyparse();
}

yyerror (char *s)
{
  printf ("--%s--\n", s);
}

int yywrap()
{
  return 1;
}
