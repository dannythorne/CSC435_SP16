
%{
#include <stdio.h>
int yylex();
extern char* yytext;
void yyerror( const char* msg) { printf("Error: %s \"%s\"",msg,yytext);}

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
        $$ = (struct node*)malloc(sizeof(struct node));
        $$->type = OPERATOR;
        $$->val.operator = '+';
        $$->left = $1;
        $$->right = $3;
        exprtree = $$;
      }
    | expr MUL expr
      {
        printf("Parser sees MUL expression.\n");
        $$ = (struct node*)malloc(sizeof(struct node));
        $$->type = OPERATOR;
        $$->val.operator = '*';
        $$->left = $1;
        $$->right = $3;
        exprtree = $$;
      }
    | NUM
      {
        printf("Parser sees NUM (%d) expression.\n",$1);
        $$ = (struct node*)malloc(sizeof(struct node));
        $$->type = OPERAND;
        $$->val.operand = $1;
        $$->left = NULL;
        $$->right = NULL;
        exprtree = $$;
      }

%%

void display_fully_parenthesized( struct node* exprtree);
void display_postfix( struct node* exprtree);

int main()
{
  yyparse();
//------------------------------------------------------------------------------

  printf("\nexprtree = %p\n",exprtree);

  display_fully_parenthesized( exprtree);
  display_postfix( exprtree);

  return 0;
}

void display_fully_parenthesized( struct node* exprtree)
{
  if( exprtree->type == OPERAND)
  {
    printf("%d",exprtree->val.operand);
  }
  else
  {
    printf("(");
    display_fully_parenthesized( exprtree->left);
    printf("%c",exprtree->val.operator);
    display_fully_parenthesized( exprtree->right);
    printf(")");
  }
}

void display_postfix( struct node* exprtree)
{
}
