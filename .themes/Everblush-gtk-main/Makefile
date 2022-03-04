PREFIX = /usr
DESTDIR ?=
INSTALL_DIR ?= $(DESTDIR)$(PREFIX)/share/themes/Everblush-gtk

all:
	mkdir -p gtk-3.0
	sass src/gtk-3.0/gtk.scss gtk-3.0/gtk.css

install:
	@install -v -d "$(INSTALL_DIR)"
	@install -m 0644 -v index.theme "$(INSTALL_DIR)"
	@cp -rv assets gtk-3.0 "$(INSTALL_DIR)"

uninstall:
	@rm -vrf "$(INSTALL_DIR)"

.PHONY: all install uninstall
