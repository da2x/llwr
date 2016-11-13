NAME = llwr
MANPAGE = docs/man.8
PROGRAM = src/$(NAME).sh
LICENSE = LICENSE

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man8
LEGALDIR = $(PREFIX)/share/licenses/$(NAME)


INSTALL_PROGRAM = /usr/bin/install

all: build

build:
	@echo -e "\tJust run: make install [--prefix]"

install: install-docs
	$(INSTALL_PROGRAM) --directory $(DESTDIR)$(BINDIR)/
	$(INSTALL_PROGRAM) $(INSTALLFLAGS) -m 755 $(PROGRAM) $(DESTDIR)$(BINDIR)/$(NAME)

install-docs:
	$(INSTALL_PROGRAM) --directory $(DESTDIR)$(MANDIR)/
	$(INSTALL_PROGRAM) $(INSTALLFLAGS) -m 644 $(MANPAGE) $(DESTDIR)$(MANDIR)/$(NAME).8
	$(INSTALL_PROGRAM) --directory $(DESTDIR)$(LEGALDIR)/
	$(INSTALL_PROGRAM) $(INSTALLFLAGS) -m 644 $(LICENSE) $(DESTDIR)$(LEGALDIR)/

uninstall:
	-rm $(DESTDIR)$(BINDIR)/$(NAME)
	-rm $(DESTDIR)$(MANDIR)/$(NAME).8
	-rm -rf $(DESTDIR)$(LEGALDIR)/

