dnl
dnl Process this file with autoconf to produce a configure script.
dnl

#--------------------------------------------------------------------
# Configure script for package 'tkimgpng', as distributed at November 20, 2001.
# TEA compliant.
#--------------------------------------------------------------------

AC_INIT([tkimgpng],[2.0.1])

TEA_INIT([3.9])

AC_CONFIG_AUX_DIR(../tclconfig)

PHIMGTYPE="png"
CPACKAGE="Tkimgpng"
PACKAGE_TCLNAME="img::png"
AC_SUBST(PHIMGTYPE)
AC_SUBST(PACKAGE_TCLNAME)

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

TEA_PATH_CONFIG(tkimg)
TEA_LOAD_CONFIG(tkimg)

TEA_PATH_CONFIG(pngtcl)
TEA_LOAD_CONFIG(pngtcl)
AC_SUBST(pngtcl_VERSION)

TEA_PATH_CONFIG(zlibtcl)
TEA_LOAD_CONFIG(zlibtcl)
AC_SUBST(zlibtcl_VERSION)

IMG_SRCPATH(tkimg)
IMG_SRCPATH(pngtcl)
IMG_SRCPATH(zlibtcl)

#-----------------------------------------------------------------------
# Specify the C source files to compile in TEA_ADD_SOURCES,
# public headers that need to be installed in TEA_ADD_HEADERS,
# stub library C source files to compile in TEA_ADD_STUB_SOURCES,
# and runtime Tcl library files in TEA_ADD_TCL_SOURCES.
# This defines PKG(_STUB)_SOURCES, PKG(_STUB)_OBJECTS, PKG_HEADERS
# and PKG_TCL_SOURCES.
#-----------------------------------------------------------------------

TEA_ADD_SOURCES([png.c])
TEA_ADD_HEADERS([])
TEA_ADD_INCLUDES([-I\"`\${CYGPATH} \${tkimg_SRC_PATH}`\"])
TEA_ADD_INCLUDES([-I\"`\${CYGPATH} \${pngtcl_SRC_PATH}`\"])
TEA_ADD_INCLUDES([-I\"`\${CYGPATH} \${pngtcl_BUILD_PATH}`\"])
TEA_ADD_INCLUDES([-I\"`\${CYGPATH} \${zlibtcl_SRC_PATH}`\"])
TEA_ADD_INCLUDES([-I\"`\${CYGPATH} \${zlibtcl_BUILD_PATH}`\"])
TEA_ADD_INCLUDES([-I.])
TEA_ADD_LIBS([])
TEA_ADD_CFLAGS([-DTKIMG_VERSION=\\\"\${tkimg_VERSION}\\\"])
TEA_ADD_CFLAGS([-DPNGTCL_VERSION=\\\"\${pngtcl_VERSION}\\\"])
TEA_ADD_CFLAGS([-DZLIBTCL_VERSION=\\\"\${zlibtcl_VERSION}\\\"])
TEA_ADD_STUB_SOURCES([])
TEA_ADD_TCL_SOURCES([])

PUP="`echo ${PACKAGE_NAME}| tr 'a-z' 'A-Z'`"

sed < "`${CYGPATH} ${srcdir}/../init.c`" > "init.c"	\
	-e	"s/@CPACKAGE@/${CPACKAGE}/"		\
	-e	"s/%PACKAGE%/${PACKAGE_NAME}/"		\
	-e	"s/%PACKAGE_UP%/${PUP}/"		\
	-e	"s/%PHIMGTYPE%/${PHIMGTYPE}/"

# init.c is an included source file, not a source by itself
# FUTURE: Do this through AC_OUTPUT!!

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

TEA_PATH_X

#--------------------------------------------------------------------
# Everyone should be linking against the Tcl stub library.  If you
# can't for some reason, remove this definition.  If you aren't using
# stubs, you also need to modify the SHLIB_LD_LIBS setting below to
# link against the non-stubbed Tcl library.
#--------------------------------------------------------------------

AC_DEFINE(USE_TCL_STUBS)
AC_DEFINE(USE_TK_STUBS)

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
    TEA_ADD_LIBS([\"`${CYGPATH} ${tkimg_STUB_LIB_PATH}`\"])
    TEA_ADD_LIBS([\"`${CYGPATH} ${pngtcl_STUB_LIB_PATH}`\"])
else
    TEA_ADD_LIBS([${tkimg_STUB_LIB_SPEC}])
    TEA_ADD_LIBS([${pngtcl_STUB_LIB_SPEC}])
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
TEA_PROG_WISH

TEA_EXPORT_CONFIG([tkimgpng])

#--------------------------------------------------------------------
# Finally, substitute all of the various values into the Makefile.
# You may alternatively have a special pkgIndex.tcl.in or other files
# which require substituting th AC variables in.  Include these here.
#--------------------------------------------------------------------

AC_OUTPUT([Makefile tkimgpngConfig.sh])

#--------------------------------------------------------------------
