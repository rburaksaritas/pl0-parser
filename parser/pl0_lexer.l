%{
#include <stdio.h>
#include "pl0_parser.tab.h"
#define ANSI_COLOR_RED "\x1b[31m"
#define ANSI_COLOR_GREEN "\x1b[32m"
#define ANSI_COLOR_RESET "\x1b[0m"

int read_token(const char* token_name, int token_value) {
    printf("%s", token_name);
    return token_value;
}

int read_number(const char* number_text) {
    printf("%s", number_text);
    yylval.num = atoi(number_text);
    return NUMBER;
}

int read_identifier(const char* identifier_text) {
    printf("%s", identifier_text);
    yylval.str = strdup(identifier_text);
    return IDENTIFIER;
}

int lexer_error_count = 0;
%}

%%

"const"                 { return read_token("const", CONST); }
"var"                   { return read_token("var", VAR); }
"procedure"             { return read_token("procedure", PROCEDURE); }
"function"              { return read_token("function", FUNCTION); }
"begin"                 { return read_token("begin", T_BEGIN); }
"end"                   { return read_token("end", T_END); }
"call"                  { return read_token("call", CALL); }
"if"                    { return read_token("if", IF); }
"then"                  { return read_token("then", THEN); }
"else"                  { return read_token("else", ELSE); }
"while"                 { return read_token("while", WHILE); }
"do"                    { return read_token("do", DO); }
"for"                   { return read_token("for", FOR); }
"break"                 { return read_token("break", BREAK); }
"read"                  { return read_token("read", READ); }
"write"                 { return read_token("write", WRITE); }
"writeline"             { return read_token("writeline", WRITELINE); }
"return"                { return read_token("return", RETURN); }
"odd"                   { return read_token("odd", ODD); }
"to"			        { return read_token("to", TO); }
"="                     { return read_token("=", EQ); }
"<>"                    { return read_token("<>", NE); }
"<"                     { return read_token("<", LT); }
">"                     { return read_token(">", GT); }
"<="                    { return read_token("<=", LE); }
">="                    { return read_token(">=", GE); }
"("                     { return read_token("(", LPAREN); }
")"                     { return read_token(")", RPAREN); }
"["                     { return read_token("[", LBRACKET); }
"]"                     { return read_token("]", RBRACKET); }
","                     { return read_token(",", COMMA); }
";"                     { return read_token(";", SEMICOLON); }
":="                    { return read_token(":=", ASSIGN); }
"+"                     { return read_token("+", ADD); }
"-"                     { return read_token("-", SUB); }
"*"                     { return read_token("*", MUL); }
"/"                     { return read_token("/", DIV); }
"%"                     { return read_token("%", MOD); }
"."			            { return read_token(".", DOT); }
[0-9]+                  { return read_number(yytext); }
[a-zA-Z][a-zA-Z0-9_]*   { return read_identifier(yytext); }
"/*"([^*]|\*+[^*/])*"*"+"/" { /* ignore comments */ }

[ \t\r]+               { printf("%s", yytext); /* ignore whitespace */ }
\n                     { ++yylineno; printf("\n line %d: ", yylineno); /* increment line number on new line */ }
.                      { printf("%s", yytext); lexer_error_count++; fprintf(stderr, ANSI_COLOR_RED "Lexer Error at line %d: invalid character %s\n" ANSI_COLOR_RESET, yylineno, yytext); }
%%

int yywrap() {
    return 1;
}
