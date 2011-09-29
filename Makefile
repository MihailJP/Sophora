DIRS=utils srcgif

.PHONY: all clean $(DIRS)

srcgif: utils
	cd $@;make

utils:
	cd $@;make

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
