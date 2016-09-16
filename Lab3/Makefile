#####################################################################
# ECEn 425 Lab 3 Makefile

lab3.bin:	lab3final.s
		nasm lab3final.s -o lab3.bin -l lab3.lst

lab3final.s:	clib.s isr.s int_h.s primes.s
		cat clib.s isr.s int_h.s primes.s > lab3final.s

int_h.s:	int_h.c
		cpp int_h.c int_h.i
		c86 -g int_h.i int_h.s

primes.s:	primes.c
		cpp primes.c primes.i
		c86 -g primes.i primes.s

clean:
		rm lab3.bin lab3.lst lab3final.s int_h.s int_h.i \
		primes.s primes.i
