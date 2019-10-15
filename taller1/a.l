%{
#define LPAR 10
#define RPAR 11
#define LBRA 12
#define RBRA 13
#define COMMA 14
#define COLON 15
#define NUMERO 400
#define IDALG 401
#define IDARI 402
#define RELOP 500
#define EQ 50
#define GT 51
#define LT 52
#define LE 53
#define GE 54
#define NE 55
#define ARIOP 600
#define ADD 60
#define SUS 61
#define MUL 62
#define DIV 63
#define LOGOP 700
#define THEN 70
#define AND 71
#define OR 72
#define XOR 73
#define EXIST 74
#define FORALL 75
#define IFF 76
#define ASIGN 800
#define VAR 900
#define FUNC 1000
%}
digito [0-9]
numero {digito}+(\.{digito}+)?(E[+-]?{digito}+)?
idalg [x|y|z]{digito}{0,5}
idari [p|q|r|t]{digito}{0,5}
variable [a-z]
funcion ^[A-Z][a-z]*
%%
[ \t\n]+		;
"(" {return LPAR;}
")" {return RPAR;}
"[" {return LBRA;}
"]" {return RBRA;}
"," {return COMMA;}
";" {return COLON;}
{numero} {return NUMERO;}
{idalg} {return IDALG;}
{idari} {return IDARI;}
"=" {return RELOP;}
">" {return RELOP;}
"<" {return RELOP;}
"<=" {return RELOP;}
">=" {return RELOP;}
"<>" {return RELOP;}
"+" {return ARIOP;}
"-" {return ARIOP;}
"*" {return ARIOP;} /* operador THEN */
"/" {return ARIOP;} /* division */
"->" {return LOGOP;} /* operador THEN */
"&&" {return LOGOP;} /* operador AND */
\|\| {return LOGOP;} /* operador OR */
\-\| {return LOGOP;} /* operador XOR */
EXT {return LOGOP;} /* operador EXT */
FORALL {return LOGOP;} /* operador FORALL */
IFF {return LOGOP;} /* operador IFF */
":"|":=" {return ASIGN;}
{variable} {return VAR;}
{funcion} {return FUNC;}
%%

#include <stdio.h>

int yywrap() {}
int main(argc,argv)
int argc;
char *argv[];
{
int val;
while(val = yylex()) printf("value is %d\n",val);
}