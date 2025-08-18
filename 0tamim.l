%{
int single_comment_count = 0;
int multi_comment_count = 0;
%}

%%

"//".*                { single_comment_count++; }
"/*"([^*]|\*+[^*/])*\*+"/"   { multi_comment_count++; }

.|\n                   { /* Ignore other characters */ }

%%

int main(void) {
    yylex();
    printf("Single-line comments: %d\n", single_comment_count);
    printf("Multi-line comments: %d\n", multi_comment_count);
    printf("Total Comments : %d\n",single_comment_count+multi_comment_count);
    return 0;
}

int yywrap(){
    return 1;

}