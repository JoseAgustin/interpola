#
#	Top-level Makefile for emissions addition program
#
#	Macros, these should be generic for all machines
#  
#
#  Created by Agustin on 08/11/12.
#

.IGNORE:

AR	=	ar ru
CD	=	cd
LN	=	ln -s
MAKE	=	make -i -f Makefile
RM	=	/bin/rm -f
RM_LIST	=	*.mod *.o *.f core .tmpfile interpola.exe ../interpola.exe
INTEL_LIB =	/opt/intel/lib
#	Targets for supported architectures

default:
	uname -a > .tmpfile
	grep CRAY .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for CRAY" ; 		\
		( $(CD) src ; $(MAKE) all				\
		"RM		= $(RM)" 	"RM_LIST	= $(RM_LIST)"	\
		"LN		= $(LN)" 	"MACH		= linux"		\
		"MAKE		= $(MAKE)"	"CPP		= /opt/ctl/bin/cpp" \
		"CPPFLAGS	= -I. -C -P -DRECLENBYTE"	\
		"FC		= f90" 		"FCFLAGS	= -I. -f free"		\
		"LDOPTIONS      = " 		"CFLAGS         = "		\
		"LOCAL_LIBRARIES= " ) ; \
	else \
		grep OSF .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Compaq" ; 		\
		( $(CD) src ; $(MAKE) all 				\
		"RM		= $(RM)" 	"RM_LIST	= $(RM_LIST)"	\
		"LN		= $(LN)" 	"MACH		= DEC"		\
		"MAKE		= $(MAKE)"	"CPP		= /usr/bin/cpp" \
		"CPPFLAGS	= -I. -C -P "			\
		"FC		= f90"		"FCFLAGS	= -I. -free -convert big_endian -fpe"	\
		"LDOPTIONS      = "		"CFLAGS         = "		\
		"LOCAL_LIBRARIES= " ) ; \
	else \
		grep IRIX .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for SGI" ; 		\
		( $(CD) src ; $(MAKE) all				\
		"RM		= $(RM)" 	"RM_LIST	= $(RM_LIST)"	\
		"LN		= $(LN)" 	"MACH		= linux" 		\
		"MAKE		= $(MAKE)"	"CPP		= /lib/cpp"	\
	 	"CPPFLAGS	= -I. -C -P "			\
		"FC		= f90" 		"FCFLAGS	= -I. -n32 -freeform"	\
		"LDOPTIONS      = -n32"		"CFLAGS         = -I. -n32"	\
		"LOCAL_LIBRARIES= " ) ; \
	else \
		grep HP .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for HP" ; 			\
		( $(CD) src ; $(MAKE) all				\
		"RM		= $(RM)" 	"RM_LIST	= $(RM_LIST)"	\
		"LN		= $(LN)" 	"MACH		= linux"		\
		"MAKE		= $(MAKE)"	"CPP		= /opt/langtools/lbin/cpp" \
		"CPPFLAGS= -I. -C -P -DRECLENBYTE"		\
		"FC		= f90" 		"FCFLAGS	= -I. -O +langlvl=90 +source=free"	\
		"LDOPTIONS	= " 		"CFLAGS		= -Aa"		\
		"LOCAL_LIBRARIES= " ) ; \
	else \
		grep SUN .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for SUN" ; 		\
		( $(CD) src ; $(MAKE) all				\
		"RM		= $(RM)" 	"RM_LIST	= $(RM_LIST)"	\
		"LN		= $(LN)" 	"MACH		= linux"		\
		"MAKE		= $(MAKE)"	"CPP		= /usr/ccs/lib/cpp" \
		"CPPFLAGS=-I. -C -P -DRECLENBYTE"		\
		"FC		= f90" 		"FCFLAGS	= -I. -free"		\
		"LDOPTIONS	= "    		"CFLAGS		= -I."		\
		"LOCAL_LIBRARIES= " ) ; \
	else \
		grep AIX .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for IBM" ;			\
		( $(CD) src ; $(MAKE) all				\
		"RM		= $(RM)" 	"RM_LIST	= $(RM_LIST)"	\
		"LN		= $(LN)" 	"MACH		= linux"		\
		"MAKE		= $(MAKE)"	"CPP		= /usr/lib/cpp" \
		"CPPFLAGS	= -I. -C -P -DRECLENBYTE"	\
		"FC		= xlf"		"FCFLAGS	= -I. -O -qmaxmem=-1 -qfree=f90"\
		"LDOPTIONS	= " 		"CFLAGS		= -I."		\
		"LOCAL_LIBRARIES= " ) ; \
	else \
		grep Linux .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Linux" ;		\
		( $(CD) src ; $(MAKE) all				\
		"RM		= $(RM)" 	"RM_LIST	= $(RM_LIST)"	\
		"LN		= $(LN)" 	"MACH		= DEC"		\
		"MAKE		= $(MAKE)"	"CPP		= /lib/cpp"	\
		"CPPFLAGS	= -I. -C -traditional"	\
		"FC		= ifort"	"FCFLAGS	= -D$(MACH) -I. -convert big_endian -pc32 -FR -tpp7 -xW"\
		"LDOPTIONS	= -convert big_endian -pc32 -tpp7 -xW"	"CFLAGS		= -I."		\
		"LOCAL_LIBRARIES= " ) ; \
	else \
		grep Darwin .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Darwin" ;		\
		( $(CD) src ; $(MAKE) all				\
		"RM		= $(RM)" 	"RM_LIST	= $(RM_LIST)"	\
		"LN		= $(LN)" 	"MACH		= DEC"		\
		"MAKE		= $(MAKE)"	"CPP		= fpp"	\
		"CPPFLAGS	= -I. -C "	\
		"FC		= ifort"	"FCFLAGS	= -I. -I$(NETCDF)/include -convert big_endian -FR -align commons"\
		"LDOPTIONS	= -L$(NETCDF)/lib  -convert big_endian -align commons "\
		"CFLAGS		= -I."		\
		"LOCAL_LIBRARIES= -lnetcdff -lnetcdf " ) ; \
	else echo "Do not know how to compile for the `cat .tmpfile` machine." \
		fi ; \
		fi ; \
		fi ; \
		fi ; \
		fi ; \
		fi ; \
		fi ; \
		fi ; \
	fi ; \
		( $(RM) interpola.exe ; $(LN) src/interpola.exe . ) ;

code:
	( $(CD) src ; $(MAKE) code					\
	"MAKE			=	$(MAKE)"			\
	"CPP			=	/usr/bin/cpp"			\
	"CPPFLAGS		=	-I. -C -P -DDEC"		)

clean:
	( $(CD) src   ; $(MAKE) clean "CD = $(CD)" "RM = $(RM)" "RM_LIST = $(RM_LIST)" )
	$(RM) $(RM_LIST)
