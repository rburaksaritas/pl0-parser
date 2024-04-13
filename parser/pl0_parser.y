%{
#include <stdio.h>
#include <stdlib.h>
#include "pl0.tab.h"

void yyerror(const char *s);
int yylex(void);
extern int yylineno; // current line number
%}

%token CONST VAR PROCEDURE FUNCTION IF THEN ELSE WHILE DO CALL BEGIN END RETURN BREAK FOR TO READ WRITE WRITELINE ODD
%token <num> NUMBER
%token <id> IDENTIFIER
%token MOD

%type <num> Expression Term Factor
%type <stmt> Statement StatementList Block
%type <id> IdentifierList ArrayAccess

%left '-' '+'
%left '*' '/' 'MOD'
%left ASSIGN
%right ELSE

%%
Program:
    Block '.'
    ;

Block:
    ConstDecl VarDecl ProcDecl FuncDecl Statement
    ;

ConstDecl:
    /* Empty */
    | CONST ConstAssignmentList ';'
    ;

ConstAssignmentList:
    IDENTIFIER '=' NUMBER
    | ConstAssignmentList ',' IDENTIFIER '=' NUMBER
    ;

VarDecl:
    /* Empty */
    | VAR IdentifierList ';'
    | ArrayDecl
    ;

IdentifierList:
    IDENTIFIER
    | IdentifierList ',' IDENTIFIER
    ;

ProcDecl:
    /* Empty */
    | PROCEDURE IDENTIFIER ';' Block ';' ProcDecl
    ;

FuncDecl:
    /* Empty */
    | FUNCTION IDENTIFIER '(' ParamList ')' ';' Block ';' FuncDecl
    ;

Statement:
    IDENTIFIER ASSIGN Expression
    | CALL IDENTIFIER
    | BEGIN StatementList END
    | IF Condition THEN Statement ELSE Statement
    | WHILE Condition DO Statement
    | FOR IDENTIFIER ASSIGN Expression TO Expression DO Statement
    | RETURN Expression ';'
    | READ '(' Expression ')'
    | WRITE '(' Expression ')'
    | WRITELINE '(' Expression ')'
    | /* Empty */
    ;

StatementList:
    Statement
    | StatementList ';' Statement
    ;

Expression:
    Term
    | Expression '+' Term
    | Expression '-' Term
    ;

Term:
    Factor
    | Term '*' Factor
    | Term '/' Factor
    | Term 'MOD' Factor
    ;

Factor:
    NUMBER
    | IDENTIFIER
    | IDENTIFIER '(' ArgList ')'
    | '(' Expression ')'
    ;

Condition:
    ODD Expression
    | Expression '=' Expression
    | Expression '<>' Expression
    ;

ArgList:
    Expression
    | ArgList ',' Expression
    ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d\n", s, yylineno);
}

int main(void) {
    printf("Starting parser...\n");
    if (yyparse() == 0) { // returns 0 if parsing is successful
        printf("Parsing complete!\n");
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}
