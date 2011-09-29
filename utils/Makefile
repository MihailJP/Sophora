DIRS=hsp

.PHONY: all clean

all: $(DIRS)
	cd $<;make

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
