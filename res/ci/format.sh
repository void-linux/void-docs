#!/bin/sh

echo "Checking links"
RUST_LOG=linkcheck=debug mdbook-linkcheck -s
LINKCHECK=$?

# Format them
printf "Formatting tree"
vmdfmt -l -w src/

# Check Status
if [ ! -z "$(git status --porcelain)" ] ; then
    git diff
    echo "Working directory not clean, files to be formatted:"
    git status
    VMDFMT=1
fi

# Check SUMMARY.md
echo ""
echo "Checking SUMMARY.md"
res/ci/check-summary.sh
SUMMARY=$?

# Generate exit value
if [ ! -z $VMDFMT ] || [ ! $LINKCHECK -eq 0 ] || [ ! $SUMMARY -eq 0 ] ; then
    exit 2
fi
