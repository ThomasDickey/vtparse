RUBY_GENERATION_FILES = \
	vtparse_gen_c_tables.rb \
	vtparse_tables.rb

PROGRAM = vtparse_test 
LIBRARY = libvtparse.a

CC = gcc
CFLAGS = -O3 -Wall

all: vtparse_table.c vtparse_table.h vtparse_test $(LIBRARY)

clean:
	rm -f vtparse_table.[ch] *.o $(PROGRAM) $(LIBRARY)

vtparse_table.c \
vtparse_table.h: $(RUBY_GENERATION_FILES)
	ruby -I. vtparse_gen_c_tables.rb

check:
	ruby -I. vtparse_check_tables.rb

$(PROGRAM): vtparse.c vtparse_test.c $(LIBRARY)
	gcc -Wall -o $@ vtparse_test.c $(LIBRARY)

$(LIBRARY): vtparse.o vtparse_table.o
	rm -f $@
	ar r $@ $^
	ranlib $@

vtparse.o: \
	vtparse.h \
	vtparse_table.h

.c.o:
	$(CC) $(CFLAGS) -o $@ -c $<


.PHONY: all clean

