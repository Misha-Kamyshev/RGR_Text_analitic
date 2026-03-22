%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

LETTER      [a-zA-Z]
DIGIT       [0-9]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
NUMBER      {DIGIT}+

%%

"Var"       { return VAR; }
"Begin"     { return BEGIN_KW; }
"End"       { return END_KW; }

{IDENTIFIER} { return IDENT; }
{NUMBER}     { return NUMBER; }

"="         { return '='; }
","         { return ','; }
"("         { return '('; }
")"         { return ')'; }
"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"."         { return '.'; }

[ \t\r]+    { }
\n+         { yylineno += yyleng; return EOL; }

. {
    printf("Лексическая ошибка в строке %d: неизвестный символ '%s'\n", yylineno, yytext);
    exit(1);
}

%%

int yywrap(void) {
    return 1;
}
