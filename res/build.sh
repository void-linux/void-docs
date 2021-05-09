#!/bin/sh
# uses PREFIX and BUILD_MANPAGES from environment
: "${PREFIX:=/usr/local}"
: "${BUILD_MANPAGES:=1}"

set -e
PATH="$PWD/res:$PATH"

if [ -z "$SOURCE_DATE_EPOCH" ]; then
    export SOURCE_DATE_EPOCH=$(git log --pretty='%ct' -1)
    if [ -z "$SOURCE_DATE_EPOCH" -a "$BUILD_MANPAGES" = 1 ]; then
      echo "git or SOURCE_DATE_EPOCH are needed to build man pages!"
      exit 1
    fi
fi

# Build HTML mdbook
echo "Building mdBook"
mdbook build

if [ "$BUILD_MANPAGES" = "1" ]; then
    # Build mandoc version
    echo "Building man pages"
    cd src

    find . -type d -exec mkdir -p "../mandoc/{}" \;

    find . -type f -name "*.md" -exec sh -c \
      'file="{}"; filew="${file%.md}"; \
          man_date="$(git log --pretty=%cs -1 "$file" 2>/dev/null || date -d "@$SOURCE_DATE_EPOCH" +%F)";
          lowdown -Tman \
          ${man_date:+-m "date: $man_date"} \
          -m "title: ${filew##*/}" \
          -m "section: 7" -m "source: Void Docs" -m "volume: Void Docs" \
          -s -o "../mandoc/${filew}.7" "$file"' \;

    cd -
fi

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
