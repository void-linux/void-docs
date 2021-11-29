#!/bin/sh

cd src/ || exit 2

# summary is the list of files taken from SUMMARY.md - unused for now
summary="$( sed -e '/(/!d' -e 's/.*(//' -e 's/)//' ./SUMMARY.md )"

files="$( find . -type f -name '*.md' -not -name "SUMMARY.md" )"

for file in $files
do
    if ! grep "$file" ./SUMMARY.md >/dev/null 2>&1 ; then
        echo "$file not in SUMMARY"
        ERROR=1
    fi
done

[ -z "$ERROR" ] && exit 0
exit 2
