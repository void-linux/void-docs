#!/bin/sh

DESTDIR=$1
DOC=$DESTDIR/usr/share/doc/void
mkdir -p $DOC/

cp -r src/ $DOC/markdown
rm -r $DOC/markdown/theme

cp -r book/html $DOC/html

cp -r mandoc/ $DOC/mandoc

mkdir -p $DESTDIR/usr/share/man/man7/
install -m0644 void-docs.7 $DESTDIR/usr/share/man/man7/
