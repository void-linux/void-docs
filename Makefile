PREFIX := /usr/local

SOURCES = $(shell find src -not -path 'src/theme*' -type f -name '*.md')
MANPAGES = $(subst src/,book/mandoc/,$(patsubst %.md,%.7,$(SOURCES)))
UTILS = book/void-docs book/void-docs.1

all: void-book void-docs mandoc

install: all
	install -Dm0755 book/void-docs $(DESTDIR)$(PREFIX)/bin/void-docs
	install -Dm0644 book/void-docs.1 $(DESTDIR)$(PREFIX)/share/man/man1/void-docs.1

	install -Dm0644 book/typst/book.pdf $(DESTDIR)$(PREFIX)/share/doc/void/handbook.pdf

	cp -r src/ $(DESTDIR)$(PREFIX)/share/doc/void/markdown
	rm -fr $(DESTDIR)$(PREFIX)/share/doc/void/markdown/theme

	cp -r book/html $(DESTDIR)$(PREFIX)/share/doc/void/html

	cp -r book/mandoc $(DESTDIR)$(PREFIX)/share/doc/void/mandoc

void-docs: $(UTILS)

$(UTILS): book/%: res/%.in book
	sed -e "s,@PREFIX@,$(PREFIX)," $< >$@

void-book: $(SOURCES) book/typst/handbook-cover.svg
	mdbook build

book/typst/handbook-cover.svg: res/handbook-cover.svg book/typst
	cp -a $< $@

mandoc: $(MANPAGES)

book/mandoc/%.7: src/%.md book/mandoc
	@mkdir -p $(@D)
	lowdown -T man -m "title: $(*F)" -m "date: $$(git log --pretty='%cs' -1 $< 2>/dev/null || date -d @$$SOURCE_DATE_EPOCH +%F)" \
		-m "section: 7" -m "source: The Void Linux Handbook" -m "volume: The Void Linux Handbook" -s -o $@ $<

book:
	mkdir -p book

book/typst: book
	mkdir -p book/typst

book/mandoc: book
	mkdir -p book/mandoc

clean:
	rm -rf book

.PHONY: all install void-docs void-book mandoc clean
