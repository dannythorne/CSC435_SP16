
%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
extern char* yytext;
void yyerror( const char* msg)
{
  printf("ERROR: %s %s\n", msg, yytext);
}

struct symTableNode
{
  int val;
};

struct symTableNode* symTable[26];

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

%type <num> expr

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
        printf("%d\n",$1);
      }
    | assignstmt
      {
        printf("assignstmt\n");
      }

expr: expr ADD expr
      {
        printf("expr ADD expr\n");
        $$ = $1 + $3;
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
        $$ = $1;
      }
    | ID
      {
        printf("ID\n");
        if( symTable[$1-'a']!=NULL)
        {
          $$ = symTable[$1-'a']->val;
        }
        else
        {
          printf("Error: "
          "'%c' undeclared.\n",$1);
          exit(1);
        }
      }
assignstmt: ID ASSIGN expr
      {
        printf("ID ASSIGN expr\n");
        if( symTable[$1-'a']==NULL)
        {
          symTable[$1-'a']
          =
          (struct symTableNode*)malloc(sizeof(struct symTableNode));
        }
        symTable[$1-'a']->val = $3;
      }

%%

int main()
{
  int i;
  for( i=0; i<26; i++)
  {
    symTable[i] = NULL;
  }

  yyparse();

  for( i=0; i<26; i++)
  {
    if( symTable[i]!=NULL)
    {
      printf("symTable[%2d] = %d\n"
            ,i
            ,symTable[i]->val);
    }
    else
    {
      printf("symTable[%2d] = NULL\n",i);
    }
  }

  return 0;
}
