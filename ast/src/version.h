#if !defined( VERSION_INCLUDED )
#define VERSION_INCLUDED 1
/*
*+
*  Name:
*     version.h

*  Purpose:
*     Declare version numbers

*  Description:
*     Defines macros which expand to the components of the AST version
*     number, namely the major and minor version numbers, and the
*     release number.  The version number as a string is available by
*     including the file config.h, which defines macros PACKAGE_STRING,
*     PACKAGE_VERSION and (equivalently to the latter) VERSION.
*
*     For example, the version string `3.2.1' corresponds to major version
*     3, minor version 2, release 1.

*  Macros defined:
*     AST__VMAJOR
*        The AST major version number
*     AST__VMINOR
*        The AST minor version number
*     AST__RELEASE
*        The AST release number
*
*     For backwards compatibility, this module also declares macros
*     AST_MAJOR_VERS, AST_MINOR_VERS and AST_RELEASE.  The AST__*
*     macros should be used in preference to these, since the latter
*     use (non-standard) single underscores.

*  Copyright:
*     Copyright (C) 1997-2006 Council for the Central Laboratory of the
*     Research Councils

*  Licence:
*     This program is free software: you can redistribute it and/or
*     modify it under the terms of the GNU Lesser General Public
*     License as published by the Free Software Foundation, either
*     version 3 of the License, or (at your option) any later
*     version.
*     
*     This program is distributed in the hope that it will be useful,
*     but WITHOUT ANY WARRANTY; without even the implied warranty of
*     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*     GNU Lesser General Public License for more details.
*     
*     You should have received a copy of the GNU Lesser General
*     License along with this program.  If not, see
*     <http://www.gnu.org/licenses/>.

*  Authors:
*     NG: Norman Gray (Starlink)

*  History:
*     25-NOV-2003 (NG):
*        Original version
*-
*/

/* The current version of AST is 9.2.12 */
#define AST__VMAJOR    9
#define AST__VMINOR    2
#define AST__RELEASE   12

/* Deprecated macros */
#define AST_MAJOR_VERS 9
#define AST_MINOR_VERS 2
#define AST_RELEASE    12

#endif /* #if ! defined(VERSION_INCLUDED) */
