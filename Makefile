NAME = llwr
MANPAGE = docs/man.8
SHSCRIPT = $(NAME).sh
LICENSE = LICENSE

PREFIX ?= /usr/local
SRCDIR = src
BUILDDIR = build
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man8
LEGALDIR = $(PREFIX)/share/licenses/$(NAME)

INSTALL_PROGRAM = /usr/bin/install

# (Trusts build environment!)
BASH_CMD = $(shell which bash)
CUT_CMD = $(shell which cut)
GREP_CMD = $(shell which grep)
IW_CMD= $(shell which iw)
XARGS_CMD = $(shell which xargs)

all: build

build: $(BUILDDIR)/$(SHSCRIPT)

$(BUILDDIR)/$(SHSCRIPT): $(SRCDIR)/$(SHSCRIPT)
	-mkdir -p $(BUILDDIR)
	cp $(SRCDIR)/$(SHSCRIPT) $(BUILDDIR)/$(SHSCRIPT)
# Harden by replacing '/bin/env X' with absolute paths
	sed -i -e 's:/bin/env bash:$(BASH_CMD):g' "$(BUILDDIR)/$(SHSCRIPT)"
	sed -i -e 's:/bin/env cut:$(CUT_CMD):g' "$(BUILDDIR)/$(SHSCRIPT)"
	sed -i -e 's:/bin/env grep:$(GREP_CMD):g' "$(BUILDDIR)/$(SHSCRIPT)"
	sed -i -e 's:/bin/env iw:$(IW_CMD):g' "$(BUILDDIR)/$(SHSCRIPT)"
	sed -i -e 's:/bin/env xargs:$(XARGS_CMD):g' "$(BUILDDIR)/$(SHSCRIPT)"

install: install-exec install-docs

install-docs: $(MANPAGE) $(LICENSE)
	$(INSTALL_PROGRAM) --directory $(DESTDIR)$(MANDIR)/
	$(INSTALL_PROGRAM) $(INSTALLFLAGS) -m 644 $(MANPAGE) $(DESTDIR)$(MANDIR)/$(NAME).8
	$(INSTALL_PROGRAM) --directory $(DESTDIR)$(LEGALDIR)/
	$(INSTALL_PROGRAM) $(INSTALLFLAGS) -m 644 $(LICENSE) $(DESTDIR)$(LEGALDIR)/

install-exec: $(BUILDDIR)/$(SHSCRIPT)
	$(INSTALL_PROGRAM) --directory $(DESTDIR)$(BINDIR)/
	$(INSTALL_PROGRAM) $(INSTALLFLAGS) -m 755 $(BUILDDIR)/$(SHSCRIPT) $(DESTDIR)$(BINDIR)/$(NAME)

uninstall:
	-rm $(DESTDIR)$(BINDIR)/$(NAME)
	-rm $(DESTDIR)$(MANDIR)/$(NAME).8
	-rm -rf $(DESTDIR)$(LEGALDIR)/

clean:
	-rm -rf $(BUILDDIR)/

distclean: clean

