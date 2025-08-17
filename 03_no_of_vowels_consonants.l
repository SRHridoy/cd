%{
#include<stdio.h>  
int vowelCnt = 0, consonantCnt = 0;  
%}

%%
[ \t\n]+            {/*ignore*/}
[aeiouAEIOU]        {vowelCnt++;}
[a-zA-Z]            {if (!(yytext[0]=='a'||yytext[0]=='e'||yytext[0]=='i'||yytext[0]=='o'||yytext[0]=='u'||yytext[0]=='A'||yytext[0]=='E'||yytext[0]=='I'||yytext[0]=='O'||yytext[0]=='U')) consonantCnt++;}
.                   {/*ignore special symbols*/}
%%

int main(){
    printf("Enter the input: ");
    yylex();
    printf("No. of Vowels : %d\n",vowelCnt);
    printf("No. of Consonants : %d\n",consonantCnt);
}

int yywrap(){
    return 1;
}