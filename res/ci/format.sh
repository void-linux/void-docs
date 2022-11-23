#!/bin/sh

printf "\n\033[37;1m=> Formatting tree\033[m\n"
vmdfmt -l -w src/

# Check Status
if [ ! -z "$(git status --porcelain)" ] ; then
    git diff --color=always
    printf "\033[31;1m=> Files which need to be formatted:\033[m\n"
    for f in $(git status | grep -Po 'modified:\K.*$'); do
        printf "$f\n"
        printf "::error title=Formatting Lint,file=$f,line=1::File has improper formatting\n"
    done
    exit 1
fi
