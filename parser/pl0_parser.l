%{
#include <stdio.h>
#include "pl0_parser.tab.h"
%}

%%

"const"                 { printf("TOKEN: CONST\n"); return CONST; }
"var"                   { printf("TOKEN: VAR\n"); return VAR; }
"procedure"             { printf("TOKEN: PROCEDURE\n"); return PROCEDURE; }
"function"              { printf("TOKEN: FUNCTION\n"); return FUNCTION; }
"begin"                 { printf("TOKEN: T_BEGIN\n"); return T_BEGIN; }
"end"                   { printf("TOKEN: T_END\n"); return T_END; }
"call"                  { printf("TOKEN: CALL\n"); return CALL; }
"if"                    { printf("TOKEN: IF\n"); return IF; }
"then"                  { printf("TOKEN: THEN\n"); return THEN; }
"else"                  { printf("TOKEN: ELSE\n"); return ELSE; }
"while"                 { printf("TOKEN: WHILE\n"); return WHILE; }
"do"                    { printf("TOKEN: DO\n"); return DO; }
"for"                   { printf("TOKEN: FOR\n"); return FOR; }
"break"                 { printf("TOKEN: BREAK\n"); return BREAK; }
"read"                  { printf("TOKEN: READ\n"); return READ; }
"write"                 { printf("TOKEN: WRITE\n"); return WRITE; }
"writeline"             { printf("TOKEN: WRITELINE\n"); return WRITELINE; }
"return"                { printf("TOKEN: RETURN\n"); return RETURN; }
"odd"                   { printf("TOKEN: ODD\n"); return ODD; }
"to"			        { printf("TOKEN: TO\n"); return TO; }
"="                     { printf("TOKEN: EQ\n"); return EQ; }
"<>"                    { printf("TOKEN: NE\n"); return NE; }
"<"                     { printf("TOKEN: LT\n"); return LT; }
">"                     { printf("TOKEN: GT\n"); return GT; }
"<="                    { printf("TOKEN: LE\n"); return LE; }
">="                    { printf("TOKEN: GE\n"); return GE; }
"("                     { printf("TOKEN: LPAREN\n"); return LPAREN; }
")"                     { printf("TOKEN: RPAREN\n"); return RPAREN; }
"["                     { printf("TOKEN: LBRACKET\n"); return LBRACKET; }
"]"                     { printf("TOKEN: RBRACKET\n"); return RBRACKET; }
","                     { printf("TOKEN: COMMA\n"); return COMMA; }
";"                     { printf("TOKEN: SEMICOLON\n"); return SEMICOLON; }
":="                    { printf("TOKEN: ASSIGN\n"); return ASSIGN; }
"+"                     { printf("TOKEN: ADD\n"); return ADD; }
"-"                     { printf("TOKEN: SUB\n"); return SUB; }
"*"                     { printf("TOKEN: MUL\n"); return MUL; }
"/"                     { printf("TOKEN: DIV\n"); return DIV; }
"%"                     { printf("TOKEN: MOD\n"); return MOD; }
"."			            { printf("TOKEN: DOT\n"); return DOT; }
[0-9]+                  { printf("TOKEN: NUMBER (%s)\n", yytext); yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]*    { printf("TOKEN: IDENTIFIER (%s)\n", yytext); yylval.str = strdup(yytext); return IDENTIFIER; }
"/*"([^*]|\*+[^*/])*"*"+"/" { /* ignore comments */ }

[ \t\n\r]               { /* ignore whitespace */ }
.                       { fprintf(stderr, "Invalid character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
