#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([interpola], [2.0], [agustin@atmosfera.unam.mx], , [https://github.com/JoseAgustin/interpola])
AM_INIT_AUTOMAKE([1.11])
# Checks for programs.
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_FC
AC_LANG_PUSH(Fortran)

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.
AC_OPENMP

# Checks for library functions.
AC_MSG_CHECKING([whether the Fortran 90 compiler ($FC $FCFLAGS $LDFLAGS) works])
AC_LINK_IFELSE([
    AC_LANG_SOURCE([
        program conftest
        integer, dimension(10) :: n
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

AC_LANG_POP(Fortran)

AC_CONFIG_FILES([Makefile
                 src/Makefile])
AC_OUTPUT
