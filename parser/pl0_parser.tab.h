/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IDENTIFIER = 258,
     NUMBER = 259,
     CONST = 260,
     VAR = 261,
     PROCEDURE = 262,
     FUNCTION = 263,
     T_BEGIN = 264,
     T_END = 265,
     CALL = 266,
     IF = 267,
     THEN = 268,
     ELSE = 269,
     WHILE = 270,
     DO = 271,
     FOR = 272,
     BREAK = 273,
     READ = 274,
     WRITE = 275,
     WRITELINE = 276,
     RETURN = 277,
     ODD = 278,
     TO = 279,
     DOT = 280,
     EQ = 281,
     NE = 282,
     LT = 283,
     GT = 284,
     LE = 285,
     GE = 286,
     LPAREN = 287,
     RPAREN = 288,
     LBRACKET = 289,
     RBRACKET = 290,
     COMMA = 291,
     SEMICOLON = 292,
     ASSIGN = 293,
     ADD = 294,
     SUB = 295,
     MUL = 296,
     DIV = 297,
     MOD = 298,
     UMINUS = 299
   };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define NUMBER 259
#define CONST 260
#define VAR 261
#define PROCEDURE 262
#define FUNCTION 263
#define T_BEGIN 264
#define T_END 265
#define CALL 266
#define IF 267
#define THEN 268
#define ELSE 269
#define WHILE 270
#define DO 271
#define FOR 272
#define BREAK 273
#define READ 274
#define WRITE 275
#define WRITELINE 276
#define RETURN 277
#define ODD 278
#define TO 279
#define DOT 280
#define EQ 281
#define NE 282
#define LT 283
#define GT 284
#define LE 285
#define GE 286
#define LPAREN 287
#define RPAREN 288
#define LBRACKET 289
#define RBRACKET 290
#define COMMA 291
#define SEMICOLON 292
#define ASSIGN 293
#define ADD 294
#define SUB 295
#define MUL 296
#define DIV 297
#define MOD 298
#define UMINUS 299




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 20 "pl0_parser.y"
{
    int num;     
    char* str;   
}
/* Line 1529 of yacc.c.  */
#line 142 "pl0_parser.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

