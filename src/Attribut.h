/*
 *  Attribut.h
 *
 *  Module defining teh type of attributes in
 *  symbol table.
 *
 */

#ifndef ATTRIBUT_H
#define ATTRIBUT_H

#include <stdio.h>


typedef int symb_value_type;
 /* Dummy definition of symbol_value_type.
    Could be instead a structure with as many fields
    as needed for the compiler such as:
    - name in source code
    - name (or position in the stack) in the target code
    - type (if ever)
    - other info....
 */

#define MAX_SIZE 20

int getNum();
int getRank();
int getNum0();
int getRank0();

#endif
