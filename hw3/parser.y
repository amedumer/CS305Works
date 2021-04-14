%{
#include <stdio.h>


// {printf("Result of expression on %d is (%d)\n",line,$$);} 
void yyerror (const char *s) 
{}

typedef enum { STR, INT, DBL } itemType;

typedef union 
{
    int inum;
    double dnum;
    char* sval;
} exprNode ;

typedef struct Node
{
    itemType thisNodeType;
    exprNode* exprNodePtr;
} Node ;


extern int line;

char* substr(const char *src, int m, int n);
%}

%union {
	struct Node * node;
	double num;
	char* str;
	int isDouble;
}

%token tADD tNUM tSUB tMUL tDIV tSTRING tPRINT tGET tSET tFUNCTION tRETURN tIDENT tEQUALITY tIF tGT tLT tGEQ tLEQ tINC tDEC

%start prog

%type <num> tNUM;
%type <str> tSTRING;
%type <node> expr;

%%
prog:		'[' stmtlst ']'
;

stmtlst:	stmtlst stmt |
;

stmt:		setStmt 
			| if 
			| print 
			| unaryOperation 
			| expr 
			| returnStmt 
;

getExpr:	'[' tGET ',' tIDENT ',' '[' exprList ']' ']'
		| '[' tGET ',' tIDENT ',' '[' ']' ']'
		| '[' tGET ',' tIDENT ']'
;

setStmt:	'[' tSET ',' tIDENT ',' expr ']'
;

if:		'[' tIF ',' condition ',' '[' stmtlst ']' ']'
		| '[' tIF ',' condition ',' '[' stmtlst ']' '[' stmtlst ']' ']'
;

print:		'[' tPRINT ',' '[' expr ']' ']'
;



operation:	'[' tADD ',' expr ',' expr ']' {
	if($4->thisNodeType == INT && $6->thisNodeType == INT){
		printf("two integers found%d\n",2);
/*
		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->inum = $4->exprNodePtr->inum + ;

			node->exprNodePtr = exprnode;
			node->thisNodeType = INT;
*/
	}
}
		| '[' tSUB ',' expr ',' expr ']' 
		| '[' tMUL ',' expr ',' expr ']' 
		| '[' tDIV ',' expr ',' expr ']' 
;



unaryOperation: '[' tINC ',' tIDENT ']'
		| '[' tDEC ',' tIDENT ']'
;

expr:		tNUM {

			Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));

			int converted = $1;
			if ($1 - converted == 0){
				printf("%f ahahaahaha\n",$1);
				exprnode->inum = $1;
				node->exprNodePtr = exprnode;
				node->thisNodeType = INT;

			}
			else{
				exprnode->dnum = $1;
				node->exprNodePtr = exprnode;
				node->thisNodeType = DBL;
			}
			$$ = node;
}
			| tSTRING  {
				Node * node = (Node *) malloc(sizeof(Node));

				exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
				exprnode->sval = substr($1,1,strlen($1) - 1);

				node->exprNodePtr = exprnode;
				node->thisNodeType = STR;

				$$ = node;
			}
			| getExpr | function | operation| condition
;

function:	 '[' tFUNCTION ',' '[' parametersList ']' ',' '[' stmtlst ']' ']'
		| '[' tFUNCTION ',' '[' ']' ',' '[' stmtlst ']' ']'
;

condition:	'[' tEQUALITY ',' expr ',' expr ']'
		| '[' tGT ',' expr ',' expr ']'
		| '[' tLT ',' expr ',' expr ']'
		| '[' tGEQ ',' expr ',' expr ']'
		| '[' tLEQ ',' expr ',' expr ']'
;

returnStmt:	'[' tRETURN ',' expr ']'
		| '[' tRETURN ']'
;

parametersList: parametersList ',' tIDENT | tIDENT
;

exprList:	exprList ',' expr | expr
;

%%

char* substr(const char *src, int m, int n)
{
    int len = n - m;
    int i;
    char *dest = (char*)malloc(sizeof(char) * (len + 1));

    for (i = m; i < n && (*(src + i) != '\0'); i++)
    {
        *dest = *(src + i);
        dest++;
    }
    *dest = '\0';
    return dest - len;
}

int main ()
{
if (yyparse()) {
// parse error
printf("ERROR\n");
return 1;
}
else {
// successful parsing
//printf("OK\n");
return 0;
}
}
