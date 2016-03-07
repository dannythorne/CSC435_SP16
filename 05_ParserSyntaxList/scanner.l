%option noyywrap

%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%
[a-zA-Z] {
           printf("Scanner matched a CH token [%c].\n",*yytext);
           yylval.ch = *yytext;
           return CH;
         }

"\n"+    {
           printf("Scanner matched newline(s) .\n");
         }

%%

