## Process this file with automake to produce Makefile.in
## $Id: Makefile.am 1846 2003-09-10 10:24:37Z egonw $

PREFIX="@prefix@"
JARLIBDIR="${PREFIX}/lib/cdk"
JARLIBS=

EXTRA_DIST=${JARLIBS}

alljardir = "${JARLIBDIR}"

alljar_DATA = ${JARLIBS}

${JARLIBS}:
	cd ../../../../../jar/libio; \
	    if (test -e $@) ; \
	    then \
	        cp --target-directory=../../packages/tar/cdk/jar/libio/. $$file; \
	    fi;
	
