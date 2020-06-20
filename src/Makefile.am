#
# This file is processed by automake (produces file Makefile.in)
#
bin_PROGRAMS = interpola
#
# Compiler flags
AM_FCFLAGS = $(NC_INC)

# Parallel version
if WITH_OMPI
  AM_FCFLAGS += $(OPENMP_FCFLAGS)
endif

# Additional files to be cleaned with 'make clean'
CLEANFILES = *.o *.mod *~


interpola_SOURCES = vars_dat_mod.F90 Interpola.F90 calculos.F90 lee_files.F90 salidas.F90
