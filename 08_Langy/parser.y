
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
  enum { NUM_t, ID_t, OP_t} type;
  union
  {
    int num;
    char id;
    enum { LT_t, COMPARE_t} op;
  } val;
  struct exprnode* left;
  struct exprnode* next;
};

struct stmtnode
{
  enum
  {
    INPUT_t
  , OUTPUT_t
  , ASSIGN_t
  , WHILE_t
  , IF_t
  } type;
  struct exprnode* expr;
  struct stmtnode* body;
  struct stmtnode* next;
};

void genCode( struct stmtnode* program);
void genStatementList( struct stmtnode* stmtlist);

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
%token <id> ID
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
  $$->type = INPUT_t;

  $$->expr = (struct exprnode*)malloc(sizeof(struct exprnode));
  $$->expr->type = NUM_t;
  $$->expr->val.id = $2;
  $$->expr->left = NULL;
  $$->expr->next = NULL;

  $$->body = NULL;
  $$->next = NULL;
}

%%

int main()
{
  yyparse();

  genCode( program.body);

  return 0;
}

void genCode( struct stmtnode* program)
{
  genStatementList( program);
}

void genStatementList( struct stmtnode* stmtlist)
{
  struct stmtnode* curstmt = stmtlist;
  while( curstmt!=NULL)
  {
    switch( curstmt->type)
    {
      case INPUT_t:
        printf("input %c\n",curstmt->expr->val.id);
        break;
      default:
        break;
    }
    curstmt = curstmt->next;
  }
}
