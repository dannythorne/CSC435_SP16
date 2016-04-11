%option noyywrap

%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%

[0-9]+ {
         yylval.num
         =
         atoi(yytext);
         return NUM;
       }
[a-z]  { yylval.id = *yytext;
         return ID;
       }
"+"    { return ADD;}
"-"    { return SUB;}
"*"    { return MUL;}
"="    { return ASSIGN;}
"("    { return LPAREN;}
")"    { return RPAREN;}

" "+   {}

%%

