/*Lex program to count the number of vowels and consonents*/ 

%{
    #include<stdio.h>
    int v=0, c=0;
%}

%%
[ \t\n]+ ;
[aeiouAEIOU] {v++;}
[^aeiouAEIOU] {c++;}

%%

int main() {
    printf("Enter the string: ");
    yylex();
    printf("\nVowels = %d\nConsonent =%d\n", v, c);
}

int yywrap() {
    return 1;
}