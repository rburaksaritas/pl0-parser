%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char* yytext;

int yyparse();

#define MAX_IDENTIFIER_LENGTH 50
#define ANSI_COLOR_RED "\x1b[31m"
#define ANSI_COLOR_GREEN "\x1b[32m"
#define ANSI_COLOR_RESET "\x1b[0m"

void yyerror(const char *s) {

    // Skip printing the error message if it's a generic syntax error
    if (strcmp(s, "syntax error") == 0) {
       fprintf(stderr, ANSI_COLOR_RED "Parser error at line %d at token \"%s\": syntax error\n" ANSI_COLOR_RESET, yylineno, yytext);
       return;
    }

    static int last_line = -1;
    static char last_text[MAX_IDENTIFIER_LENGTH] = "";

    // Check if the error location is the same as the last error
    if (yylineno == last_line) {
        // Skip printing the error message if it's for the same location
        return;
    }

    fprintf(stderr, ANSI_COLOR_RED "Parser Error at line %d at token \"%s\": %s\n" ANSI_COLOR_RESET, yylineno, yytext, s);

    // Update the last error location
    last_line = yylineno;
    strncpy(last_text, yytext, MAX_IDENTIFIER_LENGTH);
    last_text[MAX_IDENTIFIER_LENGTH - 1] = '\0';
}

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
        | block { yyerror("unexpected end of file, expected \".\""); }

block : constDecl varDecl procDecl funcDecl statement

constDecl : CONST constAssignmentList SEMICOLON
          | /* empty */

constAssignmentList : IDENTIFIER EQ NUMBER
                    | constAssignmentList COMMA IDENTIFIER EQ NUMBER
                    | error { yyerror("invalid constant declaration"); }
                    
varDecl : VAR identifierList SEMICOLON varDecl
        | VAR arrayDecl SEMICOLON varDecl
        | /* empty */

identifierList : IDENTIFIER
               | identifierList COMMA IDENTIFIER
               | error { yyerror("invalid variable declaration"); }

arrayDecl : IDENTIFIER LBRACKET NUMBER RBRACKET
          | IDENTIFIER LBRACKET error { yyerror("invalid array declaration"); }

procDecl : procDecl PROCEDURE IDENTIFIER SEMICOLON block SEMICOLON
         | /* empty */

funcDecl : funcDecl FUNCTION IDENTIFIER LPAREN paramList RPAREN SEMICOLON block SEMICOLON
         | /* empty */

paramList : paramDecl
          | paramList COMMA paramDecl
          | /* empty */

paramDecl : VAR IDENTIFIER
          | error { yyerror("invalid parameter declaration"); }

statementList : statement
              | statementList SEMICOLON statement

statement : matched_statement
          | unmatched_statement
          | error { yyerror("invalid statement"); }

matched_statement : IF condition THEN matched_statement ELSE matched_statement
                  | non_if_statement
                  | WHILE condition DO matched_statement
                  | FOR IDENTIFIER ASSIGN expression TO expression DO matched_statement
                  | FOR error DO matched_statement { yyerror("invalid for statement"); }

unmatched_statement : IF condition THEN statement
                    | IF condition THEN matched_statement ELSE unmatched_statement
                    | WHILE condition DO unmatched_statement
                    | FOR IDENTIFIER ASSIGN expression TO expression DO unmatched_statement
                    | FOR error DO unmatched_statement { yyerror("invalid for statement"); }

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
         | READ error RPAREN { yyerror("invalid read statement") }

writeStmt : WRITE LPAREN IDENTIFIER RPAREN
          | WRITE error RPAREN { yyerror("invalid write statement") }

writeLineStmt : WRITELINE LPAREN IDENTIFIER RPAREN
          | WRITELINE error RPAREN { yyerror("invalid writeline statement") }

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
    printf(ANSI_COLOR_GREEN "Parsing begins...\n" ANSI_COLOR_RESET);
    printf("\n line %d: ", yylineno);
    yyparse();
    printf(ANSI_COLOR_GREEN "\nParsing completed.\n" ANSI_COLOR_RESET);
    return 0;
}
