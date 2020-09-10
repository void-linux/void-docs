#!/bin/sh
# uses PREFIX from environment
: "${PREFIX:=/usr/local}"

set -e
PATH="$PWD/res:$PATH"

# Build HTML mdbook
echo "Building mdBook"
mdbook build

# Build mandoc version
echo "Building man pages"
mkdir -p mandoc
cd src

fd -t d "" ./ -x mkdir -p "../mandoc/{}"

fd "\.md" ./ -x pandoc \
    -V "title={/.}" -V "section=7" -V "header=Void Docs" -s \
    -o "../mandoc/{.}.7" "{}"

cd -

# Build script
echo "Building void-docs script and man page"
sed -e "s,@PREFIX@,$PREFIX," res/void-docs.in > res/void-docs
sed -e "s,@PREFIX@,$PREFIX," res/void-docs.1.in > res/void-docs.1

# Build PDF

echo "Building PDF"

## Temporarily add OpenType version of Latin Modern to font cache.

mkdir -p ~/.fonts
TMP_FONTDIR=$(mktemp -d -p ~/.fonts)
cp /usr/share/texmf-dist/fonts/opentype/public/lm/* $TMP_FONTDIR
fc-cache

## Create cover page using Latin Modern text.

if [ -f res/handbook-cover.png ]; then
    rm res/handbook-cover.png
fi
rsvg-convert \
    --dpi-x 300 \
    --dpi-y 300 \
    res/handbook-cover.svg > res/handbook-cover.png

## Letter version

pdflatex \
    -output-directory=book/latex/ \
    -jobname=handbook-letter \
    book/latex/handbook.tex \
    >/dev/null
pdflatex \
    -output-directory=book/latex/ \
    -jobname=handbook-letter \
    book/latex/handbook.tex \
    >/dev/null

## A4 version

sed -ie "s/\\documentclass\[letterpaper\]{article}/\\documentclass[a4paper]{article}/" \
    book/latex/handbook.tex
pdflatex -output-directory=book/latex/ \
         -jobname=handbook-a4 \
         book/latex/handbook.tex \
         >/dev/null
pdflatex -output-directory=book/latex/ \
         -jobname=handbook-a4 \
         book/latex/handbook.tex \
         >/dev/null

## Remove temporary font directory

rm -rf $TMP_FONTDIR
fc-cache
