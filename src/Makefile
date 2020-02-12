#
#	Lower level Makefile for interpola.exe conversion program
#       Suffix rules and commands
#######################
FIX01 =
#######################

.IGNORE:

.SUFFIXES:      .F90 .f .i .o

.F90.o:
		$(RM) $@ 
		$(CPP) $(CPPFLAGS) -D$(MACH) $(FIX01) $*.F90 > $*.f
		$(FC) -c $(FCFLAGS) $*.f
		

.F90.f:
		$(RM) $@
		$(CPP) $(CPPFLAGS) -D$(MACH) $(FIX01) $*.F90 > $*.f

.f.o:
		$(RM) $@
		$(FC) -c $(FCFLAGS) $(FIX01) $*.f
		

OBJS	=	vars_dat_mod.o lee_files.o Interpola.o salidas.o calculos.o \


SRC	=	$(OBJS:.o=.f)


cray dec hp ibm sgi sun default:
		@echo "you need to be up a directory to make interpola.exe"

all:: 		interpola.exe 

interpola.exe:	$(OBJS) 
		$(FC) -o $@ $(LDOPTIONS) $(OBJS) $(LOCAL_LIBRARIES)

code:		$(SRC2) 

# -------------------------------------------------------------------------
# DO NOT DELETE THIS LINE -- make depend depends on it.

clean:
		$(RM) $(RM_LIST)
