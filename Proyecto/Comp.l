%{
    #include "ETS.tab.h"
    #include "ETS.tab.c"
%}

NUMINT [0-9]+
%%

[I][M][P][R][I][M][I][R][_][T][A][B][L][A] {
                              return (IMPRIMIR);
}

[I][N][T] {
          printf("Declaracion de variable tipo entero\n");
          return (INT);

}

[S][I] {
        printf("Inicio de estructura condicional\n");
        return (SI);
}

[S][T][R][I][N][G] {
          printf("Declaracion de variable tipo cadena\n");
          return (STRING);

}
[I][M][P][R][I][M][E] {
          printf("Inicio de funcion imprimir\n");
          return(IMPRIME);
}


{NUMINT}        {
		          printf("Numero entero %s\n",yytext);
                    yylval.entero = atoi(yytext);
                    return (ENTERO);
                }


"+"|"*"|"/"|"-" {
		          printf("Signo op %s\n",yytext);
                    return (yytext[0]);
                }


[mM][oO][dD]    {
                    printf("Modulo\n");
                    return(MODULO);
                }

"("|")"         {
                    printf("Parentesis\n");
                    return(yytext[0]);
                }

\.              {
                    printf("Punto\n");
                    return(yytext[0]);
                }


","             {
                    printf("Divide modulo\n");
                    return (yytext[0]);
                }

"="            {
                    printf("Signo igual\n");
                    return(yytext[0]);
               }

[=][=]         {
                    printf("Comparacion\n");
                    return(IGUAL);
               }

[!][=]         {
                    printf("Comparacion\n");
                    return(DIFERENTE);
               }

">"|"<"      {
                    printf("Comparacion\n");
                    return(yytext[0]);
}

"&"|"|" {
            printf("Operador logico\n");
            return (yytext[0]);
}

[a-zA-Z][a-zA-z0-9]* {
                         yylval.apuntador_s = buscar(t,yytext);
                         printf("Variable\n");
                         if (yylval.apuntador_s == NULL)
                         {
                              yylval.apuntador_s=(struct Tabla*)malloc(sizeof(struct Tabla));
                              strcpy(yylval.apuntador_s->nombre,yytext);
                              yylval.apuntador_s->valorint=0;
                              strcpy(yylval.apuntador_s->valorcad,"");
                              yylval.apuntador_s->tipo=0;
                              insertar(&t, yylval.apuntador_s);
                              return ID1;
                         }
                         else
                         {
                                   return ID2;
                         }

}





"\n"            {
		          printf("Salto de linea\n");
                    return (yytext[0]);
                }



\"[a-zA-z0-9 .,:ñÑ]+\"    {
                    char *cad;
                    int tam=strlen(yytext);
                    cad=(char*)malloc(tam);
                    int i;

                    for( i = 1; i < tam-1 ; i++ )
                         cad[i-1] = yytext[i];

                    printf("Cadena: %s\n",cad);
                    yylval.caracter=(cad);
                    return(CADENA);
        }



%%
