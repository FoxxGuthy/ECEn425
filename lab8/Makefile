#####################################################################
# ECEn 425 Lab 8 Makefile

lab8.bin:	lab8final.s
		nasm lab8final.s -o lab8.bin -l lab8.lst

lab8final.s:	clib.s myisr.s simptris.s simptris_isr.s myinth.s yakc.s yaks.s lab8app.s
		cat clib.s myisr.s simptris.s simptris_isr.s myinth.s yakc.s yaks.s lab8app.s > lab8final.s

myinth.s:	myinth.c
		cpp myinth.c myinth.i
		c86 -g myinth.i myinth.s

yakc.s:		yakc.c
		cpp yakc.c yakc.i
		c86 -g yakc.i yakc.s

lab8app.s:		lab8app.c
		cpp lab8app.c lab8app.i
		c86 -g lab8app.i lab8app.s

simptris_inth.s: simptris_inth.c
		cpp simptris_inth.c simptirs_inth.i
		c86 -g simptirs_inth.i simptirs_inth.s


clean:
		rm lab8.bin lab8.lst lab8final.s myinth.s myinth.i \
		yakc.s yakc.i lab8app.s lab8app.i simptirs_inth.s simptirs_inth.i

# TODO: make sure the new files are added like simptris_inth, simptris_isr, simptris.h simptris.s
