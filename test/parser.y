%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}

%union {int num; char id;}         /* Yacc definitions */
%start line
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
%type <num> line exp term ari
%type <id> assignment
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

/* descriptions of expected inputs     corresponding actions (in C) */

line    : assignment ';'		{;}
		| exit_command ';'		{exit(EXIT_SUCCESS);}
		| print exp ';'			{if($2==1){printf("True\n");}
								 else if($2==0){printf("False\n");}
								 else if($2==-1){printf("Undeclared\n");};}
		| line assignment ';'	{;}
		| line print exp ';'	{if($3==1){printf("True\n");}
								 else if($3==0){printf("False\n");}
								 else if($3==-1){printf("Undeclared\n");};}
		| line exit_command ';'	{exit(EXIT_SUCCESS);}
        ;

assignment : identifier ':' exp  { updateSymbolVal($1,$3); }
			;
exp    	: term                  {$$ = $1;}
		| OPAR exp CLPAR		{$$ = $2;}
		| OPSQ exp CLSQ			{$$ = $2;}
		| ari '>' ari         	{if ($1 > $3) {$$ = 1; } else {$$ = 0;}}
		| ari GOE ari   		{if ($1 >= $3) {$$ = 1; } else {$$ = 0;}}
		| ari '<' ari           {if ($1 < $3) {$$ = 1; } else {$$ = 0;}}
		| ari LOE ari     		{if ($1 <= $3) {$$ = 1; } else {$$ = 0;}}
		| ari EQ ari    		{if ($1 == $3) {$$ = 1; } else {$$ = 0;}}
		| ari DF ari      		{if ($1 != $3) {$$ = 1; } else {$$ = 0;}}
		| exp XNOR exp          {if ($1 == $3) {$$ = 1; } else {$$ = 0;}}
		| exp IMPLY exp         {if ($1 == 1 && $3 == 0) {$$ = 0; } else {$$ = 1;}}
		| exp XOR exp           {if ($1 != $3) {$$ = 1; } else {$$ = 0;}}
		| exp AND exp           {if ($1 == 1 && $3 == 1) {$$ = 1; } else {$$ = 0;}}
		| exp OR exp           	{if ($1 == 1 || $3 == 1) {$$ = 1; } else {$$ = 0;}}
		| NOT exp           	{$$ = !$2;}
       	;

ari		: number				{$$ = $1;}
		| ari '+' ari          	{$$ = $1 + $3;}
       	| ari '-' ari         	{$$ = $1 - $3;}
       	| ari '*' ari          	{$$ = $1 * $3;}
       	| ari '/' ari         	{$$ = $1 / $3;}
		| OPAR ari CLPAR		{$$ = $2;}
		| OPSQ ari CLSQ			{$$ = $2;}
term   	: T               	{$$ = 1;}
		| F					{$$ = 0;}
		| identifier			{$$ = symbolVal($1);} 
        ;

%%                     /* C code */

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

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = -1;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 