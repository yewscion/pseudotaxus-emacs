dnl Process this file with autoconf
AC_INIT([pseudotaxus-emacs],
        [0.0.1],
        [yewscion@gmail.com],
        [pseudotaxus-emacs],
        [https://cdr255.com/projects/pseudotaxus/])

dnl General Project Variables
AC_SUBST(LICENSE, ["Copyright (C) 2022 Christopher Rodriguez

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

"])
_AM_SUBST_NOTMAKE([LICENSE])
AC_CONFIG_SRCDIR([README.md])
AC_CONFIG_AUX_DIR([build-aux])
AC_SUBST(PACKAGE_DOCS_COMMAND, [info])

dnl Set Up Automake
AM_INIT_AUTOMAKE([-Wall -Werror -Wportability gnu check-news dist-bzip2
filename-length-max=99 std-options])

dnl Find Emacs Installation
AM_PATH_LISPDIR

dnl Set Up Guile 3.0
GUILE_PKG([3.0])
GUILE_PROGS
if test "x$GUILD" = "x"; then
   AC_MSG_ERROR(['guild' binary not found;
   please check Your guile installation.])
fi
GUILE_SITE_DIR

dnl Finishing Up
AC_PROG_LN_S
AC_PROG_MKDIR_P
AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([doc/version.texi])
AC_CONFIG_FILES([pre-inst-env], [chmod +x pre-inst-env])
AC_OUTPUT
