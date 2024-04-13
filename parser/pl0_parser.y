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
%token PLUS MINUS TIMES DIVIDE MOD ASSIGN SEMICOLON COMMA DOT LBRACKET RBRACKET LPAREN RPAREN EQ NEQ LT GT LE GE

%type <num> Expression Term Factor
%type <stmt> Statement StatementList Block
%type <id> IdentifierList ArrayAccess

%left MINUS PLUS
%left TIMES DIVIDE MOD
%left EQ NEQ LT LE GT GE
%right ASSIGN
%right ELSE

%%
Program:
    Block DOT
    ;

Block:
    ConstDecl VarDecl ProcDecl FuncDecl Statement
    ;

ConstDecl:
    /* Empty */
    | CONST ConstAssignmentList SEMICOLON
    ;

ConstAssignmentList:
    IDENTIFIER ASSIGN NUMBER
    | ConstAssignmentList COMMA IDENTIFIER ASSIGN NUMBER
    ;

VarDecl:
    /* Empty */
    | VAR IdentifierList SEMICOLON
    | ArrayDecl
    ;

IdentifierList:
    IDENTIFIER
    | IdentifierList COMMA IDENTIFIER
    ;

ProcDecl:
    /* Empty */
    | PROCEDURE IDENTIFIER SEMICOLON Block SEMICOLON ProcDecl
    ;

FuncDecl:
    /* Empty */
    | FUNCTION IDENTIFIER LPAREN ParamList RPAREN SEMICOLON Block SEMICOLON FuncDecl
    ;

Statement:
    IDENTIFIER ASSIGN Expression
    | CALL IDENTIFIER
    | BEGIN StatementList END
    | IF Condition THEN Statement ELSE Statement
    | WHILE Condition DO Statement
    | FOR IDENTIFIER ASSIGN Expression TO Expression DO Statement
    | RETURN Expression SEMICOLON
    | READ LPAREN Expression RPAREN
    | WRITE LPAREN Expression RPAREN
    | WRITELINE LPAREN Expression RPAREN
    | /* Empty */
    ;

StatementList:
    Statement
    | StatementList SEMICOLON Statement
    ;

Expression:
    Term
    | Expression PLUS Term
    | Expression MINUS Term
    ;

Term:
    Factor
    | Term TIMES Factor
    | Term DIVIDE Factor
    | Term MOD Factor
    ;

Factor:
    NUMBER
    | IDENTIFIER
    | IDENTIFIER LPAREN ArgList RPAREN
    | LPAREN Expression RPAREN
    ;

Condition:
    ODD Expression
    | Expression EQ Expression
    | Expression NEQ Expression
    | Expression LT Expression
    | Expression LE Expression
    | Expression GT Expression
    | Expression GE Expression
    ;

ArgList:
    Expression
    | ArgList COMMA Expression
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
