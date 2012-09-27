# Makefile for compiling under cygwin

# I am assuming that cppunit is located at ./cppunit-cyg directory. Change it
# below for your customization.
CPPUNIT_DIR=./cppunit-cyg

all:doc
	ctangle anagram.w
	cp anagram.c anagram.cpp
	gcc -c -o anagram.o -I$(CPPUNIT_DIR)/include anagram.cpp
	gcc -L$(CPPUNIT_DIR)/.libs -o test.bin anagram.o -lcppunit -lstdc++
clean: 
	rm -rf test.bin *.o anagram.cpp anagram.c 
	rm -rf anagram.pdf anagram.toc  anagram.tex anagram.scn anagram.log anagram.idx

# note: cweave with `-b` will display the banner
doc: anagram.w
	cweave -b $<
	pdftex anagram.tex
