%{
#include <stdlib.h>
#include "symtab.h"
#include "klx.tab.h"
%}

%option noyywrap yylineno
%x COMMENT

%%

Square	            return SQUARE;
Circle              return CIRCLE;
Triangle	    return TRIANGLE;

White		    return WHITE;
Red                 return RED;
Blue                return BLUE;
Yellow		    return YELLOW;
Gold		    return GOLD;
Fire		    return FIRE;
Pale		    return PALE;
Green		    return GREEN;
Forest		    return FOREST;
Sky		    return SKY;
Dark		    return DARK;

Move                return MOVE;
Scale               yylval.i = atoi(yytext); return SCALE;

Variable            return DECLARE;

IF		    return IF;
THEN		    return THEN;
ELSE		    return ELSE;
ENDIF		    return ENDIF;
WHILE		    return WHILE;
ENDLOOP	    	    return ENDWHILE;
FUNC		    return FUNC;
ENDFUNC		    return ENDFUNC;
LOCAL		    return LOCAL;
ENDLOCAL	    return ENDLOCAL;
\[		    return START;
\]		    return FINISH;

\%		    return MOD;
\+                  return PLUS;
\*                  return STAR;
\(                  return OPEN;
\)                  return CLOSE;
\-                  return MINUS;
\/                  return DIV;
\^                  return HAT;
sqrt                return SQRT;
=		    return EQUAL;

\>		    return GT;
\<		    return LT;
\>=		    return GTE;
\<=		    return LTE;
==		    return EQ;
!=		    return NEQ;
!		    return NOT;

\|		    return OR;
&&		    return AND;

;                   return SEMIC;
,                   return COMMA;

[1-9]*[0-9]+        yylval.i = atoi(yytext); return NUMBER;
[a-zA-Z]+	    { yylval.n = lookup(yytext); 
		      if (yylval.n == NULL) yylval.n = insert(yytext);
		      return VAR; 
		    }
[0-9]+\.[0-9]+	    yylval.d = atof(yytext); return FLOAT;

<COMMENT>\*\/       BEGIN(INITIAL);
<COMMENT>.	        ;
<COMMENT>\n	        ;
\/\*\*              BEGIN(COMMENT);
\/\*                BEGIN(COMMENT);
\/\/.*              ;
[[:space:]]         ;


%%
