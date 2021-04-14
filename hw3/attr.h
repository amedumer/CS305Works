#ifndef __HW3__
#define __HW3__
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"


typedef enum { STR, INT, DBL } itemType;

typedef union 
{
    int inum;
    double dnum;
    char* sval[200];
} exprNode ;

typedef struct Node
{
    itemType thisNodeType;
    exprNode* exprNodePtr;
} Node ;



#endif