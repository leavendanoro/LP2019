%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    extern int yylex(); 
    void yyerror(char *s);
    int variables [52];
    int computeSymbolIndex(char c);
    int symbolVal(char symbol);
    void updateSymbolVal(char symbol, int val);
%}

%start LINE
%union {double val; char id;}

%token <id> IDALG                    /*Predicado algebraico*/
%token <id> IDARIT                   /*Predicado aritmético*/
%token <val> NUM                 /*Número*/ 
%token EOL                           /*Fin de linea ";" */
%token DEF                     /*Definición algebraica ":=" */    

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
%token PRINT 
%token EXIT_COMMAND

%type <val> LINE 
%type <val> EXPR 
%type <val> PREDARIT
%type <id> ASSIG
%type <id> ID 

%%

LINE    : ASSIG EOL                     {;}
        | EXIT_COMMAND EOL              {exit(EXIT_SUCCESS);}
        | PRINT ID {}                   {printf("Printing %d/n", $2);}
        | LINE ASSIG EOL                {;}
        | LINE PRINT EXPR EOL           {printf("Printing %d/n", $3);}
        | LINE EXIT_COMMAND EOL         {exit(EXIT_SUCCESS);}
ASSIG   : ID DEF EXPR                   {updateSymbolVal($1,$3);}
    

EXPR    :   OPAR EXPR CLPAR             
        |   PREDARIT GT PREDARIT        {if ($1 > $3) {$$ = 1; } else {$$ = 0;}}            
        |   PREDARIT LT PREDARIT        {if ($1 < $3) {$$ = 1;} else {$$= 0;}}    
        |   PREDARIT GOE PREDARIT       {if ($1 >= $3) {$$ = 1;} else {$$= 0;}}      
        |   PREDARIT LOE PREDARIT       {if ($1 <= $3) {$$ = 1;} else {$$= 0;}}
        |   PREDARIT EQ PREDARIT        {if ($1 == $3) {$$ = 1;} else {$$= 0;}}       
        |   PREDARIT DF PREDARIT        {if ($1 != $3) {$$ = 1;} else {$$= 0;}} 
        ;

ID      : IDALG
        | IDARIT 
        ;

PREDARIT    : NUM
            | PREDARIT PLUS NUM  {$$ = $1 + $3;}  
            | PREDARIT MINUS NUM {$$ = $1 - $3;}
            | PREDARIT TIMES NUM {$$ = $1 * $3;}
            | PREDARIT OVER NUM  {$$ = $1 / $3;}
            | OPAR PREDARIT CLPAR 
            ;

EMPTY   : ;



%%

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return variables[bucket];
}

void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	variables[bucket] = val;
}

int main(void){
    int i;
    int j;
    for(i = 0; i < 100; i++){
        variables[i] = -1;
    }

    while(yylex()){
     yyparse();
    }
    return 0;
}

void yyerror(char* s){
    fprintf(stderr, "%s\n", s);
}