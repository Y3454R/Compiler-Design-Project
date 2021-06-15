/* C Declarations */

%{
	#include<stdio.h>
	#include <math.h>
	#include<stdlib.h>
	#include <string.h>

	int switchFlag = 0;
	int switchX;

	// for if else block
	int ifPtr = -1;
	int ifFlagList[1000];

    int ptr = 0;
    int value[1000];
    char variableList[1000][1000];

    // check if already declared or not
    int declarationCheck(char []);

	// set new value to a variable if declaration check is valid
    int setNewVal(char [], int);

    // save the string
    int getStrVal(char []);
    int setStrVal(char [], int);


%}

%union {
  char text[1000];
  int val;
  double doubleVal;
}


%token <text>  ID
%token <val>  NUM
%token <text> STR

%type <val> expression

%token INT DOUBLE CHAR MAINFUNC LP RP LB RB SM CM ASSIGN SHOWVARIABLE SHOWSTRING SHOWNEWLINE PLUS MINUS MULT DIV MOD PWR LT GT LE GE EE NE IF ELSE ELSEIF FOR BCKLOOP INC DEC TO SWITCH DEFAULT COL FUNCTION
%nonassoc IF
%nonassoc ELSEIF
%nonassoc ELSE
%left LT GT LE GE EE NE
%left PLUS MINUS
%left MULT DIV
%left MOD
%left PWR


%%

// start

starthere 	: function program function
			;

program		: INT MAINFUNC LP RP LB statement RB { printf("\n\nCOMPILATION SUCCESSFULLY COMPLETED\n\n"); }
			;
statement	: /* empty */
			| statement declaration
			| statement print
			| statement expression 
			| statement ifelse
			| statement assign
			| statement forwardloop
			| statement backwardloop
			| statement switch
			;

// start




// declaration

declaration : type variables SM {}
			;
type		: INT | DOUBLE | CHAR {}
			;
variables	: variable CM variables {}
			| variable {}
			;
variable   	: ID 	
					{
						//printf("%s\n",$1);
						int x = setNewVal($1,0);
						if(!x) {
							//printf("This variable is already declared\n");
							printf("\nCOMPILATION ERROR : Variable %s is already declared\n", $1);
							exit(-1);
						}

					}
			| ID ASSIGN expression 	
					{
						//printf("%s %d\n",$1,$3);
						int x = setNewVal($1,$3);
						if(!x) {
							//printf("This variable is already declared\n");
							printf("\nCOMPILATION ERROR : Variable %s is already declared\n", $1);
							exit(-1);
						}
					}

			;

// declaration

// assign operation 

assign : ID ASSIGN expression SM  
					{
						if(!declarationCheck($1)) {
							printf("\nCOMPILATION ERROR : Variable %s is not declared\n", $1);
							exit(-1);
						}
						else{
							setStrVal($1,$3);
						}
				    }

// assign operation 


// print function

print		: SHOWVARIABLE LP ID RP SM 	
					{
						if(!declarationCheck($3)){
							printf("\nCOMPILATION ERROR : Variable %s is not declared\n", $3);
							exit(-1);
						}
						else{
							int v = getStrVal($3);
							printf("%d", v);
						}
					}
			| SHOWSTRING LP STR RP SM 
					{
						int len = strlen($3);
						for(int i = 1;  i < len - 1; i++) {
							printf("%c", $3[i]);
						}
						
					}
			| SHOWNEWLINE LP RP	SM 	
					{
						printf("\n");
					}
			;

// print function



// expression

expression : NUM {$$ = $1;}
			| ID 	
					{
						if(!declarationCheck($1)) {
							printf("\nCOMPILATION ERROR : Variable %s is not declared\n", $1);
							exit(-1);
						}
						else{
							$$ = getStrVal($1);
						}
				 	}
			| expression PLUS expression 
					{$$ = $1 + $3;}
			| expression MINUS expression 
					{$$ = $1 - $3;}
			| expression MULT expression 
					{$$ = $1 * $3;}
			| expression DIV expression 
					{
						if($3) {
 							$$ = $1 / $3;
							}
				  		else {
							$$ = 0;
							printf("\nRuntime Error found : division by zero!\n");
							exit(-1);
				  		} 
					}
			| expression MOD expression 
					{
						if($3) {
 							$$ = $1 % $3;
							}
				  		else {
							$$ = 0;
							printf("\nRuntime Error found : mod by zero!\n");
							exit(-1);
				  		} 
					}
			| expression PWR expression
					{ $$ = pow($1 , $3); }
			| expression LT expression	
					{ $$ = $1 < $3; }
			| expression GT expression	
					{ $$ = $1 > $3; }
			| expression LE expression	
					{ $$ = $1 <= $3; }
			| expression GE expression	
					{ $$ = $1 >= $3; }
			| expression EE expression	
					{ $$ = $1 == $3; }
			| expression NE expression	
					{ $$ = $1 != $3; }
			| LP expression RP
					{$$ = $2;}
			;


// expression




// if else block

ifelse 	: IF LP ifexp RP LB statement RB elseif
					{

						ifFlagList[ifPtr] = 0;
						ifPtr--;
					}
		;
ifexp	: expression 
					{
						ifPtr++;
						ifFlagList[ifPtr] = 0;
						if($1){
							printf("\nIf block Compilation successful\n");
							ifFlagList[ifPtr] = 1;
						}
					}
		;
elseif 	: /* empty */
		| elseif ELSEIF LP expression RP LB statement RB 
					{
						if($4 && ifFlagList[ifPtr] == 0){
							printf("\nElse if block expression %d compiled\n", $4);
							ifFlagList[ifPtr] = 1;
						}
					}
		| elseif ELSE LB statement RB
					{
						if(ifFlagList[ifPtr] == 0){
							printf("\nElse block compilation successful\n");
							ifFlagList[ifPtr] = 1;
						}
					}

		;

// if else block




// loop


forwardloop	: FOR LP expression TO expression INC expression RP LB statement RB 	
					{
						int startVal = $3;
						int limitVal = $5;
						int incVal = $7;
						int count = 0;
						for(int it = startVal; it <= limitVal; it += incVal){
							count++;
						}	
						printf("\nforward Loop executed %d times\n", count);
					}



// loop


// backward loop

backwardloop	: BCKLOOP LP expression TO expression DEC expression RP LB statement RB 	
					{
						int startVal = $3;
						int limitVal = $5;
						int decVal = $7;
						int count = 0;
						for( int it = startVal; it >= limitVal; it -= decVal){
							count++;
						}	
						printf("\nbackward Loop executed %d times\n", count);
					}



// backward loop


// switch

switch	: SWITCH LP expswitch RP LB switchinside RB 
		;

expswitch 	:  expression 
					{
						switchFlag = 0;
						switchX = $1;
					}
			;


switchinside	: /* empty */
				| switchinside expression COL LB statement RB 
					{
						if($2 == switchX){
							printf("\nSWITCH EXECUTED : %d\n",$2);
							switchFlag = 1;
						}					
					}
				| switchinside DEFAULT COL LB statement RB 
					{
						if(switchFlag == 0){
							switchFlag = 1;
							printf("\nDEFAULT EXECUTED\n");
						}
					}
				;


// switch




// make new function

function 	: /* empty */
			| function func
			;

func 	: type FUNCTION LP fparameter RP LB statement RB
					{
						printf("FUNCTION DECLARED SUCCESSFULLY\n");
					}
		;
fparameter 	: /* empty */
			| type ID fsparameter
			;
fsparameter : /* empty */
			| fsparameter CM type ID
			;

// new function


%%


int yyerror(char *s){
	printf( "%s\n", s);
}


int declarationCheck(char str[]){

        for(int i = 0; i < ptr; i++){
            if(strcmp(variableList[i], str) == 0) {
				return 1;
			}
        }

        return 0;
}

int setNewVal(char str[],int val){

        if(declarationCheck(str) == 1) {
			return 0;
		}

        strcpy(variableList[ptr],str);
        value[ptr] = val;
        ptr++;
        return 1;
}

int getStrVal(char str[]){

        int indx = -1;

        for(int i = 0; i < ptr; i++){
            if(strcmp(variableList[i],str) == 0) {
                indx = i;
                break;
            }
        }
        return value[indx];
}

int setStrVal(char str[], int val){
    	int indx = -1;
        for(int i = 0; i < ptr; i++){
            if(strcmp(variableList[i],str) == 0) {
                indx = i;
                break;
            }
        }
        value[indx] = val;
}