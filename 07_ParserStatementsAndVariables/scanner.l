%option noyywrap

%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%

[0-9]+ { return NUM;}
[a-z]  { return ID;}
"+"    { return ADD;}
"-"    { return SUB;}
"*"    { return MUL;}
"="    { return ASSIGN;}
"("    { return LPAREN;}
")"    { return RPAREN;}

" "+   {}

%%

