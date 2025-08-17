%{
#include <stdio.h>
int num1, num2;
char op;
%}

%%
[0-9]+      { if(num1==0) num1 = atoi(yytext); else num2 = atoi(yytext); }
[+\-*/]     { op = yytext[0]; }
[ \t\n]+    ;   // ignore whitespace
.           { printf("Unknown character: %s\n", yytext); }
%%

int main() {
    printf("Enter expression (e.g., 12 + 5): ");
    yylex();

    switch(op){
        case '+': printf("Result: %d\n", num1+num2); break;
        case '-': printf("Result: %d\n", num1-num2); break;
        case '*': printf("Result: %d\n", num1*num2); break;
        case '/': if(num2!=0) printf("Result: %d\n", num1/num2); 
        else printf("Division by zero error\n");     break;
        default: printf("Invalid operator\n");
    }

    return 0;
}

int yywrap(){ return 1; }
