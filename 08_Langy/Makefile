
a.exe: parser.tab.c lex.yy.c
	gcc parser.tab.c lex.yy.c

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: scanner.l parser.tab.h
	flex scanner.l

run:
	clear
	./a.out < src.in
	cat a.pep
clean:
	rm lex.yy.c parser.tab.* a.out a.pep
