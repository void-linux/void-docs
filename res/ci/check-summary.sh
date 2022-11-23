#!/bin/sh

ERROR=0

printf "\n\033[37;1m=> Checking SUMMARY.md\033[m\n"

cd src/ || exit 2

# summary is the list of files taken from SUMMARY.md - unused for now
summary="$( sed -e '/(/!d' -e 's/.*(//' -e 's/)//' ./SUMMARY.md )"

files="$( find . -type f -name '*.md' -not -name "SUMMARY.md" )"

for file in $files
do
    if ! grep -q "$file" ./SUMMARY.md ; then
        printf "::error title=Summary Lint,file=src/SUMMARY.md::$file not in SUMMARY.md\n"
        ERROR=1
    fi
done

exit $ERROR
