# Copyright(c)'2011 LinBox
# Written by BB <bboyer@imag.fr>
# This file is part of LinBox.
# see the COPYING file for more details.

dnl enable basic debug mode.
AC_DEFUN([AC_DEBUG],
[AC_MSG_CHECKING([whether to enable debugging options in the library])
  AC_ARG_ENABLE(debug,
[AC_HELP_STRING([--enable-debug], [enable debugging options in library])],
      USE_DEBUG=$enableval,
      USE_DEBUG=no)
  AC_MSG_RESULT([$USE_DEBUG])
  AM_CONDITIONAL(DEBUG, [test $USE_DEBUG = yes])
  DBG=$USE_DEBUG
  AC_SUBST(DBG)dnl
]
)

AC_DEFUN([AC_PROFILE],
[AC_MSG_CHECKING([whether to enable profiling everything in the library])
  AC_ARG_ENABLE(profile,
[AC_HELP_STRING([--enable-profile], [enable profiling options in library])],
      USE_PROFILE=$enableval,
      USE_PROFILE=no)
  AC_MSG_RESULT([$USE_PROFILE])
  AM_CONDITIONAL(PROFILE, [test $USE_PROFILE = yes])
  PROF=$USE_PROFILE
  AC_SUBST(PROF)dnl
]
)

dnl Enable warnings from compiler.
AC_DEFUN([AC_WARNINGS],
[AC_MSG_CHECKING([whether to enable warnings when compiling the library])
  AC_ARG_ENABLE(warnings,
[AC_HELP_STRING([--enable-warnings=yes|full|no],  [enable warnings when compiling the library.
If nothing or yes is given, more aggressive compiler warnings are passed to the compiler.
If full is given, we become paranoïd about warnings and treat them as errors.])],
      USE_WARNINGS=$enableval,
      USE_WARNINGS=no)
  AC_MSG_RESULT([$USE_WARNINGS])
  dnl  AM_CONDITIONAL(WARNINGS, [test $USE_WARNINGS = yes])
  WARN=$USE_WARNINGS
  AC_SUBST(WARN)dnl
]dnl
)dnl

CCNAM=""

AC_DEFUN([AC_COMPILER_NAME], [
		AC_MSG_CHECKING(for family name of compiler)

		dnl CHECKING for various compilers
		dnl ICC ?
		AC_TRY_RUN( [
           #ifdef __INTEL_COMPILER
				int main() { return 0 ; }
			#else
			   pas intel
		   #endif],
		[ AC_MSG_RESULT(icc)
		CCNAM=icc
		AC_SUBST(CCNAM)
		])

dnl PATHSCALE ?
		AS_IF([ test -z "${CCNAM}"], [
			AC_TRY_RUN( [
				#ifdef __PATHSCALE__
				   int main() { return !(__PATHCC__ >= 4) ; }
			   #else
				   pas ekopath non plus.
				#endif], [
		AC_MSG_RESULT(eko)
		CCNAM=eko
		AC_SUBST(CCNAM) ])
		])

dnl GCC ?
		AS_IF([ test -z "${CCNAM}"], [
			AC_TRY_RUN( [
				#ifdef __GNUC__
				   int main() { return !(__GNUC__ >= 4 || (__GNUC__ == 4 && __GNUC_MINOR__ > 2)) ; }
				#else
				   pas gcc non plus ???
				#endif], [
		CCNOM=gcc
		AS_IF([ test -n "${CC}" ], [CCNOM="`$CC --version 2>&1|  awk 'NR<2{print $1}'`"])
		CCNAM=gcc
		AC_SUBST(CCNAM)
		AC_MSG_RESULT($CCNOM)
		])
		])

		dnl  autre ?

		AS_IF([ test -z "${CCNAM}"],
				[ AC_MSG_RESULT(unknown)
				CCNAM=unknown
				AC_SUBST(CCNAM)
				echo
				echo " *** unknow compiler. please file a bug "
				echo
				])
])

