%{
/*Declaraciones de C usadas en las acciones*/	
void yyerror (char *s);
int yylex();
#include <stdio.h>     
#include <stdlib.h>
#include <ctype.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}
/* Yacc definitions */
%union {int num; char id;}   //Unión para asociar los valores con las ids de las tablas de símbolos      
%start line   			     // No terminal inicial
// Definición de los tokens
%token print			     
%token exit_command
%token T
%token F
%token OPAR
%token CLPAR
%token OPSQ
%token CLSQ
%token <num> number
%token <id> identifier
// Tipos de datos esperados por los no terminales desde el lexer
%type <num> line exp term ari
%type <id> assignment
// Definida la precedencia de los operadores (Si el número de linea es menor, su precedencia será menor)
%left XNOR
%left IMPLY
%left OR
%left AND
%left XOR
%left '<' '>' EQ GOE LOE DF
%left '+' '-'
%left '*' '/'
%right NOT
%%

//Definición de la gramática 

/* 			Producciones     				Acciones semánticas asociadas */
			
			//Produccion base
line    	: assignment ';'				{;}
			| exit_command ';'				{exit(EXIT_SUCCESS);} //Termina el compilador
			
			| print exp ';'					{	if($2==1){printf("True\n");}   // Imprime el valor de una variable
								 				else if($2==0){printf("False\n");}
								 				else if($2==-1){printf("Undeclared\n");};
											}

			| line assignment ';'			{;}
			// Imprime el valor de las expresiones 
			| line print exp ';'			{	if($3==1){printf("True\n");} 
								 				else if($3==0){printf("False\n");}
								 				else if($3==-1){printf("Undeclared\n");};
											}

			| line exit_command ';'			{exit(EXIT_SUCCESS);}
			;

assignment 	: identifier ':' exp  			{updateSymbolVal($1,$3);} // Asigna un valor a una variable
			;

exp    		: term                  		{$$ = $1;} //Realiza las operaciones necesarias para encontrar el valor de verdad de una expresión
			| OPAR exp CLPAR				{$$ = $2;}
			| OPSQ exp CLSQ					{$$ = $2;}
			| ari '>' ari         			{if ($1 > $3) {$$ = 1; } else {$$ = 0;}}
			| ari GOE ari   				{if ($1 >= $3) {$$ = 1; } else {$$ = 0;}}
			| ari '<' ari           		{if ($1 < $3) {$$ = 1; } else {$$ = 0;}}
			| ari LOE ari     				{if ($1 <= $3) {$$ = 1; } else {$$ = 0;}}
			| ari EQ ari    				{if ($1 == $3) {$$ = 1; } else {$$ = 0;}}
			| ari DF ari      				{if ($1 != $3) {$$ = 1; } else {$$ = 0;}}
			| exp XNOR exp          		{if ($1 == $3) {$$ = 1; } else {$$ = 0;}}
			| exp IMPLY exp         		{if ($1 == 1 && $3 == 0) {$$ = 0; } else {$$ = 1;}}
			| exp XOR exp           		{if ($1 != $3) {$$ = 1; } else {$$ = 0;}}
			| exp AND exp           		{if ($1 == 1 && $3 == 1) {$$ = 1; } else {$$ = 0;}}
			| exp OR exp           			{if ($1 == 1 || $3 == 1) {$$ = 1; } else {$$ = 0;}}
			| NOT exp           			{$$ = !$2;}
			;

ari			: number						{$$ = $1;} //Realiza operaciones sobre números
			| ari '+' ari          			{$$ = $1 + $3;}
			| ari '-' ari         			{$$ = $1 - $3;}
			| ari '*' ari          			{$$ = $1 * $3;}
			| ari '/' ari         			{$$ = $1 / $3;}
			| OPAR ari CLPAR				{$$ = $2;}
			| OPSQ ari CLSQ					{$$ = $2;}

term   		: T               				{$$ = 1;} 
			| F								{$$ = 0;}
			| identifier					{$$ = symbolVal($1);} 
        	;

%%                     /* C code */

int computeSymbolIndex(char token) //Convierte los caracteres a su posición equivalente dentro de la tabla de símbolos.
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 


int symbolVal(char symbol) // Returna el valor de un símbolo dado.
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}


void updateSymbolVal(char symbol, int val) //Actualiza el valor de un símbolo dado.
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (void) {
	//Inicializa la tabla de símbolos.
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = -1;
	}

	return yyparse ();
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} //Captura errores e imprime su causa