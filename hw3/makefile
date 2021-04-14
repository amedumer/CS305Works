all: flex bison exec
flex: scanner.flx
	flex scanner.flx
bison: parser.y
	bison -d parser.y
exec: lex.yy.c parser.tab.c
	gcc -o exec lex.yy.c parser.tab.c -lfl
clean:
	rm -f exec
	rm -f lex.yy.c 
	rm -f parser.tab.c