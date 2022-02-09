gcc -c main.c -o main.o
gcc -c misc_func.c -o misc_func.o
gcc -o G_PnP misc_func.o main.o  -lm
