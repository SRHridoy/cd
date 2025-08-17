%{
#include<stdio.h>    
%}

%%
[A-Z]+[ \t\n]           {printf("Capital Word: %s\n",yytext);}
.|\n\t                  {/*Skip other chars*/}
%%

int main(){
    printf("Enter the string : ");
    yylex();
}

int yywrap(){
    return 1;
}