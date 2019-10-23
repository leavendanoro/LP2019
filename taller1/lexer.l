%{
#include <stdio.h>
typedef struct data data;
struct data {
    int type;
    char *lex;
    int meaning[2];
};
data d = {.type = -1, .lex = "-NL", .meaning = {-1}};
/*
Definicion arreglos auxiliares para añadir más de un significado
 a los predicados sin numero pues pueden ser variables
*/
char * alge [] = {"x","y","z"};
char * ari [] = {"p","q","r","t"};

#define LPAR 10
#define RPAR 11
#define LBRA 12
#define RBRA 13
#define COMMA 14
#define SEMICOLON 15
#define COLON 16
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
";" {return SEMICOLON;}
":" {return COLON;}
{numero} {d.lex = yytext;
          return NUMERO;}
{variable} {
    int i = 0;
    while(alge[i]) {
        if(strcmp(alge[i], yytext) == 0) {
            d.meaning[0] = VAR;
            d.meaning[1] = IDALG;
            break;
        }
        i++;
    }
    i = 0;
    while(ari[i]) {
        if(strcmp(ari[i], yytext) == 0) {
            d.meaning[0] = VAR;
            d.meaning[1] = IDARI;
            break;
        }
        i++;
    }
    d.lex = yytext;
    return VAR;
}
{idalg} {d.lex = yytext;
         return IDALG;}
{idari} {d.lex = yytext;
         return IDARI;}
"=" {d.type = EQ;
     return RELOP;}
">" {d.type = GT;
     return RELOP;}
"<" {d.type = LT;
     return RELOP;}
"<=" {d.type = LE;
      return RELOP;}
">=" {d.type = GE;
      return RELOP;}
"<>" {d.type = NE;
      return RELOP;}
"+" {d.type = ADD;
     return ARIOP;}
"-" {d.type = SUS;
     return ARIOP;}
"*" {d.type = MUL;
     return ARIOP;} 
"/" {d.type = DIV;
     return ARIOP;} 
"->" {d.type = THEN;
      return LOGOP;}
"&&" {d.type = AND;
      return LOGOP;}
\|\| {d.type = OR;
      return LOGOP;}
\-\| {d.type = XOR;
      return LOGOP;}
EXT {d.type = EXIST;
     return LOGOP;}
FORALL {d.type = FORALL;
        return LOGOP;} /* operador FORALL */
IFF {d.type = IFF;
     return LOGOP;} /* operador IFF */
":=" {return ASIGN;}
{funcion} {d.lex = yytext;
           return FUNC;}
%%

#include <stdio.h>

int yywrap() {}
int main(argc,argv)
int argc;
char *argv[];
{
    int val;
    while(val = yylex()){
        if(d.type != -1){
            printf("< %d , %d , - , - >\n",val,d.type);
            d.type = -1;
        }else{
            if(d.lex != "-NL"){
                if(d.meaning[0] != -1){
                    printf("< %d , - , %s , < %d , %d > >\n",val,d.lex,d.meaning[0],d.meaning[1]);
                    d.meaning[0] = d.meaning[1] = -1;
                    d.lex = "-NL";
                }else{
                    printf("< %d , - , %s , - >\n",val,d.lex);
                    d.lex = "-NL";
                }
            }else{
                printf("< %d , - , - , - >\n",val);                
            }
        }
        
    }
}