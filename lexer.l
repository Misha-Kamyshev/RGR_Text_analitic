%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

void lexical_error(const char *text, int line);
%}

%option noyywrap yylineno

WHITESPACE      [ \t\r]+
IDENTIFIER      [a-zA-Z_][a-zA-Z0-9_]*
NUMBER          [0-9]+

%%
{WHITESPACE}            { /* skip spaces */ }
"\n"                    { /* yylineno incremented automatically */ }

"int"                   { return INT; }
"if"                    { return IF; }
"while"                 { return WHILE; }

{IDENTIFIER}            {
                            yylval.str = strdup(yytext);
                            return IDENTIFIER;
                        }

{NUMBER}                {
                            yylval.num = atoi(yytext);
                            return NUMBER;
                        }

"=="                    { return EQ; }
"!="                    { return NEQ; }
"<="                    { return LE; }
">="                    { return GE; }
"<"                     { return LT; }
">"                     { return GT; }
"="                     { return ASSIGN; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return MUL; }
"/"                     { return DIV; }

"("                     { return LPAREN; }
")"                     { return RPAREN; }
"{"                     { return LBRACE; }
"}"                     { return RBRACE; }
";"                     { return SEMICOLON; }

.                       { lexical_error(yytext, yylineno); }
%%

void lexical_error(const char *text, int line) {
    fprintf(stderr, "Лексическая ошибка: недопустимый символ '%s' на строке %d\n", text, line);
    exit(EXIT_FAILURE);
}
