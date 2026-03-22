CC=gcc
FLEX=flex
BISON=bison
CFLAGS=-Wall -Wextra -std=c11

TARGET=analyzer

all: $(TARGET)

parser.tab.c parser.tab.h: parser.y
	$(BISON) -d -Wall parser.y

lex.yy.c: lexer.l parser.tab.h
	$(FLEX) lexer.l

$(TARGET): parser.tab.c lex.yy.c
	$(CC) $(CFLAGS) parser.tab.c lex.yy.c -o $(TARGET)

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET) parser.tab.c parser.tab.h lex.yy.c

.PHONY: all run clean
