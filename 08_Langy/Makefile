
a.exe: parser.tab.c lex.yy.c
	gcc parser.tab.c lex.yy.c

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: scanner.l parser.tab.h
	flex scanner.l

