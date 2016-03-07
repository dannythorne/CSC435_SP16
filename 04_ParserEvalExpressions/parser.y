
%{
#include <stdio.h>
extern char* yytext;
int yylex();
void yyerror( const char* msg)
{
  printf("Error: %s \"%s\"\n",msg,yytext);
}
%}

%union
{
  int num;
};

%token <num> NUM
%token ADD
%token MUL
%token LPAREN
%token RPAREN

%type <num> expr

%left ADD
%left MUL

%%

expr: NUM
      {
        $$ = $1;
        printf("[%d]",$$);
      }
    | expr ADD expr
      {
        $$ = $1 + $3;
        printf("[%d+%d=%d]",$1,$3,$$);
      }
    | expr MUL expr
      {
        $$ = $1 * $3;
        printf("[%d*%d=%d]",$1,$3,$$);
      }
    | LPAREN expr RPAREN
      {
        $$ = $2;
        printf("[(%d)]",$$);
      }

%%

int main()
{
  yyparse();
  return 0;
}

