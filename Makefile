COPY_TARGET = /Volumes/MSXDOS2

all:
	mkdir -p bin
	java -jar tools/glass.jar src/1.asm bin/1.com
	java -jar tools/glass.jar src/2.asm bin/2.com
	java -jar tools/glass.jar src/3.asm bin/3.com
	java -jar tools/glass.jar src/4.asm bin/4.com
	java -jar tools/glass.jar src/5.asm bin/5.com
	java -jar tools/glass.jar src/6.asm bin/6.com

copy: all
	cp bin/*.com $(COPY_TARGET)/
	diskutil umountDisk `mount | grep $(COPY_TARGET) | cut -d" " -f 1`

run: all
	openmsx -machine Panasonic_FS-A1GT -ext ide -script openmsx.tcl
