%{
#include<stdio.h>
%}

%%
if|else|while|for|return|int|float|double {printf("Keyword: %s\n", yytext);}
[0-9]+                   {printf("Number : %s\n", yytext);}
[a-zA-Z]+                {printf("Word : %s\n",yytext);}
.|\t\n                   {/*Skip newline and other chars*/}
%%

int main(){
    printf("Enter the string: ");
    yylex();
}

int yywrap(){
    return 1;
}