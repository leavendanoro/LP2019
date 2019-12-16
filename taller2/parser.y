%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    int yylex(); 
    void yyerror(char *s);
    char vars[52];
%}

%token FUNC                      /*Función*/
%token VAR                       /* Variable de función*/
%token IDALG                     /*Predicado algebraico*/
%token IDARIT                    /*Predicado aritmético*/
%token NUM                       /*Número*/
%token EOL                       /*Fin de linea ";" */
%token ASIGALG                   /*Definición algebraica ":=" */    
%token ASIGARIT                  /*Definición aritmética ":" */

%token OPAR                      /*Paréntesis abierto "(" */
%token CLPAR                     /*Paréntesis cerrado ")" */
%token OPSQ                      /*Paréntesis cuadrado abierto "[" */
%token CLSQ                      /*Paréntesis cuadrado cerrado "]" */

%token GOE                       /*Mayor o igual ">=" */
%token LOE                       /*Menor o igual "<=" */
%token GT                        /*Mayor ">" */
%token LT                        /*Menor "<" */
%token EQ                        /*Igual "==" */
%token DF                        /*Diferente "!=" */ 

%token OR                        /*O lógico*/ 
%token AND                       /*Y lógico*/
%token NOT                       /*No lógico*/
%token IMPLY                     /*Implicación lógica*/
%token XNOR                      /*Equivalencia lógica*/
%token XOR                       /*O exclusivo*/

%token OPARIT                    /*Operadores aritmeticos*/
%token PLUS                      /*Suma*/
%token MINUS                     /*Resta*/
%token TIMES                     /*Producto*/
%token OVER                      /*División*/
%start EXPR

%%

EXPR    : FUNC OPAR PARAM CLPAR EOL 
        | ID ASIGN PRED EOL
        ;

PARAM   : PARAM ASIGARIT PARAM
        | IDALG
        | IDARIT
        | VAR
        | EMPTY
        ;

ID      : IDALG
        | IDARIT 
        ;

ASIGN   : ASIGALG
        | ASIGARIT
        ;

COLONPRED: PRED EOL{;};

PRED    : PRED PLUS PRED {$$ = $1 + $3;}
        | PRED MINUS PRED {$$ = $1 + $3;}
        | PRED TIMES PRED {$$ = $1 + $3;}
        | PRED OVER PRED  {$$ = $1 + $3;}

        | PRED GT PRED {if ($1 > $3) {$$ = 1;} else {$$= 0;}}
        | PRED LT PRED {if ($1 < $3) {$$ = 1;} else {$$= 0;}}
        | PRED GOE PRED {if ($1 >= $3) {$$ = 1;} else {$$= 0;}}
        | PRED LOE PRED {if ($1 <= $3) {$$ = 1;} else {$$= 0;}}
        
        | PRED DF PRED {if ($1 != $3) {$$ = 1;} else {$$= 0;}} 
        | PRED EQ PRED {if ($1 == $3) {$$ = 1;} else {$$= 0;}} 
        | PRED IMPLY PRED {if ($1 >= $3) {$$ = 1;} else {$$= 0;}} 
        | PRED AND PRED {if ($1 == 1 && $3 == 0) {$$ = 0;} else {$$ = 1;}}
        | PRED OR PRED  {if ($1 || $3 == 1) {$$ = 1;} else{$$ = 0;}}
        | PRED XNOR PRED {if ($1 == $3) {$$ = 1;} else {$$= 0;}} 
        | VAR
        | NUM
        | IDALG
        | IDARIT
        ; 
EMPTY   : ;



%%
int main(void){
    int i;
    for(i = 0; i < 52; i++){
        vars[i] = 0;
    }
    return yyparse(); 
}
void yyerror(char* s){
    fprintf(stderr, "%s\n", s);
}