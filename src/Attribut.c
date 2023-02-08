/*
 *  Attribut.c
 *
 */

#include "Attribut.h"
#include <string.h>
#include <stdlib.h>


static int ranks[MAX_SIZE];
int end = 0;

static int ranks0[MAX_SIZE];
int lcursor = 0;
int rcursor = 0;
int rank = -1;
int rank0 = -1;





int subStrIn(char* str, char* sub){
  return (strstr(str, sub)!=NULL);
}

char* whatCondition(char* cond){
  char *gt = ">";
  char *lt = "<";
  char *geq = ">=";
  char *leq = "<=";
  char *eq = "==";
  char *neq = "!=";
  if(subStrIn(cond, gt)){
    char *out = "GT";
    return out;
  }else if(subStrIn(cond, lt)){
    char *out = "LT";
    return out;
  }else if(subStrIn(cond, leq)){
    char *out = "LEQ";
    return out;
  }else if(subStrIn(cond, geq)){
    char *out = "GEQ";
    return out;
  }else if(subStrIn(cond, eq)){
    char *out = "EQ";
    return out;
  }else if(subStrIn(cond, neq)){
    char *out = "NEQ";
    return out;
  }
}



int getNum(){
  ranks[end] = rank + 1;
  end++;
  rank0++;
  return ++rank;
}


int getNum0(){
  ranks0[rcursor] = rank0 + 1;
  rcursor++;
  rank++;
  return ++rank0;
}

int getRank(){
  if(end!=0){
    end--;
  }
  return ranks[end];
}

int getRank0(){
  int output = ranks0[lcursor];
  lcursor++;
  return output;
}
