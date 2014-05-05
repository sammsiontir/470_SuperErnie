####  Makefile 	####
# Usage:           #
#   >make          #
#   >make clean	   #
####################

FILES =  read.cpp

all: 
	g++ -O3 -Wall -lm -g -o read ${FILES}

backup:
	cp -rf *.c *.h Makefile backup/*

clean:
	rm -f read *~
