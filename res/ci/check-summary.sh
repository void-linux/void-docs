#!/bin/sh

ERROR=0

cd src/ || exit 2

# summary is the list of files taken from SUMMARY.md - unused for now
summary="$( sed -e '/(/!d' -e 's/.*(//' -e 's/)//' ./SUMMARY.md )"

files="$( find . -type f -name '*.md' -not -name "SUMMARY.md" )"

for file in $files
do
    if ! grep "$file" ./SUMMARY.md >/dev/null ; then
        printf "\033[31;1m=> $file not in SUMMARY\033[m\n"
        ERROR=1
    fi
done

exit $ERROR
