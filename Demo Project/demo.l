/* C declarations */

%{
	#include <stdio.h>
	#include "demo.tab.h"
	#include <stdlib.h>
	extern int yylval;
%}

/* RE and Action */

%%
"int"	{ return INT; }
"float" { return FLOAT; }
"char"	{ return CHAR; }
[0-9]+	{
			yylval = atoi(yytext);
			return NUM;
		}
"LP"	{ return LP; }
"RP"	{ return RP; }
"LB"	{ return LB; }
"RB"	{ return RB; }
"cm"	{ return CM; }
"sm"	{ return SM; }
"++"	{ return PLUS; }
"--"	{ return MINUS; }
"**"	{ return MULT; }
"//"	{ return DIV; }
"<-"	{ return ASSIGN; }
"GT"	{ return GT; }
"LT"	{ return LT; }

[a-z]	{
			yylval = *yytext - 'a';
			return VAR;
		}
"IC"	{ return IF; }
"OW"	{ return ELSE; }

"void main_function"	{ return VOIDMAIN; }

[ \t\n]*	;
.	{
		yyerror("Unknown Character!\n");
	}

%%


/* user subroutines */

