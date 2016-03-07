%option noyywrap
%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%

[1-9][0-9]* { yylval.num = atoi(yytext); return NUM;}
"+"         { return ADD;}
"*"         { return MUL;}

"\n"        {}

%%


