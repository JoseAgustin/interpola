#
# This file is processed by automake (produces file Makefile.in)
#
# Compiler flags -I$(top_srcdir)
#FC =$(NC_FC)
AM_FCFLAGS  = $(NC_INC) -I$(top_srcdir)
AM_FCFLAGS += $(NC_LIB)
FCFLAGS = $(AM_FCFLAGS)

AM_CPPFLAGS=-O2 $(NC_INC)
if GFOR
AM_CPPFLAGS += -DGFOR -fdec -I/usr/local/include
FCFLAGS += -fdec
endif
# Compiler flags

# Parallel version
if WITH_OMPI
  AM_FCFLAGS += $(OPENMP_FCFLAGS)
endif

TESTS = test1 test2 test3 test4 test5

check_PROGRAMS= test1 test2 test3 test4 test5

test1_SOURCES= $(top_builddir)/mod_vars_dat.F90 $(top_builddir)/s_check.F90 p_check.F90
test2_SOURCES= $(top_builddir)/mod_vars_dat.F90 $(top_builddir)/lee_emis.F90 $(top_builddir)/s_check.F90 p_lee_emis.F90
test3_SOURCES= $(top_builddir)/mod_vars_dat.F90 $(top_builddir)/lee_malla.F90 $(top_builddir)/s_check.F90 p_lee_grid.F90
test4_SOURCES= $(top_builddir)/mod_vars_dat.F90 $(top_builddir)/calculos.F90 p_calc.F90
test5_SOURCES= $(top_builddir)/mod_vars_dat.F90 $(top_builddir)/salidas.F90 $(top_builddir)/s_check.F90 p_guarda.F90
# Additional files to be cleaned with 'make clean'
CLEANFILES = *.o *.mod package.m4 testsuite

# The `:;' works around a Bash 3.2 bug when the output is not writeable.
$(srcdir)/package.m4: $(top_srcdir)/configure.ac
	:;{ \
	echo '# Signature of the current package.' && \
	echo 'm4_define([AT_PACKAGE_NAME],' && \
	echo '  [@PACKAGE_NAME@])' && \
	echo 'm4_define([AT_PACKAGE_TARNAME],' && \
	echo '  [@PACKAGE_TARNAME@])' && \
	echo 'm4_define([AT_PACKAGE_VERSION],' && \
	echo '  [@PACKAGE_VERSION@])' && \
	echo 'm4_define([AT_PACKAGE_STRING],' && \
	echo '  [@PACKAGE_STRING@])' && \
	echo 'm4_define([AT_PACKAGE_BUGREPORT],' && \
	echo '  [@PACKAGE_BUGREPORT@])'; \
	echo 'm4_define([AT_PACKAGE_URL],' && \
	echo '  [@PACKAGE_URL@])'; \
	}>'$(srcdir)/package.m4'

TESTSUITE = $(srcdir)/testsuite

EXTRA_DIST = testsuite.at $(srcdir)/package.m4 $(TESTSUITE)
EXTRA_DIST += est_rama.txt pol_data.csv met_data.csv namelist.nml

check-local: atconfig  $(TESTSUITE)
	$(SHELL) '$(TESTSUITE)' $(TESTSUITEFLAGS)

maintainer-clean-local:
	rm -rf aclocal.m4 configure Makefile.in autotools m4
     
installcheck-local: atconfig  $(TESTSUITE)
	$(SHELL) '$(TESTSUITE)' AUTOTEST_PATH='$(bindir)' \
	$(TESTSUITEFLAGS)
     
clean-local:
	test ! -f '$(TESTSUITE)' || \
	$(SHELL) '$(TESTSUITE)' --clean

AUTOM4TE = $(SHELL) $(top_builddir)/autoconf/missing --run autom4te
AUTOTEST = $(AUTOM4TE) --language=autotest

$(TESTSUITE): $(srcdir)/testsuite.at $(srcdir)/package.m4
	$(AUTOTEST) -I '$(srcdir)' -o $@.tmp $@.at
	mv $@.tmp $@

.PHONY: $(EXTRA_DIST)
$(EXTRA_DIST):
