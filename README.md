```
  _____                __  __       _
 | ____|_   _____ _ __|  \/  | __ _| | _____
 |  _| \ \ / / _ \ '__| |\/| |/ _` | |/ / _ \
 | |___ \ V /  __/ |  | |  | | (_| |   <  __/
 |_____| \_/ \___|_|  |_|  |_|\__,_|_|\_\___|
 
 Because, why would anyone reimplement make in 
 Javascript when make makes it's own Makefiles? 
 Let Make do the grunt work! *wink* *wink*

```
## NAME

Makefile

## DESCRIPTION
This is an auto-regenerating, portable Makefile. just add new sources
to your tree and run make. if new sources are found, it will make itself
anew to include the new source, no maintenance required. I use ths as
a template in subdirectories with sources, my main Makefile (using bsdmake)
descends into subdirs and include them. As this is a dependency of itself,
new sources will trigger EvermMake to make itself anew! _how meta!_

## USAGE

Just add new sources and run ```make```

## EXAMPLE 

The "header" part of the Makefile is not automatically generated and is 
carried from one version to the next. It has the executable mainx depend on 
the Makefile and below it depends on the `.o` files. The `Makefile` itself depends 
on the sources in the current directory. If you add a new source file, say 
`sub4.c`, `make` will then execute the action for the `Makefile` target. 

The action is a very sophisticated use of shell looping. It passes the 
`Makefile` through `sed` to cut out the header part, then `echo` and append the 
sentinel lines to `Makefile`. The `for` loop keys on every .c file in the current 
directory. 

It uses `basename` to create variables with the `.o` name. The action uses `gcc -MM` to 
parse a source file to generate a target with prerequisites.

The following `echo`s generate dependencies for `mainx <- .o file <- .c file, etc.`

Next, it creates a collected action, `clean`, for removing the `.o` file.

Finally, the action does a recursive `make` to build the executable with the new 
`Makefile`!

```Makefile
#
# Evermake Makefile 
#
LD	= gcc
SHELL	= /bin/sh
mainx : Makefile
	$(LD) -o mainx *.o

clean ::
	-$(RM) mainx

Makefile : *.c
	@sed -e '/^### Do Not edit this line$$/,$$d' Makefile \
		> MMM.$$$$ && mv MMM.$$$$ Makefile
	@echo "### Do Not edit this line" >> Makefile
	@echo "### Everything below is auto-generated" >> Makefile
	@for f in *.c ; do echo ===$$f=== 1>&2 ; ff=`basename $$f .c`.o ; \
	gcc -MM $$f ; echo ""; echo "mainx : $$ff" ; echo "$$ff : $$f" ; \
	echo '	$$(CC) $$(CFLAGS) -c '"$$f" ; echo "" ; echo "clean ::" ; \
	echo '	-$$(RM) '"$$ff" ; echo "" ; done >> Makefile
	@$(MAKE)

### Do Not edit this line
### Everything below is auto-generated
main.o: main.c proj.h

mainx : main.o
main.o : main.c
	$(CC) $(CFLAGS) -c main.c

clean ::
	-$(RM) main.o

sub1.o: sub1.c proj.h

mainx : sub1.o
sub1.o : sub1.c
	$(CC) $(CFLAGS) -c sub1.c

clean ::
	-$(RM) sub1.o

sub2.o: sub2.c proj.h

mainx : sub2.o
sub2.o : sub2.c
	$(CC) $(CFLAGS) -c sub2.c

clean ::
	-$(RM) sub2.o

sub3.o: sub3.c proj.h

mainx : sub3.o
sub3.o : sub3.c
	$(CC) $(CFLAGS) -c sub3.c

clean ::
	-$(RM) sub3.o
```

Suppose the source `sub4.c` is added to the existing project. It need not be 
explicitly added to the `Makefile`, just type `make`. It regenerates the `Makefile` 
and builds the executable accordingly.

```sh
% make
===main.c===
===sub1.c===
===sub2.c===
===sub3.c===
===sub4.c===
make[1]: Entering directory `/u/owen/rk/make/src/ex5
'
cc  -c sub4.c
gcc -o mainx *.o
make[1]: Leaving directory `/u/owen/rk/make/src/ex5'
make: `mainx' is up to date.
```

## AUTHORS 
Dr R.K. Owens https://owen.sj.ca.us/~rk


<!-- vim: set ft=markdown sw=4 tw=0 fdm=manual et :-->
