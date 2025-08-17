%{
#include <stdio.h>
int commentLines = 0;
%}

%%
"//".*              { commentLines++; }
"/*"                { 
                      int c;
                      commentLines++; 
                      while((c = input()) != 0) {
                        if(c == '\n') commentLines++;
                        if(c == '*') {
                          if((c = input()) == '/') break;
                          else unput(c);
                        }
                      }
                    }
.|\n                {/*ignore*/}
%%

int main() {
    printf("Enter C program (Ctrl+D to end input):\n");
    yylex();
    printf("Total Comment Lines: %d\n", commentLines);
    return 0;
}

int yywrap() {
    return 1;
}