#####################################################################
# ECEn 425 Lab 4c Makefile

lab5.bin:	lab5final.s
		nasm lab5final.s -o lab5.bin -l lab5.lst

lab5final.s:	clib.s myisr.s myinth.s yakc.s yaks.s lab5app.s
		cat clib.s myisr.s myinth.s yakc.s yaks.s lab5app.s > lab5final.s

myinth.s:	myinth.c
		cpp myinth.c myinth.i
		c86 -g myinth.i myinth.s

yakc.s:		yakc.c	
		cpp yakc.c yakc.i
		c86 -g yakc.i yakc.s

lab5app.s:		lab5app.c
		cpp lab5app.c lab5app.i
		c86 -g lab5app.i lab5app.s
		

clean:
		rm lab5.bin lab5.lst lab5final.s myinth.s myinth.i \
		yakc.s yakc.i lab5app.s lab5app.i

