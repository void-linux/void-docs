#!/bin/sh
# uses PREFIX and DESTDIR from environment
: "${PREFIX:=/usr/local}"

set -e

DOC=${DESTDIR}${PREFIX}/share/doc/void
mkdir -p $DOC/

cp -r src/ $DOC/markdown
rm -fr $DOC/markdown/theme

cp -r book/html $DOC/html

cp -r mandoc/ $DOC/mandoc

install -Dm0644 res/void-docs.1 ${DESTDIR}${PREFIX}/share/man/man1/void-docs.1
install -Dm0755 res/void-docs ${DESTDIR}${PREFIX}/bin/void-docs
install -Dm0644 book/latex/handbook.pdf ${DESTDIR}${PREFIX}/share/doc/void/handbook.pdf
