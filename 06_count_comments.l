%{
#include <stdio.h>
int commentLines = 0;
%}

%%
"//".*               { commentLines++; } // single-line comment
"/\\*([^*]*\\*+([^/*][^*]*\\*+)*)/" {
    // multi-line comment
    for(int i=0; yytext[i]; i++)
        if(yytext[i]=='\n') commentLines++;
    commentLines++; // count the first line
}
[ \t\n]+             ;   // whitespace ignore
.                    ;   // ignore other characters
%%

int main() {
    printf("Enter C program (Ctrl+D to end input):\n");
    yylex();
    printf("Total Comment Lines: %d\n", commentLines);
    return 0;
}

int yywrap(void) {
    return 1;
}
