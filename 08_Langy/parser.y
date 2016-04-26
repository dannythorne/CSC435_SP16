
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

struct stmtlist
{
  struct stmtnode* head;
  struct stmtnode* tail;
};

struct symTableEntry
{
  char hasVal; // set to 0 or 1
  int val;
};

struct symTableEntry** symTable;

struct stmtnode program;

void genCode( struct stmtnode* program);
int genLocalVars( FILE* fout
                , struct symTableEntry** symTable);
void genAssignStmt(FILE* fout
                  , struct stmtnode* assignStmt);
void genStatementList( FILE* fout
                     , struct stmtnode* stmtlist);

void freeStmtNode( struct stmtnode** stmt);
void freeExprNode( struct exprnode** expr);
void freeSymTable( struct symTableEntry*** symTable);

%}

%union
{
  int num;
  char id;
  struct stmtnode* stmt;
  struct exprnode* expr;
  struct stmtlist* stmtlist;
};

%token <num> NUM
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

%type <expr> expr
%type <stmtlist> stmtlist
%type <stmt> stmt
%type <stmt> inputstmt
%type <stmt> assignstmt

%%

program: stmtlist
{
  program.body = $1->head;
}

stmtlist:
  stmt
{
  $$ = (struct stmtlist*)malloc(sizeof(struct stmtlist));
  $$->head = $$->tail = $1;
  printf("new stmt node: %p\n",$1);
}
| stmtlist stmt
{
  $$ = $1;
  printf("new stmt node: %p\n",$2);
  $$->tail->next = $2;
  $$->tail = $2;
}

stmt:
  assignstmt
{
  $$ = $1;
}
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
    | NUM {
      $$ = (struct exprnode*)malloc(sizeof(struct exprnode));
      $$->val.num = $1;
      $$->type = NUM_t;
      $$->next = NULL;
    }
    | ID {
      $$ = (struct exprnode*)malloc(sizeof(struct exprnode));
      $$->val.id = $1;
      $$->type = ID_t;
      $$->next = NULL;
    }

assignstmt: ID ASSIGN expr
{
  $$ = (struct stmtnode*)malloc(sizeof(struct stmtnode));
  $$->type = ASSIGN_t;
  $$->next = NULL;

  // Get LHS of ASSIGN
  $$->expr = (struct exprnode*)malloc(sizeof(struct exprnode));
  $$->expr->val.id = $1;

  // Get RHS of ASSIGN
  $$->expr->next = $3;
}

ifstmt: IF LPAREN expr RPAREN
           LBRACE stmtlist RBRACE

whilestmt: WHILE LPAREN expr RPAREN
             LBRACE stmtlist RBRACE

inputstmt: INPUT ID
{
  $$ = (struct stmtnode*)malloc(sizeof(struct stmtnode));
  $$->type = INPUT_t;

  $$->expr = (struct exprnode*)malloc(sizeof(struct exprnode));
  $$->expr->type = ID_t;
  $$->expr->val.id = $2;
  $$->expr->left = NULL;
  $$->expr->next = NULL;

  $$->body = NULL;
  $$->next = NULL;

  if( symTable[$2-'a']==NULL)
  {
    symTable[$2-'a'] = (struct symTableEntry*)malloc(
                 sizeof(struct symTableEntry)       );
  }
  symTable[$2-'a']->hasVal = 0;
}

%%

int main()
{
  symTable = (struct symTableEntry**)malloc(
    26*sizeof(struct symTableEntry*)       );

  int i;
  for( i=0; i<26; i++)
  {
    symTable[i] = NULL;
  }

  yyparse();

  genCode( program.body);

  freeStmtNode( &program.body);
  freeSymTable( &symTable);

  return 0;
}

void genCode( struct stmtnode* program)
{
  FILE* fout;
  fout = fopen("a.pep","w+");

  fprintf(fout, "br main\n");
  int numVars = genLocalVars( fout, symTable);
  fprintf(fout, "main: nop0\n");
  fprintf(fout, "subsp %d, i\n", 2*numVars);
  genStatementList( fout, program);
  fprintf(fout, "addsp %d, i\n", 2*numVars);
  fprintf(fout, "stop\n");
  fprintf(fout, ".end\n");

  fclose(fout);
}

int genLocalVars( FILE* fout
                , struct symTableEntry** symTable)
{
  int i;
  int n = 0;
  for( i=0; i<26; i++)
  {
    if( symTable[i]!=NULL)
    {
      fprintf(fout,"%c: .equate %d\n",i+'a',2*n);
      n++;
    }
  }
  return n;
}

void genStatementList( FILE* fout
                     , struct stmtnode* stmtlist)
{
  struct stmtnode* curstmt = stmtlist;
  while( curstmt!=NULL)
  {
    printf("bing\n");
    switch( curstmt->type)
    {
      case INPUT_t:
        printf("input %c\n",curstmt->expr->val.id);
        fprintf( fout
               , "deci %c, s\n"
               , curstmt->expr->val.id);
        break;
      case ASSIGN_t:
        //printf("ASSIGN_t pending\n");
        genAssignStmt(fout, curstmt);
        break;
      default:
        printf("%s %d -- Unhandled case.", __FILE__, __LINE__);
        break;
    }
    curstmt = curstmt->next;
  }
}

void genAssignStmt(FILE* fout, struct stmtnode* assignStmt)
{
  if( assignStmt->expr->next->type == ID_t)
  {
    char lhsId = assignStmt->expr->val.id;
    char rhsId = assignStmt->expr->next->val.id;
    if( symTable[rhsId-'a'] == NULL)
    {
      printf("Unitialized variable %c used to assign %c\n", rhsId, lhsId);
      return; // TODO: instead cleanup and exit program.
    }
  }
  switch( assignStmt->expr->next->type)
  {
    case NUM_t:
      fprintf( fout
              , "LDA %d, i\nSTA %c, s\n"
              , assignStmt->expr->next->val.num
              , assignStmt->expr->val.id);
      break;
    case ID_t:
      fprintf( fout
              , "LDA %c, s\nSTA %c, s\n"
              , assignStmt->expr->next->val.id
              , assignStmt->expr->val.id);
      break;
    default:
        printf("%s %d -- Unhandled case.", __FILE__, __LINE__);
      break;

  }
  return;
}


void freeStmtNode( struct stmtnode** stmt)
{
  if( stmt != NULL && (*stmt) != NULL)
  {
    freeStmtNode( &(*stmt)->next);
    freeStmtNode( &(*stmt)->body);
    freeExprNode( &(*stmt)->expr);

    free(*stmt);
    *stmt = NULL;
  }
}

void freeExprNode( struct exprnode** expr)
{
  if( expr != NULL && (*expr) != NULL)
  {
    freeExprNode( &(*expr)->next);
    freeExprNode( &(*expr)->left);

    free(*expr);
    *expr = NULL;
  }
}

void freeSymTable( struct symTableEntry*** symTable)
{
  if( symTable != NULL && (*symTable) != NULL)
  {
    for( int i=0; i<26; ++i)
    {
      if( (*symTable)[i] != NULL)
      {
        free((*symTable)[i]);
        (*symTable)[i] = NULL;
      }
    }

    free(*symTable);
    *symTable = NULL;
  }
}
