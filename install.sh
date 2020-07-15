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

install -Dm0644 void-docs.1 ${DESTDIR}${PREFIX}/share/man/man1/
install -Dm0755 void-docs ${DESTDIR}${PREFIX}/bin/
