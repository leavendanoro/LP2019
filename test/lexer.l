%{
#include "parser.tab.h"
void yyerror (char *s); //Inicialización de las funciones (generadora de errores y escaner)
int yylex();
%}
%%
 //Definición de los acciones y las definiciones regulares que son asociada a los tokens creados en el parser
"print"				    {return print;} 
"exit"				    {return exit_command;}
[a-zA-Z]			    {yylval.id = yytext[0]; return identifier;}
[0-9]+                  {yylval.num = atoi(yytext); return number;}
[ \t\n]                 ;
[-+=*/;><:]             {return yytext[0];}
"=="                    {return EQ;}
">="                    {return GOE;}
"<="                    {return LOE;}
"!="                    {return DF;}
"||"                    {return OR;}
"&&"                    {return AND;}
"!"                     {return NOT;}
"<=>"                   {return XNOR;}
"=>"                    {return IMPLY;}
"~||"                   {return XOR;}
"True"                  {return T;}
"False"                 {return F;}
"("                     {return OPAR;}
")"                     {return CLPAR;}
"["                     {return OPSQ;}
"]"                     {return CLSQ;}
.                       {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}