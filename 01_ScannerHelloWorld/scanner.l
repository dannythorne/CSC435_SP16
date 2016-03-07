%option noyywrap
%{
#include <stdio.h>
%}

%%

bing            {printf("Hello, World!");}

%% 

int main()
{
  yylex();
  return 0;
}

