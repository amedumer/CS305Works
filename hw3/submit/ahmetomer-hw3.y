%{
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>


// {printf("Result of expression on %d is (%d)\n",line,$$);} 
void yyerror (const char *s) 
{}

typedef enum { STR, INT, DBL, ERR ,GET, CHK} itemType;

typedef union 
{
    int inum;
    float dnum;
    char* sval;
} exprNode ;



typedef struct Node
{
    itemType thisNodeType;
    exprNode* exprNodePtr;
} Node ;


extern int line;

char* substr(const char *src, int m, int n);
void printExpr(const Node*);

%}

%union {
	struct Node * node;
	char* num;
	char* str;

}

%token tADD tNUM tSUB tMUL tDIV tSTRING tPRINT tGET tSET tFUNCTION tRETURN tIDENT tEQUALITY tIF tGT tLT tGEQ tLEQ tINC tDEC

%start prog

%type <num> tNUM;
%type <str> tSTRING;
%type <node> expr;
%type<node> operation;
%type<node> setStmt;
%type<node> condition;


%%
prog:		'[' stmtlst ']'
;

stmtlst:	stmtlst stmt |
;

stmt:		setStmt 
			| if 
			| print 
			| unaryOperation 
			| expr {
				printExpr($1);
			}
			| returnStmt 
;

getExpr:	'[' tGET ',' tIDENT ',' '[' exprList ']' ']'
		| '[' tGET ',' tIDENT ',' '[' ']' ']'
		| '[' tGET ',' tIDENT ']'
;

setStmt:	'[' tSET ',' tIDENT ',' expr ']' {
	printExpr($6);
}
;

if:		'[' tIF ',' condition ',' '[' stmtlst ']' ']'
		| '[' tIF ',' condition ',' '[' stmtlst ']' '[' stmtlst ']' ']'
;

print:		'[' tPRINT ',' '[' expr ']' ']'
;



operation:	'[' tADD ',' expr ',' expr ']' {


	if($4->thisNodeType == GET || $6->thisNodeType == GET){Node * node = (Node *) malloc(sizeof(Node));

				node->thisNodeType = GET;

				$$ = node;}

	else if($4->thisNodeType == CHK || $6->thisNodeType == CHK){Node * node = (Node *) malloc(sizeof(Node));

				node->thisNodeType = CHK;

				$$ = node;}

	else if($4->thisNodeType == INT && $6->thisNodeType == INT){
		//printf("operation || int and int found => %i  %i \n",$4->exprNodePtr->inum, $6->exprNodePtr->inum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->inum = $4->exprNodePtr->inum + $6->exprNodePtr->inum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = INT;

			$$ = node;

	}

	else if($4->thisNodeType == DBL && $6->thisNodeType == DBL){
		//printf("operation || dbl and dbl found => %g  %g \n",$4->exprNodePtr->dnum, $6->exprNodePtr->dnum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->dnum + $6->exprNodePtr->dnum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}

	else if(($4->thisNodeType == DBL && $6->thisNodeType == INT)){
		//printf("operation || dbl and int found => %f  %i \n",$4->exprNodePtr->dnum, $6->exprNodePtr->inum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->dnum + $6->exprNodePtr->inum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}
	else if(($4->thisNodeType == INT && $6->thisNodeType == DBL)){
		//printf("operation || int and dbl found => %i  %f \n",$4->exprNodePtr->inum, $6->exprNodePtr->dnum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->inum + $6->exprNodePtr->dnum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}
	else if(($4->thisNodeType == STR && $6->thisNodeType == STR)){
		//printf("operation || int and dbl found => %i  %f \n",$4->exprNodePtr->inum, $6->exprNodePtr->dnum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));

			exprnode->sval =strcat($4->exprNodePtr->sval, $6->exprNodePtr->sval);


			node->exprNodePtr = exprnode;
			node->thisNodeType = STR;

			$$ = node;

	}
	else{

			Node * node = (Node *) malloc(sizeof(Node));

			node->thisNodeType = ERR;

			$$ = node;
	}
	
}
		| '[' tSUB ',' expr ',' expr ']' {
			if($4->thisNodeType == GET || $6->thisNodeType == GET){Node * node = (Node *) malloc(sizeof(Node));

				node->thisNodeType = GET;

				$$ = node;}

				else if($4->thisNodeType == CHK || $6->thisNodeType == CHK){Node * node = (Node *) malloc(sizeof(Node));

				node->thisNodeType = CHK;

				$$ = node;}
				
		else if($4->thisNodeType == INT && $6->thisNodeType == INT){


		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->inum = $4->exprNodePtr->inum - $6->exprNodePtr->inum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = INT;

			$$ = node;

	}

	else if($4->thisNodeType == DBL && $6->thisNodeType == DBL){
		//printf("operation || dbl and dbl found => %g  %g \n",$4->exprNodePtr->dnum, $6->exprNodePtr->dnum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->dnum - $6->exprNodePtr->dnum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}

	else if(($4->thisNodeType == DBL && $6->thisNodeType == INT)){
		//printf("operation || dbl and int found => %f  %i \n",$4->exprNodePtr->dnum, $6->exprNodePtr->inum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->dnum - $6->exprNodePtr->inum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}
	else if(($4->thisNodeType == INT && $6->thisNodeType == DBL)){
		//printf("operation || int and dbl found => %i  %f \n",$4->exprNodePtr->inum, $6->exprNodePtr->dnum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->inum - $6->exprNodePtr->dnum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}

	else{
			Node * node = (Node *) malloc(sizeof(Node));

			node->thisNodeType = ERR;

			$$ = node;
	}
		}
		| '[' tMUL ',' expr ',' expr ']' {
			if($4->thisNodeType == GET || $6->thisNodeType == GET){Node * node = (Node *) malloc(sizeof(Node));

				node->thisNodeType = GET;

				$$ = node;}

				else if($4->thisNodeType == CHK || $6->thisNodeType == CHK){Node * node = (Node *) malloc(sizeof(Node));

				node->thisNodeType = CHK;

				$$ = node;}
			else if($4->thisNodeType == INT && $6->thisNodeType == INT){
		//printf("operation || int and int found => %i  %i \n",$4->exprNodePtr->inum, $6->exprNodePtr->inum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->inum = $4->exprNodePtr->inum * $6->exprNodePtr->inum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = INT;

			$$ = node;

	}

	else if($4->thisNodeType == DBL && $6->thisNodeType == DBL){
		//printf("operation || dbl and dbl found => %g  %g \n",$4->exprNodePtr->dnum, $6->exprNodePtr->dnum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->dnum * $6->exprNodePtr->dnum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}

	else if(($4->thisNodeType == DBL && $6->thisNodeType == INT)){
		//printf("operation || dbl and int found => %f  %i \n",$4->exprNodePtr->dnum, $6->exprNodePtr->inum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->dnum * $6->exprNodePtr->inum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}
	else if(($4->thisNodeType == INT && $6->thisNodeType == DBL)){
		//printf("operation || int and dbl found => %i  %f \n",$4->exprNodePtr->inum, $6->exprNodePtr->dnum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->inum * $6->exprNodePtr->dnum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}
	else if(($4->thisNodeType == INT && $6->thisNodeType == STR)){
		//printf("operation || int and dbl found => %i  %f \n",$4->exprNodePtr->inum, $6->exprNodePtr->dnum);

		if($4->exprNodePtr->inum < 0){
			Node * node = (Node *) malloc(sizeof(Node));

			node->thisNodeType = ERR;

			$$ = node;
		}
else{

		Node * node = (Node *) malloc(sizeof(Node));
			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));

			int i;
			char* str = (char*) malloc(sizeof(char));

			for(i = 0; i < $4->exprNodePtr->inum; i++){
				str = strcat(str, $6->exprNodePtr->sval);;
			} 

			exprnode->sval = str;

			node->exprNodePtr = exprnode;
			node->thisNodeType = STR;

			$$ = node;
}

	}

	else if(($4->thisNodeType == STR && $6->thisNodeType == INT)){
		//printf("operation || int and dbl found => %i  %f \n",$4->exprNodePtr->inum, $6->exprNodePtr->dnum);

		if($6->exprNodePtr->inum < 0){
			Node * node = (Node *) malloc(sizeof(Node));

			node->thisNodeType = ERR;

			$$ = node;
		}
else{

		Node * node = (Node *) malloc(sizeof(Node));
			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));

			int i;
			char* str = (char*) malloc(sizeof(char));

			for(i = 0; i < $6->exprNodePtr->inum; i++){
				str = strcat(str, $4->exprNodePtr->sval);;
			} 

			exprnode->sval = str;

			node->exprNodePtr = exprnode;
			node->thisNodeType = STR;

			$$ = node;
}

	}

	else{
			Node * node = (Node *) malloc(sizeof(Node));

			node->thisNodeType = ERR;

			$$ = node;
	}
		}
		| '[' tDIV ',' expr ',' expr ']' {
			if($4->thisNodeType == GET || $6->thisNodeType == GET){Node * node = (Node *) malloc(sizeof(Node));

				node->thisNodeType = GET;

				$$ = node;}
				
				else if($4->thisNodeType == CHK || $6->thisNodeType == CHK){Node * node = (Node *) malloc(sizeof(Node));

				node->thisNodeType = CHK;

				$$ = node;}
			else if($4->thisNodeType == INT && $6->thisNodeType == INT){
		//printf("operation || int and int found => %i  %i \n",$4->exprNodePtr->inum, $6->exprNodePtr->inum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->inum = $4->exprNodePtr->inum / $6->exprNodePtr->inum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = INT;

			$$ = node;

	}

	else if($4->thisNodeType == DBL && $6->thisNodeType == DBL){
		//printf("operation || dbl and dbl found => %g  %g \n",$4->exprNodePtr->dnum, $6->exprNodePtr->dnum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->dnum / $6->exprNodePtr->dnum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}

	else if(($4->thisNodeType == DBL && $6->thisNodeType == INT)){
		//printf("operation || dbl and int found => %f  %i \n",$4->exprNodePtr->dnum, $6->exprNodePtr->inum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->dnum / $6->exprNodePtr->inum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}
	else if(($4->thisNodeType == INT && $6->thisNodeType == DBL)){
		//printf("operation || int and dbl found => %i  %f \n",$4->exprNodePtr->inum, $6->exprNodePtr->dnum);

		Node * node = (Node *) malloc(sizeof(Node));

			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));
			exprnode->dnum = $4->exprNodePtr->inum / $6->exprNodePtr->dnum;

			node->exprNodePtr = exprnode;
			node->thisNodeType = DBL;

			$$ = node;

	}
	

	else{
			Node * node = (Node *) malloc(sizeof(Node));

			node->thisNodeType = ERR;

			$$ = node;
	}
		}
;



unaryOperation: '[' tINC ',' tIDENT ']'
		| '[' tDEC ',' tIDENT ']'
;

expr:		tNUM {

			char* str = $1;
			Node * node = (Node *) malloc(sizeof(Node));
			exprNode * exprnode = (exprNode *) malloc((sizeof(exprNode)));

			//printf("expression found: %s\n",str);

			int i,isDouble = 0;
			for(i = 0; i < strlen(str); i++){
				if(str[i] == '.'){
					isDouble = 1;
					break;
				}
			}

			if (isDouble == 1){
				exprnode->dnum = strtof($1,NULL);
				node->exprNodePtr = exprnode;
				node->thisNodeType = DBL;

			}
			else{
				exprnode->inum = atoi($1);
				node->exprNodePtr = exprnode;
				node->thisNodeType = INT;
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
			| getExpr {

				Node * node = (Node *) malloc(sizeof(Node));

				node->thisNodeType = GET;

				$$ = node;

			}
			| function | operation
			
				| condition
;

function:	 '[' tFUNCTION ',' '[' parametersList ']' ',' '[' stmtlst ']' ']'
		| '[' tFUNCTION ',' '[' ']' ',' '[' stmtlst ']' ']'
;

condition:	'[' tEQUALITY ',' expr ',' expr ']' {Node * node = (Node *) malloc(sizeof(Node));
												node->thisNodeType = CHK;
												$$ = node;
												}
		| '[' tGT ',' expr ',' expr ']' {Node * node = (Node *) malloc(sizeof(Node));
												node->thisNodeType = CHK;
												$$ = node;
												}
		| '[' tLT ',' expr ',' expr ']' {Node * node = (Node *) malloc(sizeof(Node));
												node->thisNodeType = CHK;
												$$ = node;
												}
		| '[' tGEQ ',' expr ',' expr ']' {Node * node = (Node *) malloc(sizeof(Node));
												node->thisNodeType = CHK;
												$$ = node;
												}
		| '[' tLEQ ',' expr ',' expr ']' {Node * node = (Node *) malloc(sizeof(Node));
												node->thisNodeType = CHK;
												$$ = node;
												}
;

returnStmt:	'[' tRETURN ',' expr ']'{ printExpr($4);}
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

void printExpr(const Node* node){
	if(node->thisNodeType == ERR){
					printf("Type mismatch on %i\n",line);
				}
				else if(node->thisNodeType == INT){
					printf("Result of expression on %i is (%i)\n",line,node->exprNodePtr->inum);
				}
				else if(node->thisNodeType == DBL){
					printf("Result of expression on %i is (%.1f)\n",line,node->exprNodePtr->dnum);
				}
				else if(node->thisNodeType == STR){
					printf("Result of expression on %i is (%s)\n",line,node->exprNodePtr->sval);
				}
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
