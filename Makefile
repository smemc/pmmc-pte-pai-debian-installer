VERSION = 2.11.2
SHA256SUM = 
PREFIX = $(DESTDIR)/usr

INSTALL_BINARIES = \
	install-bin \
	install-bin-doc \
	install-bin-changelog \
	install-bin-summary-by-discipline \
	install-bin-summary-by-level 

DESKTOP_FILES = \
	linux/desktop/pmmc-pte-pai.desktop \
	linux/desktop/pmmc-pte-pai-doc.desktop \
	linux/desktop/pmmc-pte-pai-changelog.desktop \
	linux/desktop/pmmc-pte-pai-summary-by-discipline.desktop \
	linux/desktop/pmmc-pte-pai-summary-by-level.desktop

INSTALL_DESKTOP_FILES = \
	install-desktop \
	install-desktop-doc \
	install-desktop-changelog \
	install-desktop-summary-by-discipline \
	install-desktop-summary-by-level

ICONS = \
	icons/pai-16.png \
	icons/pai-22.png \
	icons/pai-24.png \
	icons/pai-32.png \
	icons/pai-36.png \
	icons/pai-48.png \
	icons/pai-64.png \
	icons/pai-72.png \
	icons/pai-96.png \
	icons/pai-128.png \
	icons/pai-192.png \
	icons/pai-256.png

INSTALL_ICONS = \
	install-icon-16 \
	install-icon-22 \
	install-icon-24 \
	install-icon-32 \
	install-icon-36 \
	install-icon-48 \
	install-icon-64 \
	install-icon-72 \
	install-icon-96 \
	install-icon-128 \
	install-icon-192 \
	install-icon-256

build: $(ICONS) $(DESKTOP_FILES) linux/share/functions

install: $(INSTALL_BINARIES) $(INSTALL_ICONS) $(INSTALL_DESKTOP_FILES)
	install -D -m 644 icons/pai.svg $(PREFIX)/share/icons/hicolor/scalable/apps/pmmc-pte-pai.svg
	install -D -m 644 linux/share/functions $(PREFIX)/share/pai/functions

clean:
	rm -f icons/*.png linux/desktop/*.desktop linux/share/functions

install-icon-%: icons/pai-%.png
	install -D -m 644 $< $(PREFIX)/share/icons/hicolor/$(patsubst pai-%,%,$(*F))x$(patsubst pai-%,%,$(*F))/apps/pmmc-pte-pai.png

install-desktop: linux/desktop/pmmc-pte-pai.desktop
	install -D -m 644 $< $(PREFIX)/share/applications/$(<F)

install-desktop%: linux/desktop/pmmc-pte-pai%.desktop
	install -D -m 644 $< $(PREFIX)/share/applications/$(<F)

install-bin: linux/bin/pai
	install -D -m 755 $< $(PREFIX)/games/$(<F)

install-bin%: linux/bin/pai%
	install -D -m 755 $< $(PREFIX)/games/$(<F)

icons/%.png: icons/pai.svg
	rsvg-convert $< --width=$(patsubst pai-%,%,$(*F)) --height=$(patsubst pai-%,%,$(*F)) --format=png --output $@

linux/%: linux/%.in
	sed -e "s/@VERSION@/$(VERSION)/g" -e "s/@SHA256SUM@/$(SHA256SUM)/g" < $< > $@
