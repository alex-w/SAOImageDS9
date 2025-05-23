dnl
dnl Process this file with autoconf to produce a configure script.
dnl

#--------------------------------------------------------------------
# Configure script for package 'tifftcl', as distributed at November 20, 2001.
# TEA compliant.
#--------------------------------------------------------------------

AC_INIT([tifftcl],[4.7.0])

TEA_INIT([3.9])

AC_CONFIG_AUX_DIR(../tclconfig)

#--------------------------------------------------------------------
# Load the tclConfig.sh file
# Load the tkConfig.sh file
#--------------------------------------------------------------------

TEA_PATH_TCLCONFIG
TEA_LOAD_TCLCONFIG

TEA_PATH_TKCONFIG
TEA_LOAD_TKCONFIG

#-----------------------------------------------------------------------
# Handle the --prefix=... option by defaulting to what Tcl gave.
# Must be called after TEA_LOAD_TCLCONFIG and before TEA_SETUP_COMPILER.
#-----------------------------------------------------------------------

TEA_PREFIX

#-----------------------------------------------------------------------
# Standard compiler checks.
# This sets up CC by using the CC env var, or looks for gcc otherwise.
# This also calls AC_PROG_CC, AC_PROG_INSTALL and a few others to create
# the basic setup necessary to compile executables.
#-----------------------------------------------------------------------

TEA_SETUP_COMPILER

# Determine a full path for the chosen compiler to ensure that the
# libtiff configure tool is using the same one as ourselves.

TIFFCC=`echo "$CC" | sed -e 's/-pipe//'`
TIFFCC=`which $TIFFCC 2>/dev/null`

#--------------------------------------------------------------------
# Run the configuration of TIFF itself, and do some special checks
# to if the configuration agrees with the sources of tiff itself.
# F.e. tiff is hardwired to use "stdarg.h". If the chosen compiler
# does not support this we have to bail out.
#--------------------------------------------------------------------

if test `grep STDC_HEADERS confdefs.h | wc -l` -eq 0
then
    AC_MSG_ERROR([Compiler does not use stdarg.h, required for TIFF])
fi

mv -f confdefs.h tifftcl_confdefs.h
if test "X$host" = X -o "X$host" = XNONE
then
    TIFFHOST=""
else
    TIFFHOST="$host"
fi
${srcdir}/../compat/libtiff/configure --disable-zlib --disable-zstd --disable-lzma \
	--disable-pixarlog --disable-jpeg --disable-jbig --disable-webp --disable-lerc \
	"--with-CC=$TIFFCC" $TIFFHOST
mv -f tifftcl_confdefs.h confdefs.h

#-----------------------------------------------------------------------
# Specify the C source files to compile in TEA_ADD_SOURCES,
# public headers that need to be installed in TEA_ADD_HEADERS,
# stub library C source files to compile in TEA_ADD_STUB_SOURCES,
# and runtime Tcl library files in TEA_ADD_TCL_SOURCES.
# This defines PKG(_STUB)_SOURCES, PKG(_STUB)_OBJECTS, PKG_HEADERS
# and PKG_TCL_SOURCES.
#-----------------------------------------------------------------------

TEA_ADD_SOURCES([tifftcl.c tifftclStubInit.c])

TEA_ADD_SOURCES([
	../compat/libtiff/libtiff/tif_aux.c		../compat/libtiff/libtiff/tif_close.c		../compat/libtiff/libtiff/tif_codec.c
	../compat/libtiff/libtiff/tif_compress.c	../compat/libtiff/libtiff/tif_dir.c		../compat/libtiff/libtiff/tif_dirinfo.c
	../compat/libtiff/libtiff/tif_dirread.c	        ../compat/libtiff/libtiff/tif_dirwrite.c	../compat/libtiff/libtiff/tif_dumpmode.c
	../compat/libtiff/libtiff/tif_error.c		../compat/libtiff/libtiff/tif_fax3.c            ../compat/libtiff/libtiff/tif_hash_set.c
	../compat/libtiff/libtiff/tif_getimage.c	../compat/libtiff/libtiff/tif_flush.c		../compat/libtiff/libtiff/tif_luv.c
	../compat/libtiff/libtiff/tif_lzw.c		../compat/libtiff/libtiff/tif_next.c		../compat/libtiff/libtiff/tif_open.c
	../compat/libtiff/libtiff/tif_packbits.c	../compat/libtiff/libtiff/tif_predict.c	        ../compat/libtiff/libtiff/tif_print.c
	../compat/libtiff/libtiff/tif_read.c		../compat/libtiff/libtiff/tif_swab.c		../compat/libtiff/libtiff/tif_strip.c
	../compat/libtiff/libtiff/tif_thunder.c	        ../compat/libtiff/libtiff/tif_tile.c		../compat/libtiff/libtiff/tif_version.c
	../compat/libtiff/libtiff/tif_warning.c	        ../compat/libtiff/libtiff/tif_write.c
	../compat/libtiff/libtiff/tif_color.c		../compat/libtiff/libtiff/tif_extension.c       ../compat/libtiff/libtiff/tif_fax3sm.c
])

TEA_ADD_HEADERS([tifftcl.h tifftclDecls.h])
TEA_ADD_INCLUDES([-I\"`\${CYGPATH} \${srcdir}`\"])
TEA_ADD_INCLUDES([-I\"./libtiff\"])
TEA_ADD_INCLUDES([-I\"`\${CYGPATH} \${srcdir}/../compat/libtiff/libtiff`\"])
TEA_ADD_STUB_SOURCES([tifftclStubLib.c])
TEA_ADD_SOURCES([tifftclStubLib.c])
TEA_ADD_TCL_SOURCES([])

#--------------------------------------------------------------------
# __CHANGE__
# Choose which headers you need.  Extension authors should try very
# hard to only rely on the Tcl public header files.  Internal headers
# contain private data structures and are subject to change without
# notice.
# This MUST be called after TEA_LOAD_TCLCONFIG / TEA_LOAD_TKCONFIG
#--------------------------------------------------------------------

TEA_PUBLIC_TCL_HEADERS
TEA_PUBLIC_TK_HEADERS

#--------------------------------------------------------------------
# A few miscellaneous platform-specific items:
#
# Windows creates a few extra files that need to be cleaned up.
# We can add more files to clean if our extension creates any extra
# files in the future.
#
# Define any extra compiler flags in the PACKAGE_CFLAGS variable.
# These will be appended to the current set of compiler flags for
# your system.
#--------------------------------------------------------------------

if test "${TEA_PLATFORM}" = "windows" ; then
    CLEANFILES="*.lib *.dll *.exp *.ilk *.pdb vc*.pch"
    TEA_ADD_SOURCES([../compat/libtiff/libtiff/tif_win32.c])
else
    CLEANFILES=""
    TEA_ADD_SOURCES([../compat/libtiff/libtiff/tif_unix.c])
fi
AC_SUBST(CLEANFILES)

#--------------------------------------------------------------------
# Check whether --enable-threads or --disable-threads was given.
# So far only Tcl responds to this one.
#--------------------------------------------------------------------

TEA_ENABLE_THREADS

#--------------------------------------------------------------------
# The statement below defines a collection of symbols related to
# building as a shared library instead of a static library.
#--------------------------------------------------------------------

TEA_ENABLE_SHARED

#--------------------------------------------------------------------
# This macro figures out what flags to use with the compiler/linker
# when building shared/static debug/optimized objects.  This information
# can be taken from the tclConfig.sh file, but this figures it all out.
#--------------------------------------------------------------------

TEA_CONFIG_CFLAGS

#--------------------------------------------------------------------
# Set the default compiler switches based on the --enable-symbols option.
#--------------------------------------------------------------------

TEA_ENABLE_SYMBOLS

#--------------------------------------------------------------------
# For Unix/Tk builds, make sure that the X libraries/headers are found.
# This must be called after TEA_CONFIG_CFLAGS as it adjusts LIBS.
#--------------------------------------------------------------------

# See [Bug #82910]
#TEA_PATH_X

#--------------------------------------------------------------------
# Everyone should be linking against the Tcl stub library.  If you
# can't for some reason, remove this definition.  If you aren't using
# stubs, you also need to modify the SHLIB_LD_LIBS setting below to
# link against the non-stubbed Tcl library.
#--------------------------------------------------------------------

AC_DEFINE(USE_TCL_STUBS)

#--------------------------------------------------------------------
# This macro generates a line to use when building a library.  It
# depends on values set by the TEA_ENABLE_SHARED, TEA_ENABLE_SYMBOLS,
# and TEA_LOAD_TCLCONFIG macros above.
#--------------------------------------------------------------------

TEA_MAKE_LIB

#--------------------------------------------------------------------
# __CHANGE__
# Add platform libs to LIBS or SHLIB_LD_LIBS as necessary.
#--------------------------------------------------------------------

if test "${TEA_PLATFORM}" = "windows" -a "$GCC" != "yes" ; then
    TEA_ADD_LIBS([user32.lib])
else
    TEA_ADD_LIBS([-lm])
fi

#--------------------------------------------------------------------
# Find tclsh so that we can run pkg_mkIndex to generate the pkgIndex.tcl
# file during the install process.  Don't run the TCLSH_PROG through
# ${CYGPATH} because it's being used directly by make.
# Require that we use a tclsh shell version 8.2 or later since earlier
# versions have bugs in the pkg_mkIndex routine.
# Add WISH as well if this is a Tk extension.
#--------------------------------------------------------------------

TEA_PROG_TCLSH
TEA_EXPORT_CONFIG(tifftcl)

#--------------------------------------------------------------------
# Finally, substitute all of the various values into the Makefile.
# You may alternatively have a special pkgIndex.tcl.in or other files
# which require substituting th AC variables in.  Include these here.
#--------------------------------------------------------------------

AC_CONFIG_FILES([Makefile tifftclConfig.sh])
AC_OUTPUT

#--------------------------------------------------------------------
