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

int parser_error_count = 0;
extern int lexer_error_count;

void yyerror(const char *s) {

    static int last_error_line = -1;
    static char last_text[MAX_IDENTIFIER_LENGTH] = "";
    
    // Check if the error location is the same as the last error
    if (yylineno == last_error_line && strcmp(last_text, yytext) == 0) {
        // Skip printing the error message if it's for the same location
        return;
    } 

    if (strcmp(s, "syntax error") == 0) {
       fprintf(stderr, ANSI_COLOR_RED "Parser error at line %d at token \"%s\": syntax error\n" ANSI_COLOR_RESET, yylineno, yytext);
    } else {
        fprintf(stderr, ANSI_COLOR_RED "Parser error at line %d near token \"%s\": %s\n" ANSI_COLOR_RESET, yylineno, yytext, s);
    }

    last_error_line = yylineno;
    parser_error_count++;
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

block : constDecl varDecl procDecl funcDecl statement

constDecl : CONST constAssignmentList SEMICOLON
          | /* empty */

constAssignmentList : IDENTIFIER EQ NUMBER
                    | constAssignmentList COMMA IDENTIFIER EQ NUMBER
                    | error { yyerror("invalid constant assigment list"); yyclearin; }

varDecl : VAR identifierList SEMICOLON varDecl
        | VAR arrayDecl SEMICOLON varDecl
        | /* empty */
        | error identifierList SEMICOLON { yyerror("invalid statement"); }
        | error arrayDecl SEMICOLON { yyerror("invalid statement"); }

identifierList : IDENTIFIER
                | identifierList COMMA IDENTIFIER

arrayDecl : IDENTIFIER LBRACKET NUMBER RBRACKET
           | IDENTIFIER LBRACKET error RBRACKET { yyerror("invalid array declaration"); }

procDecl : PROCEDURE IDENTIFIER SEMICOLON block SEMICOLON procDecl
         | /* empty */

funcDecl : FUNCTION IDENTIFIER LPAREN paramList RPAREN SEMICOLON block SEMICOLON funcDecl
         | /* empty */

paramList : paramDecl
           | paramList COMMA paramDecl
           | /* empty */

paramDecl : VAR IDENTIFIER

statementList : statement
              | statementList SEMICOLON statement
              | error SEMICOLON statement { yyerror("invalid statement"); yyclearin; }

statement : matched_statement
           | unmatched_statement
           | IF error THEN { yyerror("invalid if statement"); yyclearin; } statement
           | WHILE error DO { yyerror("invalid while loop statement"); yyclearin;  } statement
           | FOR error DO { yyerror("invalid for loop statement"); yyclearin; } statement

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

readWriteStmt : readStmt
              | writeStmt
              | writeLineStmt

readStmt : READ LPAREN IDENTIFIER RPAREN
         | READ error RPAREN { yyerror("invalid read statement"); yyclearin; }

writeStmt : WRITE LPAREN IDENTIFIER RPAREN
          | WRITE error RPAREN { yyerror("invalid write statement"); yyclearin; }

writeLineStmt : WRITELINE LPAREN IDENTIFIER RPAREN
          | WRITELINE error RPAREN { yyerror("invalid writeline statement"); yyclearin; }

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

funcCall : IDENTIFIER LPAREN argList RPAREN

argList : expression
         | argList COMMA expression
         | /* empty */

term : factor
      | term MUL factor
      | term DIV factor
      | term MOD factor

factor : IDENTIFIER
        | NUMBER
        | LPAREN expression RPAREN
        | arrayIndex
        | funcCall

arrayIndex : IDENTIFIER LBRACKET expression RBRACKET
        
%%

int main() {
    printf(ANSI_COLOR_GREEN "Parsing begins..." ANSI_COLOR_RESET);
    printf("\n line %d: ", yylineno);
    yyparse();
    printf(ANSI_COLOR_GREEN "\nParsing completed.\n" ANSI_COLOR_RESET);
   
   // Print parser error count in green if zero, otherwise in red
    if (parser_error_count == 0) {
        printf(ANSI_COLOR_GREEN "Parser (syntax) errors: %d\n" ANSI_COLOR_RESET, parser_error_count);
    } else {
        printf(ANSI_COLOR_RED "Parser (syntax) errors: %d\n" ANSI_COLOR_RESET, parser_error_count);
    }

    // Print lexer error count in green if zero, otherwise in red
    if (lexer_error_count == 0) {
        printf(ANSI_COLOR_GREEN "Lexer (lexical) errors: %d\n" ANSI_COLOR_RESET, lexer_error_count);
    } else {
        printf(ANSI_COLOR_RED "Lexer (lexical) errors: %d\n" ANSI_COLOR_RESET, lexer_error_count);
    }
    
    return 0;
}
