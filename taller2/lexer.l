%{
    #include "parser.tab.h"
%}

%option noyywrap
delim               [ \t\n]        
ws                  {delim}+
digito              [0-9]         
numero              ({digito}+|{digito}*\.{digito}+([eE][-+]?{digito}+)?)
predicadoAritID     [a-z]  
predicadoAlgID      [A-Z]
funcion             ^[A-Z][a-z]*]
        




%%
{ws}                {/*No hacer nada*/}
{predicadoAritID}   {yylval.id = yytext; return IDARIT;}
{predicadoAlgID}    {yylval.id = yytext; return IDALG;}
{numero}            {yylval.val = strtod(yytext, NULL); return NUM;}
"print"             {return PRINT;}
"exit"              {return EXIT_COMMAND;}
";"                 {return EOL;}
":="                {return DEF;}
":"                 {return DEF;}
"("                 {return OPAR;}
")"                 {return CLPAR;}
"["                 {return OPSQ;}
"]"                 {return CLSQ;}
">="                {return GOE;}
"<="                {return LOE;}
">"                 {return GT;}
"<"                 {return LT;}
"=="                {return EQ;}
"!="                {return DF;}
"<>"                {return DF;}
"||"                {return OR;}
"&&"                {return AND;}
"!"                 {return NOT;}
"<=>"               {return XNOR;}
"=>"                {return IMPLY;}
"~||"               {return XOR;}
"+"                 {return PLUS;}
"-"                 {return MINUS;}
"*"                 {return TIMES;}
"/"                 {return OVER;}
.                   {ECHO; yyerror ("unexpected character");}


%%


