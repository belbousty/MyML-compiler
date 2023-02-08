
%{

  // header included in y.tab.h
#include "Attribut.h"
#include "Table_des_symboles.h"
#include "Table_des_chaines.h"
#include <stdio.h>
#include <string.h>




FILE * file_in = NULL;
FILE * file_out = NULL;

extern int yylex();
extern int yyparse();

void yyerror (char* s) {
   printf("\n%s\n",s);
 }
static int offset = 0;                                                                                                                                                      
                                                                                                                                                                       
int increase_offset(){                                                                                                                                                          
  return offset++;                                                                                                                                                          
}                                                                                                                                                                      
                                                                                                                                                                       
int decrease_offset(){                                                                                                                                                 
  return offset--;                                                                                                                                                          
}                                                                                                                                                                      
                                                                                                                                                                       


%}

%union
{
    int intValue;
    float floatValue;
    char *stringValue;
}


%token <intValue>NUM <floatValue>FLOAT  <stringValue>ID <stringValue>STRING

%token PV LPAR RPAR LET IN VIR
%token IF THEN ELSE

%token ISLT ISGT ISLEQ ISGEQ ISEQ
%left ISEQ
%left ISLT ISGT ISLEQ ISGEQ


%token AND OR NOT BOOL
%left OR
%left AND



%token PLUS MOINS MULT DIV EQ
%left PLUS MOINS
%left MULT DIV
%left CONCAT
%nonassoc UNA    /* pseudo token pour assurer une priorite locale */


%start prog



%%

 /* a program is a list of instruction */

prog : inst PV {/*printf("Une instruction\n")*/;}
| prog inst PV {/*printf("\nUne autre instruction\n")*/;}
;

/* a instruction is either a value or a definition (that indeed looks like an affectation) */

inst : let_def
| exp
;



let_def : def_id {$<stringValue>$ = $<stringValue>1;}
| def_fun
;

def_id : LET ID EQ exp {add_symbol_value($2, increase_offset());}

def_fun : LET fun_head EQ exp {
  printf("return;\n}\n\n");
  for (int i = 0; i <= $<intValue>2; i++) {
    depiler();
    decrease_offset();
  }
}
;

fun_head : ID LPAR id_list RPAR {
  add_symbol_value($1, increase_offset());
  $<intValue>$ = $<intValue>3;
  printf("void call_%s() {\n", $<stringValue>1);
  depiler();
  decrease_offset();
}
;

id_list : ID {
   add_symbol_value($1, increase_offset());
    $<intValue>$ = 1;
  }
| id_list VIR ID {
  add_symbol_value($3, increase_offset());
  $<intValue>$ = 1 + $<intValue>1;
}
;


exp : arith_exp {if($<stringValue>0 == NULL){printf("DROP\n");}}
| let_exp
;

arith_exp : MOINS arith_exp %prec UNA
| arith_exp MOINS arith_exp {printf("SUBI\n");}
| arith_exp PLUS arith_exp {printf("ADDI\n");}
| arith_exp DIV arith_exp  {printf("DIVI\n");}
| arith_exp MULT arith_exp {printf("MULTI\n");}
| arith_exp CONCAT arith_exp {printf("CONCI\n");}
| atom_exp
;

atom_exp : NUM {printf("LOADI %d\n", $<intValue>$);}
| FLOAT
| STRING
| ID {if(get_symbol_value($1)<0){
      printf("[ERROR]: Undefined symbol %s\n", $1);
      return EXIT_FAILURE;
      }
    printf("LOAD (fp + %i)\n", get_symbol_value($1));
}
| control_exp
| funcall_exp {printf("CALL call_%s\n", $<stringValue>$);
                printf("RESTORE %i\n", 1);}
| LPAR exp RPAR
;

control_exp : if_exp
;


if_exp : if cond then atom_exp else atom_exp {
  printf("L%i :\n", getRank0());
  if ($<intValue>2 == 1){ $<intValue>$ = $<intValue>4;}
  else {
    $<intValue>$ = $<intValue>6;
  }}
;

if : IF
cond : LPAR bool RPAR {
  if($<stringValue>2=="=="){
  printf("EQ\n");
  }else if($<stringValue>2==">"){
    printf("GT\n");
  }else if($<stringValue>2==">="){
    printf("GEQ\n");
  }else if($<stringValue>2=="<"){
    printf("LT\n");
  }else if($<stringValue>2=="<="){
    printf("LEQ\n");
  }
}
then : THEN {printf("IFN L%i\n", getNum());}
else : ELSE {printf("GOTO L%i\n", getNum0()); printf("L%d :\n", getRank());}


let_exp : let_def IN arith_exp {
  depiler();
  decrease_offset();                                                                                                                       
  printf("DRCP\n");
  }
| let_def IN let_exp

;

funcall_exp : ID LPAR arg_list RPAR {$<intValue>$ = $<intValue>3;printf("SAVEFP\n");}
;

arg_list : arith_exp {$<intValue>$ = 1;}
| arg_list VIR  arith_exp 
;

bool : BOOL
| bool OR bool
| bool AND bool
| NOT bool %prec UNA
| exp comp exp {
    $<stringValue>$ = $<stringValue>2;
}
| LPAR bool RPAR
;



comp :  ISLT {$<stringValue>$ = "<"; }
| ISGT {$<stringValue>$ = ">";}
| ISLEQ {$<stringValue>$ = "<=";}
| ISGEQ {$<stringValue>$ = ">=" ;}
| ISEQ {$<stringValue>$ = "==";}
;

%%
int main (int argc, char * argv[]) {
  /* The code below is just a standard usage example.
     Of cours, it can be changed at will.

     for instance, one could grab input and ouput file names
     in command line arguements instead of having them hard coded */

  stderr = stdin;
  char output_file[15];
  int i = 0;
  while (argv[1][i]!= 'm') {
    output_file[i] = argv[1][i];
    i++;
  }
  output_file[i] = 'p';
  output_file[i+1] = '\0';


  /* opening target code file and redirecting stdout on it */
 file_out = fopen(output_file,"w");
 stdout = file_out;
 
 /* openng source code file and redirecting stdin from it */
 file_in = fopen(argv[1],"r");
 stdin = file_in;

 /* As a starter, on may comment the above line for usual stdin as input */

 yyparse ();

 /* any open file shall be closed */
 fclose(file_out);
 fclose(file_in);

 return 1;
}
