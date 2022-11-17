################################################################################

# Set Up Emacs Variables

## Compilation Flags
AM_ELCFLAGS = -Q -L .

## Destination for installed files
lispdir = $(prefix)/share/emacs/site-lisp/$(PACKAGE_NAME)-$(PACKAGE_VERSION)

################################################################################

# Set Up Other Variables

## Enable local m4 cache
ACLOCAL_AMFLAGS = -I m4

## Documentation Compilation
info_TEXINFOS = doc/pseudotaxus-emacs.texi

## Extra Files for Distribution
EXTRA_DIST =	Changelog.md \
		LICENSE \
		COPYING \
		NEWS \
		AUTHORS \
		README.org \
		README.md \
		Changelog.md \
		ChangeLog \
		COPYING \
		guix.scm \
		pre-inst-env.in
		tests/maintests.scm \
		build-aux/test-driver.scm \
		doc/version.texi.in \
		doc/fdl-1.3.texi \
		doc/procedure-types.texi \
		m4/tar-edited.m4

################################################################################
# Define Inputs

## Define Emacs files
dist_lisp_LISP = pseudotaxus/pseudotaxus.el

## Don't Distribute, Don't Install
nodist_noinst_SCRIPTS = pre-inst-env

################################################################################

# Added Jobs

################################################################################

# Tests
TEST_EXTENSIONS = .scm
TESTS = tests/maintests.scm
AM_TESTS_ENVIRONMENT = abs_top_srcdir="$(abs_top_srcdir)" GUILE_AUTO_COMPILE=0

SCM_LOG_DRIVER =                                 \
   $(top_builddir)/pre-inst-env         \
   $(GUILE) --no-auto-compile -L $(top_srcdir) -e main \
       $(top_srcdir)/build-aux/test-driver.scm

# Tell 'build-aux/test-driver.scm' to display only source file names,
# not indivdual test names.
AM_SCM_LOG_DRIVER_FLAGS = --brief=yes 
