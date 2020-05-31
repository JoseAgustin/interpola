#	Top-level Makefile for Emiss_mexico conversion program

#	Macros, these should be generic for all machines

.IGNORE:
MAKE    =   make -i -f Makefile
LN      =   ln -s
CD      =   cd
RM	=	/bin/rm -f 
RM_LIST =	*.log
#	Targets for supported architectures

default:
	@echo " "
	@echo "Type one of the following:"
	@echo "make gnu                for gfortran"
	@echo "make intel              for compiling with ifort"
	@echo "make pgi                for PGI fortran"
	@echo "make clean                to remove all .o files, the core file and the executable"
	@echo " "

gnu:
	( $(CD) src   ; $(MAKE) gnu );\

intel:
	( $(CD) src   ; $(MAKE) intel );\

pgi:
	( $(CD) src ; $(MAKE) pgi);\

clean:
	( $(CD) src   ; $(MAKE) clean  );\
	$(RM) $(RM_LIST)

