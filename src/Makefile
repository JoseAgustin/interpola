#  
#	Lower level Makefile for 10_storage
#
#
#
objec1 = vars_dat_mod.o Interpola.o calculos.o lee_files.o salidas.o 

RM_LIST = *.mod *.o core .tmpfile *.exe wrfchemi.*
RM	=	/bin/rm -f 
NETCDF = /usr/local

# Ejecuta
intel:
	uname -a > .tmpfile
	grep Linux .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Linux" ;               \
	( $(MAKE) all                               \
	"RM             = $(RM)"        "RM_LIST        = $(RM_LIST)"   \
	"LN             = $(LN)"        "MACH           = DEC"          \
	"MAKE           = $(MAKE)"      "CPP            = /lib/cpp"     \
	"CPPFLAGS       = -I. -C -traditional"  \
	"FC             = ifort"   "CFLAGS         = -I."       \
	"LDOPTIONS      = -O2 -axAVX2  -align commons  -lnetcdff -L$(NETCDF)/lib "          \
	"FCFLAGS        = -O2 -axAVX2  -align commons -I$(NETCDF)/include " \
	"LOCAL_LIBRARIES= " ) ; \
	else \
	grep Darwin .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Darwin" ;              \
	( $(MAKE) all                          \
	"RM             = $(RM)"        "RM_LIST        = $(RM_LIST)"   \
	"LN             = $(LN)"        "MACH           = DEC"          \
	"MAKE           = $(MAKE)"      "CPP            = fpp"  \
	"CPPFLAGS       = -I. -C "      \
	"FC             = ifort"        "CFLAGS         = -I." \
	"LDOPTIONS      = -fast -axAVX2  -align commons  -lnetcdff -L$(NETCDF)/lib  " \
	"FCFLAGS        = -fast -axAVX2  -align commons -I$(NETCDF)/include"          \
	"LOCAL_LIBRARIES=  " ) ; \
	else echo "Do not know how to compile for the `cat .tmpfile` machine." \
	fi ; \
	fi ; \
	fi ; \
	$(RM) .tmpfile

pgi:
	uname -a >  .tmpfile
	grep Linux .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Linux PGI" ;               \
	( $(MAKE) all                          \
	"RM             = $(RM)"        "RM_LIST        = $(RM_LIST)"   \
	"LN             = $(LN)"        "MACH           = PGI"          \
	"MAKE           = $(MAKE)"      "CPP            = fpp"  \
 	"CPPFLAGS       = -I.  "      \
	"FC             = pgf90"        "FCFLAGS        = -O3 -fastsse -Mfree" \
	"LDOPTIONS      = -O3 -fastsse -Mfree -lnetcdff -L$(NETCDF)/lib" \
	"FCFLAGS        = -O3 -fastsse -Mfree -I$(NETCDF)/include"          \
	"LOCAL_LIBRARIES=  " ) ; \
	else \
	grep Darwin .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Darwin PGI" ;              \
	( $(MAKE) all                          \
	"RM             = $(RM)"        "RM_LIST        = $(RM_LIST)"   \
	"LN             = $(LN)"        "MACH           = PGI"          \
	"MAKE           = $(MAKE)"      "CPP            = fpp"  \
	"CPPFLAGS       =  "      \
	"FC             = pgf90"        "FCFLAGS        = -O3 -fastsse -Mfree" \
	"LDOPTIONS      = -O3 -fastsse -Mfree -lnetcdff -L$(NETCDF)/lib" \
	"FCFLAGS         = -O3 -fastsse -Mfree -I$(NETCDF)/include"          \
	"LOCAL_LIBRARIES=  " ) ; \
	else echo "Do not know how to compile for the `cat .tmpfile` machine." \
	fi ; \
	fi ; \
	fi ; \
	$(RM) .tmpfile
	
gnu:	
	uname -a >  .tmpfile
	grep Linux .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Linux GNU" ;               \
	( $(MAKE) all                          \
    "RM             = $(RM)"        "RM_LIST        = $(RM_LIST)"   \
    "LN             = $(LN)"        "MACH           = PGI"          \
    "MAKE           = $(MAKE)"      "CPP            = fpp"  \
    "CPPFLAGS       = -I.  "      \
    "FC             = gfortran"        "FCFLAGS        = -O3 " \
    "LDOPTIONS      = -O3 -lnetcdff -L$(NETCDF)/lib" \
    "FCFLAGS        = -O3 -I$(NETCDF)/include"          \
    "LOCAL_LIBRARIES=  " ) ; \
    else \
    grep Darwin .tmpfile ; \
    if [ $$? = 0 ]; then echo "Compiling for Darwin GNU" ;              \
    ( $(MAKE) all                          \
    "RM             = $(RM)"        "RM_LIST        = $(RM_LIST)"   \
    "LN             = $(LN)"        "MACH           = PGI"          \
    "MAKE           = $(MAKE)"      "CPP            = fpp"  \
    "CPPFLAGS       =  "      \
    "FC             = gfortran"        "FCFLAGS        = -O3 " \
    "LDOPTIONS      = -O3 -lnetcdff -L$(NETCDF)/lib" \
    "FCFLAGS        = -O3 -I$(NETCDF)/include"          \
    "LOCAL_LIBRARIES=  " ) ; \
    else echo "Do not know how to compile for the `cat .tmpfile` machine." \
    fi ; \
    fi ; \
    fi ; \
	$(RM) .tmpfile

# Ejecuta
%.o: %.F90
	$(FC) -c $< $(FCFLAGS)

all :	interpola.exe

interpola.exe: $(objec1)
	$(FC) -o $@ $(objec1) $(LDOPTIONS)

# additional dependencies
Interpola.o calculos.o lee_files.o salidas.o : vars_dat_mod.o

clean:
	-$(RM) $(RM_LIST)

.PHONY:	clean

