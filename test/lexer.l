%{
#include "parser.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
"print"				   {return print;}
"exit"				   {return exit_command;}
[a-zA-Z]			   {yylval.id = yytext[0]; return identifier;}
[0-9]+                 {yylval.num = atoi(yytext); return number;}
[ \t\n]                ;
[-+=*/;><]              {return yytext[0];}
"=="                {return EQ;}
">="                {return GOE;}
"<="                {return LOE;}
"!="                {return DF;}
"||"                {return OR;}
"&&"                {return AND;}
"!"                 {return NOT;}
"<=>"               {return XNOR;}
"=>"                {return IMPLY;}
"~||"               {return XOR;}
.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}