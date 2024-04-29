%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char* yytext;

int yyparse();

void yyerror(const char *s) {
    fprintf(stderr, "Parser error at line %d near %s: %s\n", yylineno, yytext, s);
}

#define MAX_IDENTIFIER_LENGTH 50

%}

%union {
    int num;     
    char* str;   
}

%token <str> IDENTIFIER
%token <num> NUMBER

%token CONST VAR PROCEDURE FUNCTION T_BEGIN T_END CALL IF THEN ELSE WHILE DO FOR BREAK READ WRITE WRITELINE RETURN ODD TO DOT
%token EQ NE LT GT LE GE LPAREN RPAREN LBRACKET RBRACKET COMMA SEMICOLON ASSIGN ADD SUB MUL DIV MOD

%left ADD SUB
%left MUL DIV MOD
%left EQ NE LT GT LE GE
%nonassoc UMINUS
%nonassoc THEN
%nonassoc ELSE

%%

program : block DOT
        
block : constDecl varDecl procDecl funcDecl statement

constDecl : CONST constAssignmentList SEMICOLON
          | /* empty */

constAssignmentList : IDENTIFIER EQ NUMBER
                    | constAssignmentList COMMA IDENTIFIER ASSIGN NUMBER
                    | error { yyerror("Invalid constant declaration"); }
                    
varDecl : VAR identifierList SEMICOLON varDecl
        | VAR arrayDecl SEMICOLON varDecl
        | /* empty */
        | error { yyerror("Invalid variable declaration"); }

identifierList : IDENTIFIER
               | identifierList COMMA IDENTIFIER
               | error { yyerror("Invalid identifier list"); }

arrayDecl : IDENTIFIER LBRACKET NUMBER RBRACKET

procDecl : procDecl PROCEDURE IDENTIFIER SEMICOLON block SEMICOLON
         | /* empty */

funcDecl : funcDecl FUNCTION IDENTIFIER LPAREN paramList RPAREN SEMICOLON block SEMICOLON
         | /* empty */

paramList : paramDecl
          | paramList COMMA paramDecl
          | /* empty */

paramDecl : VAR IDENTIFIER
          | error { yyerror("Invalid parameter declaration"); }

statementList : statement
              | statementList SEMICOLON statement
              | error { yyerror("Invalid statement list"); }

statement : matched_statement
          | unmatched_statement

matched_statement : IF condition THEN matched_statement ELSE matched_statement
                  | non_if_statement
                  | WHILE condition DO matched_statement
                  | FOR IDENTIFIER ASSIGN expression TO expression DO matched_statement

unmatched_statement : IF condition THEN statement
                    | IF condition THEN matched_statement ELSE unmatched_statement
                    | WHILE condition DO unmatched_statement
                    | FOR IDENTIFIER ASSIGN expression TO expression DO unmatched_statement

non_if_statement : IDENTIFIER ASSIGN expression
                 | CALL IDENTIFIER
                 | T_BEGIN statementList T_END
                 | BREAK
                 | arrayAssignment
                 | funcCall
                 | readWriteStmt
                 | RETURN expression
                 | RETURN
                 | /* empty */

arrayAssignment : IDENTIFIER LBRACKET expression RBRACKET ASSIGN expression

funcCall : IDENTIFIER LPAREN argList RPAREN

readWriteStmt : readStmt
              | writeStmt
              | writeLineStmt

readStmt : READ LPAREN IDENTIFIER RPAREN

writeStmt : WRITE LPAREN IDENTIFIER RPAREN

writeLineStmt : WRITELINE LPAREN IDENTIFIER RPAREN

condition : ODD expression
          | expression EQ expression
          | expression NE expression
          | expression LT expression
          | expression GT expression
          | expression LE expression
          | expression GE expression

expression : term|ADD term|SUB term
           | expression ADD term
           | expression SUB term
           | UMINUS expression %prec UMINUS
           | funcCall

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
    printf("Parsing begins...\n");
    yyparse();
    printf("Parsing complete.\n");
    return 0;
}
