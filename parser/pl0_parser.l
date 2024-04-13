%{
#include "pl0.tab.h"
%}

%%

"const"          { return CONST; }
"var"            { return VAR; }
"odd"            { return ODD; }
"procedure"      { return PROCEDURE; }
"function"       { return FUNCTION; }
"if"             { return IF; }
"then"           { return THEN; }
"else"           { return ELSE; }
"while"          { return WHILE; }
"do"             { return DO; }
"call"           { return CALL; }
"begin"          { return BEGIN; }
"end"            { return END; }
"return"         { return RETURN; }
"break"          { return BREAK; }
"for"            { return FOR; }
"to"             { return TO; }
"read"           { return READ; }
"write"          { return WRITE; }
"writeline"      { return WRITELINE; }

[0-9]+           { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.id = strdup(yytext); return IDENTIFIER; }

"+"              { return PLUS; }
"-"              { return MINUS; }
"*"              { return TIMES; }
"/"              { return DIVIDE; }
"%"              { return MOD; }
":="             { return ASSIGN; }
";"              { return SEMICOLON; }
","              { return COMMA; }
"."              { return DOT; }
"["              { return LBRACKET; }
"]"              { return RBRACKET; }
"("              { return LPAREN; }
")"              { return RPAREN; }

"/*"             { BEGIN(COMMENT); }
<COMMENT>"*/"    { BEGIN(INITIAL); }
<COMMENT>[^*]+   { /* Consume non-star characters */ }
<COMMENT>"*"     { /* Consume stars that might not end the comment */ }
<COMMENT>"*"+"/" { BEGIN(INITIAL); }  /* Exit comment mode on closing */ 
<COMMENT>\n      { /* Consume newlines explicitly to maintain line numbers */ }

[ \t\n]+         { /* Ignore whitespaces */ }

.                { fprintf(stderr, "Unexpected character: %s\n", yytext); return yytext[0]; }

%%
