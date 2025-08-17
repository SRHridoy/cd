%{
#include<stdio.h>
int isCompound = 0;
%}

%%
and|or|but|so|because|if|then|yet|nevertheless      {isCompound = 1;}
.                                                   {/*Ignore*/}
\n                                                  {return 0;}
%%

int main(){
    printf("Enter the string : ");
    yylex();

    if(isCompound)
        printf("The statement is Compound. \n");
    else
        printf("The statement is Simple. \n");
}

int yywrap(){
    return 1;
}