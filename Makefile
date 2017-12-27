CC=gcc

UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
	LIBS=-ll -lcurl
else
	LIBS=-lfl -lcurl
endif

nitrogenazo: nitrogenazo.c
	$(CC) -o $@ $^ $(LIBS)

nitrogenazo.c: nitrogenazo.l
	flex -o $@ $^

.PHONY: clean

clean:
	rm -f nitrogenazo nitrogenazo.c horario.txt