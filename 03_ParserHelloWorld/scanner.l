
%option noyywrap
%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%

[a-zA-Z] { yylval.ch = *yytext;
           return CH;}

bing { return BING;}

%%

