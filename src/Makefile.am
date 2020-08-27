#
# This file is processed by automake (produces file Makefile.in)
#
ACLOCAL_AMFLAGS = -I autoconf
AM_CPPFLAGS=-O2
if GFOR
AM_CPPFLAGS += -DGFOR -fdec
endif

bin_PROGRAMS = interpola.exe

interpola_exe_SOURCES = vars_dat_mod.F90 Interpola.F90 calculos.F90 lee_files.F90 salidas.F90

#
# Compiler flags
AM_FCFLAGS = $(NC_INC) $(NC_LIB)

# Parallel version
if WITH_OMPI
  AM_FCFLAGS += $(OPENMP_FCFLAGS)
endif

# Additional files to be cleaned with 'make clean'
CLEANFILES = *.o *.mod *~

TESTSUITE = $(srcdir)/testsuite

SUBDIRS = . testsuite

EXTRA_DIST =  $(TESTSUITE)

.PHONY: $(EXTRA_DIST)
$(EXTRA_DIST):
