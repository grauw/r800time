R800 instruction timing tester
==============================

Copyright 2018 Laurens Holst

Project information
-------------------

Cycle-exact R800 instruction timing tester using the VDP.

Author: Laurens Holst <laurens.nospam@grauw.nl>  
Site: <https://bitbucket.org/grauw/r800time>  
License: Simplified BSD License


System Requirements
-------------------

  * MSX turboR
  * 64K main RAM
  * 16K video RAM
  * MSX-DOS


Development information
-----------------------

Building the project is really easy on all modern desktop platforms. On MacOS
and Linux, simply invoke `make` to build the binary and symbol files into the
`bin` directory:

    make

Windows users can open the `Makefile` and build by pasting the line in the `all`
target into the Windows command prompt.

To launch the build in openMSX after building, put a copy of `MSXDOS2.SYS` and
`COMMAND2.COM` in the `bin` directory, and then invoke the `make run` command.

Note that the [glass](https://bitbucket.org/grauw/glass) assembler which is
embedded in the project requires [Java 8](http://java.com/getjava). To check
your Java version, invoke the `java -version` command.
