%{
#include <stdio.h>
#include "symtab.h"
extern int yylineno;
%}

%token SQUARE CIRCLE TRIANGLE
%token RED BLUE GREEN YELLOW GOLD FIRE WHITE PALE FOREST SKY DARK
%token MOVE SCALE
%token IF THEN ELSE START FINISH ENDIF
%token WHILE ENDWHILE LOCAL ENDLOCAL
%token <i> NUMBER
%token <d> FLOAT
%token PLUS STAR OPEN CLOSE MINUS DIV HAT SQRT EQUAL MOD
%token GT LT GTE LTE EQ NOT NEQ OR AND
%token SEMIC COMMA
%token DECLARE FUNC ENDFUNC
%token <n> VAR

%type <i> parameters param_list
%union { node *n; int i; double d; }
%error-verbose

%%

/* program file outline */

program:	header scope_open 
			declarations 
			command_list 
			trailer scope_close;
header: 	{ printf("%%!PS-Adobe\n"
		 		"%%%% Generated by KLX version 0.0\n"); };
trailer:	;

/* control injections */

code_start:		{ printf("{\n"); };
code_end:		{ printf("} "); };
end_loop:		{ printf("not { exit } if\n"); };
scope_open:		{ scope_open(); 
	      			printf("6 dict begin\n"); };
scope_close:	{ scope_close(); 
	       			printf("end\n"); };
local_start:	{ printf("gsave\n"); };
local_end:		{ printf("grestore\n"); };

/* command formats */

command_list:	command;
command_list:	command command_list;

command_control:	START 
					scope_open local_start 
					declarations 
					command_list 
					FINISH 
					scope_close local_end;

/* control commands */

command:	IF bool THEN 
			code_start 
			command_control 
			ENDIF 
			code_end SEMIC 
			{ printf("if\n"); };

command:	IF bool THEN 
			code_start 
			command_control 
			code_end 
			ELSE 
			code_start 
			command_control 
			ENDIF 
			code_end SEMIC 
			{ printf("ifelse\n"); };

command:	WHILE code_start 
			bool end_loop 
			command_control 
			ENDWHILE 
			code_end SEMIC 
			{ printf("loop\n"); };

command: 	LOCAL 
			command_control 
			ENDLOCAL SEMIC;

command:	VAR OPEN 
			arguments 
			CLOSE SEMIC 
			{ printf("var_%s\n", $1->symbol); };
command:	VAR EQUAL expr SEMIC 
			{ if ($1->def) printf("/var_%s exch store\n", $1->symbol); 
				else errorNonDeclare($1->symbol); };

/* shape commands */

command:	shape SEMIC;
command:	color SEMIC;
command:	color shape SEMIC;
command:	move SEMIC;
command:	scale SEMIC;

/* procedure args */

arguments:	;
arguments:	arg_list;

arg_list:	arg_list COMMA expr;
arg_list:	expr;

/* declarations and parameters */

declarations:	;
declarations:	dec_list;

dec_list:	decl dec_list;
dec_list:	decl;

decl:	DECLARE 
		var_list 
		SEMIC;
decl:	FUNC VAR 
		{ scope_open(); 
			printf("/var_%s { 6 dict begin gsave\n", $2->symbol); }
		OPEN 
		parameters
		CLOSE 
		START
		declarations 
		command_list
		FINISH
		{ scope_close(); printf("grestore end } def\n"); }
		ENDFUNC SEMIC;

var_list:	VAR
			{ $1->def = 1; printf("/var_%s 0 def\n", $1->symbol); };
var_list:	VAR COMMA var_list 
			{ $1->def = 1; printf("/var_%s 0 def\n", $1->symbol); };

parameters:	{ $$ = 0; };
parameters:	param_list 
			{ $$ = $1; };

param_list:	VAR COMMA 
			param_list 
			{ $1->def = 1; printf("/var_%s exch def\n", $1->symbol); };
param_list:	VAR 
			{ $1->def = 1; printf("/var_%s exch def\n", $1->symbol); };

/* shape commands */

shape:	SQUARE 
		{ printf("newpath 0 0 moveto 100 0 lineto ");
			printf("100 100 lineto 0 100 lineto closepath fill\n"); };
shape:	CIRCLE 
		{ printf("newpath 0 0 50 0 360 arc closepath fill\n"); };
shape:	TRIANGLE 
		{ printf("newpath 0 0 moveto 100 0 lineto 50 100 lineto ");
			printf("0 0 lineto closepath fill\n"); };

move:	MOVE expr COMMA expr 
		{ printf("translate\n"); };
scale:	SCALE expr COMMA expr 
		{ printf("scale\n"); };

/* color commands */

color:	RED 
		{ printf("1 0 0 setrgbcolor\n"); };
color:	BLUE
		{ printf("0 0 1 setrgbcolor\n"); };
color:	YELLOW
		{ printf("1 0.98 0.8 setrgbcolor\n"); };
color:	GOLD
		{ printf("1 0.84 0 setrgbcolor\n"); };
color:	FIRE
		{ printf("0.957 0.64 0.38 setrgbcolor\n"); };
color:	PALE
		{ printf("0.97 0.97 1 setrgbcolor\n"); };
color:	WHITE
		{ printf("1 1 1 setrgbcolor\n"); };
color:	SKY
		{ printf("0.53 0.8 0.98 setrgbcolor\n"); };
color:	GREEN
		{ printf("0 0.7 0.3 setrgbcolor\n"); };
color:	FOREST
		{ printf("0 0.5 0.3 setrgbcolor\n"); };
color:	DARK
		{ printf("0.055 0.29 0.23 setrgbcolor\n"); };

/* booleans */

bool_expr:	bool_expr OR bool 
			{ printf("or "); };
bool_expr:	bool_prod;

bool_prod:	bool_prod AND bool 
			{ printf("and "); };
bool_prod:	bool;

bool:	expr GT expr 
		{ printf("gt "); };
bool:	expr LT expr 
		{ printf("lt "); };
bool:	expr GTE expr 
		{ printf("ge "); };
bool:	expr LTE expr 
		{ printf("le "); };
bool:	expr EQ expr 
		{ printf("eq "); };
bool:	expr NEQ expr 
		{ printf("ne "); };
bool:	NOT bool
		{ printf("not "); };
bool:	OPEN 
		bool_expr
		CLOSE;

/* math expressions */

expr:	expr PLUS prod 
		{ printf("add "); };
expr:	expr MINUS prod 
		{ printf("sub "); };
expr:	prod;

prod:	prod STAR prod_ 
		{ printf("mul "); };
prod:	prod DIV prod_ 
		{ printf("div "); };
prod:	prod MOD prod_ 
		{ printf("mod "); };
prod:	prod_;

prod_:	prod_ HAT atom 
		{ printf("exp "); };
prod_:	SQRT atom 
		{ printf("sqrt "); };
prod_:	atom;

atom:	NUMBER 
		{ printf("%d ", $1); };
atom:	FLOAT
		{ printf("%lf ", $1); };
atom:	VAR
		{ if ($1->def) printf("var_%s ", $1->symbol); 
			else errorNonDeclare($1->symbol); };
atom:	MINUS atom 
		{ printf("neg "); };
atom:	PLUS atom 
		{ printf("1 mul "); };
atom:	OPEN
		expr
		CLOSE;

%%

int errorNonDeclare(char *varName) {
    fprintf(stderr, "ERROR: variable %s is not declared before use\n", varName);
    return 0;
}

int yyerror(char *msg) {
    fprintf(stderr, "ERROR %d: %s\n", yylineno, msg);
    return 0;
}

int main(void) {
    yyparse();
    return 0;
}
