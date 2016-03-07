
%{
#include <stdio.h>
int yylex();
void yyerror( const char* msg) { printf("Error: %s\n",msg);}

struct node
{
  char val;
  struct node* next;
};
struct node* asl; // "abstract syntax list"
%}

%union
{
  char ch;
  struct node* aslnode;
};
%token <ch> CH
%type <aslnode> charlist

%%

charlist: CH
          {
            printf("Parser sees a CH [%c].\n",$1);
            $$ = (struct node*)malloc(sizeof(struct node));
            $$->val = $1;
            $$->next = NULL;
            asl = $$;
          }
        | CH charlist
          {
            printf("Parser sees a CH [%c] followed by a charlist.\n",$1);
            $$ = (struct node*)malloc(sizeof(struct node));
            $$->val  = $1;
            $$->next = $2;
            asl = $$;
          }
        ;

%%

int main()
{
  yyparse();

  printf("asl = %p\n",asl);

  struct node* cur = asl;

  while( cur!=NULL)
  {
    printf("[%c]",cur->val);
    cur = cur->next;
  }

  return 0;
}
