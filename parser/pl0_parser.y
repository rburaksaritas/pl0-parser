%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYSTYPE_IS_DECLARED
#define YYSTYPE struct _tagYYSTYPE

#include "pl0_lexer.tab.h"

extern int yylex();
extern int yylineno;
extern char* yytext;

int yyparse();

void yyerror(const char *s) {
    fprintf(stderr, "Parser error at line %d: %s\n", yylineno, s);
}

typedef struct {
    char* identifier;
    int num;
} YYSTYPE;

#define MAX_IDENTIFIER_LENGTH 50

%}

%token <str> IDENTIFIER
%token <num> NUMBER

%token CONST VAR PROCEDURE FUNCTION BEGIN END CALL IF THEN ELSE WHILE DO FOR BREAK READ WRITE WRITELINE RETURN ODD TO
%token EQ NE LT GT LE GE LPAREN RPAREN LBRACKET RBRACKET COMMA SEMICOLON ASSIGN ADD SUB MUL DIV MOD

%left ADD SUB
%left MUL DIV MOD
%left EQ NE LT GT LE GE
%nonassoc UMINUS
%nonassoc THEN
%nonassoc ELSE

%%

program : block '.' 
        | error '.' { fprintf(stderr, "Syntax error in program\n"); exit(1); }

block : constDecl varDecl procDecl funcDecl statementList

constDecl : CONST constAssignmentList SEMICOLON
          | /* empty */

constAssignmentList : IDENTIFIER ASSIGN NUMBER
                    | constAssignmentList COMMA IDENTIFIER ASSIGN NUMBER

varDecl : VAR identifierList SEMICOLON
        | VAR arrayDecl SEMICOLON
        | /* empty */

identifierList : IDENTIFIER
               | identifierList COMMA IDENTIFIER

arrayDecl : IDENTIFIER LBRACKET NUMBER RBRACKET

procDecl : PROCEDURE IDENTIFIER SEMICOLON block SEMICOLON
         | /* empty */

funcDecl : FUNCTION IDENTIFIER LPAREN paramList RPAREN SEMICOLON block SEMICOLON
         | /* empty */

paramList : paramDecl
          | paramList COMMA paramDecl
          | /* empty */

paramDecl : VAR IDENTIFIER

statementList : statement SEMICOLON
              | statementList statement SEMICOLON

statement : matched_stmt
          | unmatched_stmt;

matched_stmt : IF condition THEN statement ELSE matched_stmt
             | non_if_stmt;

unmatched_stmt : IF condition THEN matched_stmt
               | IF condition THEN unmatched_stmt ELSE matched_stmt;

non_if_stmt : IDENTIFIER ASSIGN expression
            | CALL IDENTIFIER
            | BEGIN statementList END
            | WHILE condition DO statement
            | FOR IDENTIFIER ASSIGN expression TO expression DO statement
            | BREAK
            | arrayAssignment
            | funcCall
            | readWriteStmt;

arrayAssignment : IDENTIFIER LBRACKET expression RBRACKET ASSIGN expression

funcCall : IDENTIFIER LPAREN argList RPAREN

readWriteStmt : readStmt
              | writeStmt
              | writeLineStmt

readStmt : READ LPAREN IDENTIFIER RPAREN

writeStmt : WRITE LPAREN expression RPAREN

writeLineStmt : WRITELINE LPAREN expression RPAREN

condition : ODD expression
          | expression EQ expression
          | expression NE expression
          | expression LT expression
          | expression GT expression
          | expression LE expression
          | expression GE expression

expression : term
           | expression ADD term
           | expression SUB term

term : factor
     | term MUL factor
     | term DIV factor
     | term MOD factor

factor : IDENTIFIER
       | NUMBER
       | LPAREN expression RPAREN
       | arrayIndex

arrayIndex : IDENTIFIER LBRACKET expression RBRACKET

argList : expression
        | argList COMMA expression
        | /* empty */

%%

int main() {
    yyparse();
    return 0;
}
