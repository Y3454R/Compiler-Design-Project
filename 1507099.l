char [a-zA-Z]
digit [0-9]
special [$_@]
space " "
newline "\n"
Datatype "intgr"|"dbl"|"ch"|"void"
Operator "<-"|"jog"|"bad"|"vag"|"gun"|"vagShesh"|"barbe>"|"kombe>"
Relational_Operator "boro_theke"|"choto_theke"|"boro_shoman"|"choto_shoman"|"shoman"|"oshoman"
Comment [?][?].*

%{
	#include "1507099.tab.h"
	#include <string.h>
%}



%%
{space}|{newline} {}
{Comment}	{}
"|" {return SM;}
",," {return CM;}
{digit}+ 	{
				yylval.val = atoi(yytext);
				return NUM;
			}

"compiler_function" { return MAINFUNC;}
"outVar" { return SHOWVARIABLE;}
"outStr" {return SHOWSTRING;}
"outNL" {return SHOWNEWLINE;}

"newFunction@"({char}|{digit}|{special})+ {return FUNCTION;}

"VAR@"({char}|{digit}|{special})+ { strcpy(yylval.text,yytext);return ID;}

"intgr" {  return INT;}
"dbl" { return DOUBLE;}
"ch" { return CHAR;}

"#s" { return LP; }
"e#" { return RP; }

"*s" { return LB;}
"e*" { return RB;}

"<-" {return ASSIGN;}

"jog" {return PLUS;}
"bad" {return MINUS;}
"gun" {return MULT;}
"vag" {return DIV;}
"vagShesh"	{return MOD;}
"ghat"	{return PWR;}

"choto_theke" {return LT;}
"boro_theke" {return GT;}
"choto_shoman" {return LE;}
"boro_shoman" {return GE;}
"shoman"	{return EE;}
"oshoman"	{return NE;}

"jodi" { return IF;}
"othoba" {return ELSEIF;}
"noile" {return ELSE;}

"fwdloop" {return FOR;}
"bckloop" {return BCKLOOP;}
"barbe>" {return INC;}
"kombe>" {return DEC;}
"porjonto>" {return TO;}

"mele_kina" {return SWITCH;}
"sheshmesh" {return DEFAULT;}
">>" {return COL;}
. {}


"\""(.)*"\"" {strcpy(yylval.text,yytext); return STR;}




%%


int yywrap()
{
	return 1;
}


int main(){
	yyin = freopen("SourceCode.txt","r",stdin);
	//freopen("out.txt","w",stdout);
	yyparse();
}