%option noyywrap
%option yylineno
%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%

[0-9]+   { return NUM;}
"+"      { return ADD;}
"*"      { return MUL;}
"-"      { return SUB;}
"%"      { return MOD;}
"="      { return ASSIGN;}
"=="     { return COMPARE;}
"<"      { return LT;}
"("      { return LPAREN;}
")"      { return RPAREN;}
"{"      { return LBRACE;}
"}"      { return RBRACE;}
if       { return IF;}
while    { return WHILE;}
input    { return INPUT;}
[a-z]    {
           yylval.id = *yytext;
           return ID;
         }

[ \n]+   {}

%%

