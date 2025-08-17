%{
#include<stdio.h>
int lineCnt = 0, spaceCnt = 0, wordCnt = 0, charCnt = 0;
%}

%%
[\n]            {lineCnt++; charCnt += yyleng;}
[ \t]           {spaceCnt++; charCnt += yyleng;}
[^\t\n]+        {wordCnt++; charCnt += yyleng;}
%%

int main(){
    printf("Enter the string: ");
    yylex();

    printf("\nNo. of Words are : %d\n", wordCnt);
    printf("No. of Spaces are : %d\n", spaceCnt);
    printf("No. of Lines are : %d\n", lineCnt);
}

int yywrap(){
    return 1;
}