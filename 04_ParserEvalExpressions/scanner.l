%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
%}

%%

[0-9]+ {
         yylval.num = atoi(yytext);
         return NUM;
       }

"+"    { return ADD;}
"*"    { return MUL;}
"("    { return LPAREN;}
")"    { return RPAREN;}

%%

