%{
#include <stdio.h>
#include "pl0_parser.tab.h"
%}

%%

"const"                 { return CONST; }
"var"                   { return VAR; }
"procedure"             { return PROCEDURE; }
"function"              { return FUNCTION; }
"begin"                 { return BEGIN; }
"end"                   { return END; }
"call"                  { return CALL; }
"if"                    { return IF; }
"then"                  { return THEN; }
"else"                  { return ELSE; }
"while"                 { return WHILE; }
"do"                    { return DO; }
"for"                   { return FOR; }
"break"                 { return BREAK; }
"read"                  { return READ; }
"write"                 { return WRITE; }
"writeline"             { return WRITELINE; }
"return"                { return RETURN; }
"odd"                   { return ODD; }
"="                     { return EQ; }
"<>"                    { return NE; }
"<"                     { return LT; }
">"                     { return GT; }
"<="                    { return LE; }
">="                    { return GE; }
"("                     { return LPAREN; }
")"                     { return RPAREN; }
"["                     { return LBRACKET; }
"]"                     { return RBRACKET; }
","                     { return COMMA; }
";"                     { return SEMICOLON; }
":="                    { return ASSIGN; }
"+"                     { return ADD; }
"-"                     { return SUB; }
"*"                     { return MUL; }
"/"                     { return DIV; }
"%"                     { return MOD; }
[0-9]+                  { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]*    { yylval.str = strdup(yytext); return IDENTIFIER; }
"/*"([^*]|\*+[^*/])*"*"+"/" { /* ignore comments */ }

[ \t\n\r]               { /* ignore whitespace */ }
.                       { fprintf(stderr, "Invalid character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
