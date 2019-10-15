%{
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
%}
digito [0-9]
numero {digito}+(\.{digito}+)?(E[+-]?{digito}+)?
idalg [x|y|z]{digito}{0,5}
idari [p,q,r,t]{digito}{0,5}
%%
[ \t\n]+		;
{numero} {return NUMERO;}
{idalg} {return IDALG;}
{idari} {return IDARI;}
"=" {yylval = EQ; return RELOP;}
">" {yylval = GT; return RELOP;}
"<" {yylval = LT; return RELOP;}
"<=" {yylval = LE; return RELOP;}
">=" {yylval = GE; return RELOP;}
"<>" {yylval = NE; return RELOP;}
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