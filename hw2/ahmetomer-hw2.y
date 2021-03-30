%{
#include <stdio.h>

void yyerror (const char *s) 
{ /* Called by yyparse on error */


}
%}

%token tGET
%token tSET
%token tFUNCTION
%token tSTRING
%token tRETURN
%token tINC
%token tDEC
%token tEQUALITY
%token tNUM
%token tPRINT
%token tIDENT
%token tIF
%token tGT
%token tLT
%token tLEQ
%token tGEQ

%start program

%%

program:	'[' stmList ']'
			| '[' ']';

stmList:	stmList '['stm']'	
			| '['stm']';

stm:	set
      |if
      |print
      |incrdecr
      |func
      |return
      |get 
      |condition
      |operator;

if:   tIF ',' '['condition']' ',' program
      |tIF ',' '['condition']' ',' program program;

set:	tSET ',' tIDENT ',' expr
      |tSET ',' tIDENT ',' '['func ']'
      |tSET ',' tIDENT ',' '[' operator ']';

print:   tPRINT ',' '[' expr ']';

incrdecr: tINC ',' tIDENT
         |tDEC ',' tIDENT;

return: tRETURN
         | tRETURN ',' expr;

expr:    tNUM
         |tSTRING
         | '[' get ']';

exprList:   exprList ',' expr
            | expr
            | ;

paramList:  paramList ',' tIDENT
            | tIDENT
            | ;

condition:  conditionOperand ',' expr ',' expr;

func: tFUNCTION ',' '[' paramList ']' ',' program;

get:   tGET ',' tIDENT 
      | tGET ',' tIDENT ',' '[' exprList ']' ;

conditionOperand:    tGT
                     |tLT
                     |tGEQ
                     |tLEQ
                     |tEQUALITY;
      
operator:   opList ',' expr ',' expr;

opList:     '"' '+' '"'
            |'"' '/' '"'
            |'"' '-' '"'
            |'"' '*' '"';

%%
int main ()
{
   if (yyparse()) {
   // parse error
       printf("ERROR\n");
       return 1;
   }
   else {
   // successful parsing
      printf("OK\n");
      return 0;
   }
}
