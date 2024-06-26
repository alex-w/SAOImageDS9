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
     INT = 258,
     REAL = 259,
     BBOX_ = 260,
     BEGIN_ = 261,
     CLEAR_ = 262,
     COMPASS_ = 263,
     CURSOR_ = 264,
     DEBUG_ = 265,
     END_ = 266,
     FALSE_ = 267,
     GET_ = 268,
     HEIGHT_ = 269,
     HIDE_ = 270,
     HIGHLITE_ = 271,
     IMAGE_ = 272,
     INVALID_ = 273,
     MOTION_ = 274,
     N_ = 275,
     NO_ = 276,
     OFF_ = 277,
     ON_ = 278,
     PAN_ = 279,
     QUERY_ = 280,
     RESET_ = 281,
     SHOW_ = 282,
     SIZE_ = 283,
     TRUE_ = 284,
     TO_ = 285,
     UPDATE_ = 286,
     VERSION_ = 287,
     WARP_ = 288,
     WCS_ = 289,
     WIDTH_ = 290,
     Y_ = 291,
     YES_ = 292
   };
#endif
/* Tokens.  */
#define INT 258
#define REAL 259
#define BBOX_ 260
#define BEGIN_ 261
#define CLEAR_ 262
#define COMPASS_ 263
#define CURSOR_ 264
#define DEBUG_ 265
#define END_ 266
#define FALSE_ 267
#define GET_ 268
#define HEIGHT_ 269
#define HIDE_ 270
#define HIGHLITE_ 271
#define IMAGE_ 272
#define INVALID_ 273
#define MOTION_ 274
#define N_ 275
#define NO_ 276
#define OFF_ 277
#define ON_ 278
#define PAN_ 279
#define QUERY_ 280
#define RESET_ 281
#define SHOW_ 282
#define SIZE_ 283
#define TRUE_ 284
#define TO_ 285
#define UPDATE_ 286
#define VERSION_ 287
#define WARP_ 288
#define WCS_ 289
#define WIDTH_ 290
#define Y_ 291
#define YES_ 292




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 24 "panner/parser.Y"
{
  float real;
  int integer;
  char str[1024];
}
/* Line 1529 of yacc.c.  */
#line 129 "panner/parser.H"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



