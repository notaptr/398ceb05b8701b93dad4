# Very simply and clean to understand.

all:
	nasm -felf64 alpha_pos.s
	gcc -c -g0 main.c
	gcc -no-pie -g0 -s alpha_pos.o main.o -o main
debug:
	nasm -felf64 alpha_pos.s
	gcc -c main.c -o main-dbg.o
	gcc -no-pie -ggdb alpha_pos.o main-dbg.o -o main-dbg
clean:
	rm *.o

