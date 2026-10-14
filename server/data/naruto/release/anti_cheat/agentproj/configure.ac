#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT(agent, 1.0)
AC_CONFIG_SRCDIR([Cocos2dxLuaLoader.cpp])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE

AM_CONDITIONAL([ENABLE_CXX], [true])
AM_CONDITIONAL([ENABLE_GCC_CXX_ATOMIC], [false])

# Checks for programs.
AC_PROG_CXX
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET

LT_INIT

# Checks for libraries.
# FIXME: Replace `main' with a function in `-ldl':
AC_CHECK_LIB([dl], [main])
# FIXME: Replace `main' with a function in `-lm':
AC_CHECK_LIB([m], [main])

# Checks for header files.
AC_CHECK_HEADERS([arpa/inet.h fcntl.h float.h inttypes.h limits.h locale.h stddef.h stdint.h stdlib.h string.h sys/time.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_C_INLINE
AC_TYPE_INT16_T
AC_TYPE_INT32_T
AC_TYPE_INT64_T
AC_TYPE_INT8_T
AC_C_RESTRICT
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_TYPE_UINT8_T
AC_CHECK_TYPES([ptrdiff_t])

# Checks for library functions.
AC_FUNC_FSEEKO
AC_FUNC_MALLOC
AC_FUNC_MKTIME
AC_FUNC_MMAP
AC_FUNC_REALLOC
AC_FUNC_STRCOLL
AC_FUNC_STRTOD
AC_CHECK_FUNCS([clock_gettime getcwd localtime_r memchr memmove memset mkdir munmap pow setlocale sqrt strchr strcspn strerror strpbrk strrchr strstr strtoul uname])

AC_CONFIG_FILES([libmsgpack/Makefile])
AC_OUTPUT([Makefile])
