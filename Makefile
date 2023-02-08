all		:	myml

y.tab.h y.tab.c :	src/myml.y
			bison -y  -d -v   src/myml.y -o src/y.tab.c
lex.yy.c	:	src/myml.l y.tab.h
			flex -o src/lex.yy.c src/myml.l 
myml		:	lex.yy.c y.tab.c src/Table_des_symboles.c src/Table_des_chaines.c src/Attribut.c 
			gcc -o myml src/lex.yy.c src/y.tab.c src/Table_des_symboles.c src/Table_des_chaines.c src/Attribut.c
clean		:	
			rm -f 	src/lex.yy.c src/*.o src/y.tab.h src/y.tab.c myml src/*~ src/y.output
