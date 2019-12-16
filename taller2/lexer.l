%{
    #include "parser.tab.h"
    void yyerror(char *s);
    int yylex();
%}


delim               [ \t\n]        
ws                  {delim}+
letraInicialArit    [pqrtPQRT]    
letraInicialAlg     [xyzXYZ]    
digito              [0-9]         
numero              ({digito}+|{digito}*\.{digito}+([eE][-+]?{digito}+)?)
predicadoAritID     {letraInicialArit}({digito}{1,5})?  
predicadoAlgID      {letraInicialAlg}({digito}{1,5})?   
funcion             ^[A-Z][a-z]*]        




%%
{ws}                {/*No hacer nada*/}
{funcion}           {yylval = yytext; return FUNC;}  
{predicadoAritID}   {yylval = yytext; return IDARIT;}
{predicadoAlgID}    {yylval = yytext; return IDALG;}
{numero}            {yylval = strtod(yytext, NULL); return NUM;}
";"                 {return EOL;}
":="                {return ASIGALG;}
":"                 {return ASIGARIT;}
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
int yywrap (void){
    return 1;
}

