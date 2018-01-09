#  vim: set ft=make sw=4 tw=0 fdm=manual noet :
#
#  _____                __  __       _
# | ____|_   _____ _ __|  \/  | __ _| | _____
# |  _| \ \ / / _ \ '__| |\/| |/ _` | |/ / _ \
# | |___ \ V /  __/ |  | |  | | (_| |   <  __/
# |_____| \_/ \___|_|  |_|  |_|\__,_|_|\_\___|
#
# Ths is an auto-regenerating, portable Makefile. just add new sources
# to your tree and run make. if new sources are found, it will make itself
# anew to include the new source, no maintenance required. I use ths as
# a template in subdirectories with sources, my main Makefile (using bsdmake)
# descends into subdirs and include them. As this is a dependency of itself,
# new sources will trigger EvermMake to make itself anew! how meta!
#
# Inspired by https://goo.gl/v8yBt8
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

