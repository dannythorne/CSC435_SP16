
%{
#include <stdio.h>
int yylex();
void yyerror( const char* msg)
{
  printf("ERROR: %s\n", msg);
}

%}

%union
{
  int num;
  char id;
};

%token <num> NUM
%token <id> ID
%token ADD
%token SUB
%token MUL
%token ASSIGN
%token LPAREN
%token RPAREN

%left SUB
%left ADD
%left MUL

%%

program: stmtlist
         {
           printf("stmtlist\n");
         }

stmtlist: stmt
          {
            printf("stmt\n");
          }
        | stmtlist stmt
          {
            printf("stmtlist stmt\n");
          }

stmt: expr
      {
        printf("expr\n");
      }
    | assignstmt
      {
        printf("assignstmt\n");
      }

expr: expr ADD expr
      {
        printf("expr ADD expr\n");
      }
    | expr SUB expr
      {
        printf("expr SUB expr\n");
      }
    | expr MUL expr
      {
        printf("expr MUL expr\n");
      }
    | LPAREN expr RPAREN
      {
        printf("LPAREN expr RPAREN\n");
      }
    | NUM
      {
        printf("NUM\n");
      }
    | ID
      {
        printf("ID\n");
      }
assignstmt: ID ASSIGN expr
      {
        printf("ID ASSIGN expr\n");
      }

%%

int main()
{
  yyparse();
  return 0;
}
