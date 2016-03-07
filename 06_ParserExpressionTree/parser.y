
%{
#include <stdio.h>
int yylex();
void yyerror() {}

struct node
{
  enum { OPERAND, OPERATOR} type;
  union
  {
    int operand;
    char operator;
  } val;
  struct node* left;
  struct node* right;
};

struct node* exprtree;

%}

%union
{
  int num;
  struct node* exprptr;
};

%token <num> NUM
%token ADD
%token MUL

%type <exprptr> expr

%left ADD
%left MUL

%%

expr: expr ADD expr
      {
        printf("Parser sees ADD expression.\n");
      }
    | expr MUL expr
      {
        printf("Parser sees MUL expression.\n");
      }
    | NUM
      {
        printf("Parser sees NUM (%d) expression.\n",$1);
        $$ = (struct node*)malloc(sizeof(struct node));
        // TODO...
      }

%%

int main()
{
  yyparse();
//------------------------------------------------------------------------------

  printf("\nexprtree = %p\n",exprtree);

  return 0;
}
