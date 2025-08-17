%{
#include <stdio.h>
int lineCnt = 0, spaceCnt = 0, wordCnt = 0, charCnt = 0;
%}

%%
\n              { lineCnt++; charCnt++; }
[ \t]           { spaceCnt++; charCnt++; }
[^ \t\n]+       { wordCnt++; charCnt += yyleng; }
%%

int main() {
    printf("Enter the string (Ctrl+D to end input):\n");
    yylex();

    printf("\nNo. of Words: %d\n", wordCnt);
    printf("No. of Spaces/Tabs: %d\n", spaceCnt);
    printf("No. of Lines: %d\n", lineCnt);
    printf("No. of Characters: %d\n", charCnt);
    return 0;
}

int yywrap() {
    return 1;
}