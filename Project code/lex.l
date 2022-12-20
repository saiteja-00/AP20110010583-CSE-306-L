%{
#include<string.h>
#include<stdio.h>
int line = 0;
#define YYSTYPE char *
%}
alpha [A-Za-z_]
digit [0-9]
%option yylineno
%%
[ \t\n] {yylval = strdup(yytext);}
":" {yylval = strdup(yytext);return T_colon;}
"?" {yylval = strdup(yytext);return T_ques;}
"while" {yylval = strdup(yytext);return WHILE;}
"for" {yylval = strdup(yytext);return FOR;}
"if" {yylval = strdup(yytext);return IF;}
"else" {yylval = strdup(yytext);return ELSE;}
"cout" {yylval = strdup(yytext);return COUT;}
"endl" {yylval = strdup(yytext);return ENDL;}
"break" {yylval = strdup(yytext);return BREAK;}
"continue" {yylval = strdup(yytext);return CONTINUE;}
"int" {yylval = strdup(yytext);return INT;}
"float" {yylval = strdup(yytext);return FLOAT;}
"char" {yylval = strdup(yytext);return CHAR;}
"void" {yylval = strdup(yytext);return VOID;}
"#include" {yylval = strdup(yytext);return INCLUDE;}
"main()" {yylval = strdup(yytext);return MAINTOK;}
{digit}+ {yylval = strdup(yytext);return NUM;}
{digit}+.{digit}+ {yylval = strdup(yytext);return FLOAT;}
{alpha}({alpha}|{digit})* {yylval = strdup(yytext);return ID;}
{alpha}({alpha}|{digit})*"\.h"? {yylval = strdup(yytext);return H;}
\".*\" {yylval = strdup(yytext);return STRING;}
"<" {yylval = strdup(yytext);return T_lt;}
">" {yylval = strdup(yytext);return T_gt;}
"=" {yylval = strdup(yytext);return T_eq;}
"<=" {yylval = strdup(yytext);return T_lteq;}
">=" {yylval = strdup(yytext);return T_gteq;}
"==" {yylval = strdup(yytext);return T_eqeq;}
"!=" {yylval = strdup(yytext);return T_neq;}
"+" {yylval = strdup(yytext);return T_pl;}
"-" {yylval = strdup(yytext);return T_min;}
"*" {yylval = strdup(yytext);return T_mul;}
"/" {yylval = strdup(yytext);return T_div;}
"++" {yylval = strdup(yytext);return T_incr;}
"--" {yylval = strdup(yytext);return T_decr;}
"!" {yylval = strdup(yytext);return T_neq;}
"||" {yylval = strdup(yytext);return T_or;}
"&&" {yylval = strdup(yytext);return T_and;}
. return yytext[0];
%%





The following is the CFG used -

S
: START
;
START
: INCLUDE T_lt H T_gt MAIN
| INCLUDE "\"" H "\"" MAIN
;
MAIN
: VOID MAINTOK BODY
| INT MAINTOK BODY
;
BODY
: '{' C '}'
;
C
: C statement ';'
| C LOOPS
| statement ';'
| LOOPS
;
LOOPS
: WHILE '(' COND ')' LOOPBODY
| FOR '(' ASSIGN_EXPR ';' COND ';' statement ')' LOOPBODY
| IF '(' COND ')' LOOPBODY
| IF '(' COND ')' LOOPBODY ELSE LOOPBODY
;

LOOPBODY
: '{' LOOPC '}'
| ';'
| statement ';'
;
LOOPC
: LOOPC statement ';'
| LOOPC LOOPS
| statement ';'
| LOOPS
;
statement
: ASSIGN_EXPR
| EXP
| TERNARY_EXPR
| PRINT
;
COND
: LIT RELOP LIT
| LIT
| LIT RELOP LIT bin_boolop LIT RELOP LIT
| un_boolop '(' LIT RELOP LIT ')'
| un_boolop LIT RELOP LIT
| LIT bin_boolop LIT
| un_boolop '(' LIT ')'
| un_boolop LIT
;
ASSIGN_EXPR
: ID T_eq EXP
| TYPE ID T_eq EXP
;
EXP
: ADDSUB
| EXP T_lt ADDSUB
| EXP T_gt ADDSUB
;
ADDSUB
: TERM
| EXP T_pl TERM
| EXP T_min TERM
;
TERM
: FACTOR
| TERM T_mul FACTOR
| TERM T_div FACTOR
;

FACTOR
: LIT
| '(' EXP ')'
;
PRINT

LIT

TYPE

RELOP
: COUT T_lt T_lt STRING
| COUT T_lt T_lt STRING T_lt T_lt ENDL
;
: ID
| NUM
;
: INT
| CHAR
| FLOAT
;
: T_lt
| T_gt
| T_lteq
| T_gteq
| T_neq
| T_eqeq
;
bin_boolop
: T_and
| T_or
;
un_arop
: T_incr
| T_decr
;
un_boolop
: T_not
;
