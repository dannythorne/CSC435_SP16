
%{
#include <stdio.h>
int yylex();
void yyerror( const char* msg) { printf("\n");}
%}

%union
{
  char ch;
};

%token <ch> CH
%token BING

%%

start: stuff | start stuff

stuff: character | bing

character: CH { printf("[%c]\n",$1);}

bing: BING { printf("Hello, World!\n");}

%%

int main()
{
  yyparse();
  return 0;
}
