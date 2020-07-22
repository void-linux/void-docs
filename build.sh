#!/bin/sh

PATH="$PWD:$PATH"

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

# Build reference man page
echo "Building void-docs man page"
pandoc \
    -V "title=void-docs" -V "section=7" -V "header=Void Docs" -s \
    -o "void-docs.7" "void-docs.md"

# Build PDF
pdflatex -output-directory=book/latex/ book/latex/handbook.tex >/dev/null
pdflatex -output-directory=book/latex/ book/latex/handbook.tex >/dev/null
