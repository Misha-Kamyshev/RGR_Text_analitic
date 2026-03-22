%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);
extern int yylineno;
extern FILE *yyin;
%}

%union {
    int num;
    char *str;
}

%token <str> IDENTIFIER
%token <num> NUMBER

%token INT IF WHILE
%token ASSIGN PLUS MINUS MUL DIV
%token EQ NEQ LT GT LE GE
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON

%left EQ NEQ LT GT LE GE
%left PLUS MINUS
%left MUL DIV

%%
program
    : statement_list
    ;

statement_list
    : %empty
    | statement_list statement
    ;

statement
    : declaration SEMICOLON
    | assignment SEMICOLON
    | if_statement
    | while_statement
    | block
    ;

block
    : LBRACE statement_list RBRACE
    ;

declaration
    : INT IDENTIFIER
      {
          free($2);
      }
    | INT IDENTIFIER ASSIGN expression
      {
          free($2);
      }
    ;

assignment
    : IDENTIFIER ASSIGN expression
      {
          free($1);
      }
    ;

if_statement
    : IF LPAREN expression RPAREN statement
    ;

while_statement
    : WHILE LPAREN expression RPAREN statement
    ;

expression
    : expression PLUS expression
    | expression MINUS expression
    | expression MUL expression
    | expression DIV expression
    | expression EQ expression
    | expression NEQ expression
    | expression LT expression
    | expression GT expression
    | expression LE expression
    | expression GE expression
    | LPAREN expression RPAREN
    | IDENTIFIER
      {
          free($1);
      }
    | NUMBER
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Синтаксическая ошибка на строке %d: %s\n", yylineno, s);
}

int main(void) {
    yyin = fopen("input.txt", "r");
    if (!yyin) {
        perror("Не удалось открыть input.txt");
        return EXIT_FAILURE;
    }

    int result = yyparse();
    fclose(yyin);

    if (result == 0) {
        printf("Синтаксис корректен.\n");
        return EXIT_SUCCESS;
    }

    return EXIT_FAILURE;
}
