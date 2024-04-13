%{
#include <stdio.h>
#include <stdlib.h>
#include "pl0.tab.h"

void yyerror(const char *s);
int yylex(void);
extern int yylineno; // Current line number

void init_symbol_table(); 
int get_array_value(const char *id, int index);
int* lookup(const char *id);  
%}

%token CONST VAR PROCEDURE FUNCTION IF THEN ELSE WHILE DO CALL BEGIN END RETURN BREAK FOR TO READ WRITE WRITELINE ODD
%token <num> NUMBER
%token <id> IDENTIFIER
%token PLUS MINUS TIMES DIVIDE MOD ASSIGN SEMICOLON COMMA DOT LBRACKET RBRACKET LPAREN RPAREN EQ NEQ LT GT LE GE

%type <num> Expression Term Factor ArrayAccess
%type <stmt> Statement StatementList Block
%type <id> IdentifierList
%type <exprs> ArgList

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
    /* Empty */ { $$ = 0; }
    | CONST ConstAssignmentList SEMICOLON { $$ = 0; }
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

ArrayDecl:
    VAR IDENTIFIER LBRACKET NUMBER RBRACKET SEMICOLON
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

ParamList:
    /* Empty */
    | IDENTIFIER
    | ParamList COMMA IDENTIFIER
    ;

Statement:
    IDENTIFIER ASSIGN Expression { $$ = $3; }
    | CALL IDENTIFIER LPAREN ArgList RPAREN { $$ = 0; } // no value returned from a call
    | BEGIN StatementList END    { $$ = $2; }
    | IF Condition THEN Statement ELSE Statement { $$ = $6; }
    | WHILE Condition DO Statement { $$ = $4; }
    | FOR IDENTIFIER ASSIGN Expression TO Expression DO Statement { $$ = $8; }
    | RETURN Expression SEMICOLON { $$ = $2; }
    | READ LPAREN IDENTIFIER RPAREN { $$ = 0; } // read modifies the identifier directly
    | WRITE LPAREN IDENTIFIER RPAREN { $$ = 0; } // write outputs the identifier's value
    | WRITELINE LPAREN IDENTIFIER RPAREN { $$ = 0; } // writeline outputs the identifier's value
    | /* Empty */ { $$ = 0; }
    ;

StatementList:
    Statement
    | StatementList SEMICOLON Statement { $$ = $3; }
    ;

Expression:
    Term { $$ = $1; }
    | Expression PLUS Term { $$ = $1 + $3; }
    | Expression MINUS Term { $$ = $1 - $3; }
    | ArrayAccess
    ;

Term:
    Factor { $$ = $1; }
    | Term TIMES Factor { $$ = $1 * $3; }
    | Term DIVIDE Factor { $$ = $1 / $3; }
    | Term MOD Factor { $$ = $1 % $3; }
    ;

Factor:
    NUMBER { $$ = $1; }
    | IDENTIFIER { $$ = *lookup($1); } // dereference the pointer to get the value
    | LPAREN Expression RPAREN { $$ = $2; }
    | IDENTIFIER LPAREN ArgList RPAREN { $$ = call_function($1, $3); } // function returns an int
    | ArrayAccess
    ;

ArrayAccess:
    IDENTIFIER LBRACKET Expression RBRACKET { $$ = get_array_value($1, $3); }
    ;

Condition:
    ODD Expression { $$ = $2 % 2 != 0; }
    | Expression EQ Expression { $$ = $1 == $3; }
    | Expression NEQ Expression { $$ = $1 != $3; }
    | Expression LT Expression { $$ = $1 < $3; }
    | Expression LE Expression { $$ = $1 <= $3; }
    | Expression GT Expression { $$ = $1 > $3; }
    | Expression GE Expression { $$ = $1 >= $3; }
    ;

ArgList:
    Expression { $$ = create_arg_list($1); }
    | ArgList COMMA Expression { $$ = add_to_arg_list($1, $3); }
    ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d\n", s, yylineno);
}

int main(void) {
    init_symbol_table();
    printf("Starting parser...\n");
    if (yyparse() == 0) { // returns 0 if parsing is successful
        printf("Parsing complete!\n");
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}
