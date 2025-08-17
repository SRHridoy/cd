%{
#include <stdio.h>
%}

%%
[a-zA-Z][a-zA-Z0-9]*   { printf("Identifier: %s\n", yytext); }
[0-9]+                  { printf("Number: %s\n", yytext); }
[+\-*/=]                { printf("Operator: %s\n", yytext); }
[ \t\n]+                ;   // ignore whitespace
.                       { printf("Unknown: %s\n", yytext); }
%%

int main() {
    printf("Enter arithmetic expression:\n");
    yylex();
    return 0;
}

int yywrap() { return 1; }
