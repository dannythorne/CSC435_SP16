
%{
#include <stdio.h>
int yylex();
extern char* yytext;
extern int yylineno;
void yyerror( const char* msg)
{
  printf( "Error: %s '%s' on line %d.\n"
        , msg
        , yytext
        , yylineno);
}

struct exprnode
{
  enum { TODO1} type;
  union
  {
  } val;
  struct exprnode* next;
};

struct stmtnode
{
  enum { TODO2} type;
  struct exprnode* expr;
  struct stmtnode* body;
  struct stmtnode* next;
};

struct stmtnode program;

%}

%union
{
  int num;
  char id;
  struct stmtnode* stmt;
  struct exprnode* expr;
};

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
%token INPUT

%left COMPARE LT
%left ADD SUB
%left MUL MOD

%type <stmt> stmtlist
%type <stmt> stmt
%type <stmt> inputstmt

%%

program: stmtlist
{
  program.body = $1;
}

stmtlist:
  stmt
{
  $$ = $1;
}
| stmtlist stmt
{
}

stmt:
  assignstmt
| ifstmt
| whilestmt
| inputstmt
{
  $$ = $1;
}

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

inputstmt: INPUT ID
{
  $$ = (struct stmtnode*)malloc(sizeof(struct stmtnode));
}

%%

int main()
{
  yyparse();
  return 0;
}
