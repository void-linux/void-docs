#!/bin/sh

git config --global --add safe.directory "$PWD"

printf "\033[37;1m=> Checking links\033[m\n"
RUST_LOG=linkcheck=debug mdbook-linkcheck -s
LINKCHECK=$?

# Format them
printf "\n\033[37;1m=> Formatting tree\033[m\n"
vmdfmt -l -w src/

# Check Status
if [ ! -z "$(git status --porcelain)" ] ; then
    git diff
    printf "\033[31;1m=> Working directory not clean, files to be formatted:\033[m\n"
    git status
    VMDFMT=1
fi

# Check SUMMARY.md
printf "\n\033[37;1m=> Checking SUMMARY.md\033[m\n"
res/ci/check-summary.sh
SUMMARY=$?

# Generate exit value
if [ ! -z $VMDFMT ] || [ ! $LINKCHECK -eq 0 ] || [ ! $SUMMARY -eq 0 ] ; then
    exit 2
fi
