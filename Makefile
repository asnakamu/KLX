
all: klx first.ps

klx.tab.c klx.tab.h: klx.y
	bison -d klx.y

lex.yy.c: klx.l
	flex klx.l

klx: lex.yy.c klx.tab.c symtab.c symtab.h klx.tab.h
	gcc lex.yy.c klx.tab.c symtab.c -o klx

first.ps: klx final.klx
	./klx < final.klx > final.ps

clean:
	rm -f *.ps lex.yy.c klx.tab.* 
	rm klx
