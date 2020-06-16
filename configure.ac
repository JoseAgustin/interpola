#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([interpola], [2.0], [agustin@atmosfera.unam.mx], , [https://github.com/JoseAgustin/interpola])
AM_INIT_AUTOMAKE([1.11])

# Define our M4 macro directory
AC_CONFIG_MACRO_DIR([m4])

# Checks for programs.
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_FC
# Make precious variables for ./configure --help
AC_ARG_VAR(NETCDF_ROOT,[Root of netCDF installation or] (compile-time))
AC_ARG_VAR(NETCDF_INC,[  Location of netCDF headers] (compile-time))
AC_ARG_VAR(NETCDF_LIB,[  Location of netCDF library] (compile-time))
# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.
AC_LANG_PUSH(Fortran)
AC_FC_FREEFORM
AC_OPENMP
# Check for newunit option to open()
AX_F08_NEWUNIT
if test -z "${NETCDF_ROOT}"; then
	NETCDF_CONFIG='nf-config'
	NETCDF_ROOT="`nf-config --prefix`"
	if test -z "${NETCDF_ROOT}"; then
	echo "WARNING: nf-config --prefix  empty location trying nc-config"
		  NETCDF_ROOT="`nc-config --prefix`"
  fi
        LDFLAGS="`${NETCDF_CONFIG} --flibs` ${LDFLAGS}";
        FCFLAGS="-I`${NETCDF_CONFIG} --fflags` ${FCFLAGS}";
    else
	NETCDF_CONFIG="${NETCDF_ROOT}/bin/nf-config"
        LDFLAGS="`${NETCDF_CONFIG} --flibs` ${LDFLAGS}";
        FCFLAGS="-I`${NETCDF_CONFIG} --fflags` ${FCFLAGS}";
    fi

if test "${NETCDF_INC}"; then
    if test -d "${NETCDF_INC}"; then
	FCFLAGS="-I${NETCDF_INC} ${FCFLAGS} "
	AC_CHECK_FILE([${NETCDF_INC}/netcdf.mod], [FCFLAGS="$FCFLAGS -I${NETCDF_INC}"], [])
    else
	echo "WARNING: NETCDF_INC location \"${NETCDF_INC}\" does not exist!"
    fi
fi # !NETCDF_INC
# Checks for library functions.
if test "${NETCDF_LIB}"; then
    if test -d "${NETCDF_LIB}"; then
	LDFLAGS="-L${NETCDF_LIB} ${LDFLAGS} "
	AC_CHECK_FILE([${NETCDF_LIB}/libnetcdff.a], [LDFLAGS="$LDFLAGS -lnetcdff"], [])
    else
	echo "WARNING: NETCDF_LIB location \"${NETCDF_LIB}\" does not exist!"
   fi
fi # !NETCDF_LIB
AC_CHECK_FILE([${NETCDF_ROOT}/lib/libnetcdff.a], [LDFLAGS="$LDFLAGS -lnetcdff"], [])

AC_MSG_CHECKING([whether the Fortran 90 compiler ($FC $FCFLAGS $LDFLAGS) works])
AC_LINK_IFELSE([
    AC_LANG_SOURCE([
        program conftest
        integer, dimension(9) :: n
        end
    ])
],[
    ax_cv_prog_fc_works="yes"
    AC_MSG_RESULT([$ax_cv_prog_fc_works])
],[
    ax_cv_prog_fc_works="no"
    AC_MSG_WARN([installation or configuration problem: Fortran 90 compiler cannot create executables.])
])
# The intel compiler sometimes generates these work.pc and .pcl files
rm -f work.pc work.pcl
AC_MSG_CHECKING([for -lnetcdff usage in $FC ])
AC_LINK_IFELSE([
    AC_LANG_SOURCE([
        program conftest
        use netcdf
        integer :: ncid, status
        !status=nf90_open(path="foo.nc",mode=nf90_nowrite,ncid)
        end program
    ])
],[
    ax_cv_prog_fc_works="yes"
    AC_MSG_RESULT([$ax_cv_prog_fc_works])
],[
    ax_cv_prog_fc_works="no"
    AC_MSG_WARN([installation or configuration problem: lnetcdff not useful.])
])

FCFLAGS="$OPENMP_FCFLAGS $FCFLAGS "

AC_LANG_POP(Fortran)

AC_CONFIG_FILES([Makefile
                 src/Makefile])
AC_OUTPUT
