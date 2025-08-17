%{
#include<stdio.h>
int vCnt=0, cCnt=0;    
%}

%%
[ \t\n]+                 {/*Ignore*/}
[aeiouAEIOU]             { vCnt++; }
[^aeiouAEIOU]            { cCnt++; }                    
%%

int main() {
    printf("Enter the string : ");
    yylex();

    printf("No. of vowels are : %d \n", vCnt);
    printf("No. of consonants are : %d \n", cCnt);
}

int yywrap(void) {
    return 1;
}

// ctrl + d for end of input...