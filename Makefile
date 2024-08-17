# Makefile for building the Hello World program

# Compiler
CC = gcc

# Compiler flags
CFLAGS = -Wall -g

# Target executable
TARGET = hello_world

# Source files
SRCS = hello_world.c

# Object files
OBJS = $(SRCS:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

clean:
	rm -f $(OBJS) $(TARGET)
test: $(TARGET)
	./test_hello_world.sh

