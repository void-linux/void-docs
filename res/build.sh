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
pdflatex -output-directory=book/latex/ book/latex/handbook.tex >/dev/null
pdflatex -output-directory=book/latex/ book/latex/handbook.tex >/dev/null
