/* C declarations */

%{
	#include <stdio.h>
	int yylex(void);
	
	int sym[26], store[26];
%}

/* Bison declarations */

%token NUM VAR IF ELSE VOIDMAIN INT FLOAT CHAR LP RP LB RB CM SM PLUS MINUS MULT DIV ASSIGN GT LT
%nonassoc IF
%nonassoc ELSE
%left LT GT
%left PLUS MINUS
%left MULT DIV

/* simple grammar rules */

%%

program: VOIDMAIN LP RP LB cstatement RB	{ printf("\nsuccessful compilation\n"); }
	;

cstatement: /* empty */
	| cstatement statement
	| cdeclaration
	;

cdeclaration: TYPE ID1 SM { printf("\n valid declaration\n"); }
	;

TYPE : INT
	 | FLOAT
	 | CHAR
	 ;

ID1 : ID1 CM VAR	{
						if(store[$3] == 1)
						{
							printf("%c is already declared\n", $3 + 97);
						}
						else
						{
						store[$3] = 1;
						}
					}
	| VAR	{
				if(store[$1] == 1)
				{
					printf("%c is already declared\n", $1 + 97);
				}
				else
				{
					store[$1] = 1;
				}
			}
	;

statement	:	SM
			|	expression SM	{ printf("\nvalue of expression: %d\n", $1); }
			| 	VAR ASSIGN expression SM	{
												sym[$1] = $3;
												printf("\nvalue of the variable: %d\t\n", $3);
											}
			|	IF LP expression RP LB expression SM RB	{
															if($3)
															{
																printf("\nvalue of expression in IF: %d\n", $6);
															}
															else
															{
																printf("ncondition value zero in IF block\n");
															}
														}
			|	IF LP expression RP LB expression SM RB ELSE LB expression RB	{
																					if($3)
																					{
																						printf("\nvalue of expression in IF: %d\n", $6);
																					}
																					else
																					{
																						printf("\nvalue of expression in ELSE: %d\n", $11);
																					}
																				}
			;

		
expression	:	NUM
			|	VAR		{ $$ = sym[$1]; }
			|	expression PLUS expression	{ $$ = $1 + $3; }
			|	expression MINUS expression	{ $$ = $1 - $3; }
			|	expression MULT expression	{ $$ = $1 * $3; }
			|	expression DIV expression	{
												if($3)
												{
													$$ = $1 / $3;
												}
												else
												{
													$$ = 0;
													printf("\ninvalid division\n");
												}
											}
			|	expression LT expression	{ $$ = $1 < $3; }
			|	expression GT expression	{ $$ = $1 > $3; }
			|	LP expression RP			{ $$ = $2; }
			;

%%

int yywrap() {

	return 1;
}

int yyerror(char *s) {
	
	fprintf(stderr, "%s\n", s);

}

int main()
{
	freopen("input.txt", "r", stdin); //code editor file
	yyparse();
}