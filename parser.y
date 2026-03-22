%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);
extern int yylineno;
extern char *yytext;

void yyerror(const char *s);
%}

%define parse.error verbose

%token VAR BEGIN_KW END_KW IDENT NUMBER EOL

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

program
    : declaration_line begin_line assignment_lines end_line
      {
          printf("Синтаксис корректен\n");
      }
    ;

declaration_line
    : VAR var_list EOL
    ;

begin_line
    : BEGIN_KW EOL
    ;

end_line
    : END_KW '.'
    | END_KW '.' EOL
    ;

assignment_lines
    : assignment_line
    | assignment_line assignment_lines
    ;

assignment_line
    : assignment EOL
    ;

assignment
    : IDENT '=' expression
    ;

var_list
    : IDENT
    | IDENT ',' var_list
    ;

expression
    : '-' subexpression %prec UMINUS
    | subexpression
    ;

subexpression
    : '(' expression ')'
    | operand
    | subexpression '+' subexpression
    | subexpression '-' subexpression
    | subexpression '*' subexpression
    | subexpression '/' subexpression
    ;

operand
    : IDENT
    | NUMBER
    ;

%%

void yyerror(const char *s) {
    printf("Синтаксическая ошибка в строке %d возле '%s': %s\n",
           yylineno, yytext, s);
}

int main(void) {
    return yyparse();
}
