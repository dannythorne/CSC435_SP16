%option noyywrap
%{
#include <stdio.h>
// comments can go here
%}
%%

"if"      { printf(" IF");}
"print"   { printf(" PRINT");}

"("     { printf(" LPAREN");}
")"     { printf(" RPAREN");}
"{"     { printf(" LBRACE");}
"}"     { printf(" RBRACE");}
"="     { printf(" ASSIGN");}
"<"     { printf(" LT");}
";"     { printf(" SEMI");}

 [ ]*   { printf(" SP");}

[0-9][0-9]* { printf(" INT");}

[a-zA-Z][a-zA-Z0-9]* { printf(" ID");}

\"[a-zA-Z0-9]*\" {printf(" STRING_LITERAL");}

. { printf(" SOMETHING_ELSE");}

%%

// comments can go here

int main()
{
  yylex();
  return 0;
}
