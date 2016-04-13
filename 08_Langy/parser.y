
%{
#include <stdio.h>
int yylex();
extern char* yytext;
extern int yylineno;
void yyerror( const char* msg)
{
  printf("Error: %s '%s' on line %d.\n"
        ,msg
        ,yytext
        ,yylineno);
}
%}

%token NUM
%token ID
%token ADD
%token MUL
%token SUB
%token MOD
%token ASSIGN
%token COMPARE
%token LT
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token IF
%token WHILE

%left COMPARE LT
%left ADD SUB
%left MUL MOD

%%

program: stmtlist

stmtlist: stmt
        | stmtlist stmt

stmt: expr
    | assignstmt
    | ifstmt
    | whilestmt

expr: expr ADD expr
    | expr MUL expr
    | expr SUB expr
    | expr MOD expr
    | expr COMPARE expr
    | expr LT expr
    | LPAREN expr RPAREN
    | NUM
    | ID

assignstmt: ID ASSIGN expr

ifstmt: IF LPAREN expr RPAREN
           LBRACE stmtlist RBRACE

whilestmt: WHILE LPAREN expr RPAREN
             LBRACE stmtlist RBRACE

%%

int main()
{
  yyparse();
  return 0;
}
