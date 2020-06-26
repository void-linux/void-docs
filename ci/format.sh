#!/bin/sh

echo "Installing mdbook-linkcheck"

_version="v0.7.0"
curl -sL -o ~/bin/linkcheck.tar.gz "https://github.com/Michael-F-Bryan/mdbook-linkcheck/releases/download/${_version}/mdbook-linkcheck-${_version}-x86_64-unknown-linux-gnu.tar.gz"

tar xvf ~/bin/linkcheck.tar.gz -C ~/bin

echo "Checking links"

~/bin/mdbook-linkcheck -s
LINKCHECK=$?

echo "Installing Go"

curl -sL -o ~/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
chmod +x ~/bin/gimme

eval "$(gimme stable)"

go get github.com/bobertlo/vmd/cmd/vmdfmt

echo "Checking formatting"

PATH=$PATH:$(go env GOPATH)/bin/

if ! command -v git ; then
    echo "You need git to run the CI scripts"
    exit 1
fi

if ! command -v vmdfmt ; then
    echo "You need vmdfmt to run the CI scripts"
    exit 1
fi

# Fetch upstream
git fetch git://github.com/void-linux/void-docs.git master

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
./ci/check-summary.sh
SUMMARY=$?

# Generate exit value
if [ ! -z $VMDFMT ] || [ ! $LINKCHECK -eq 0 ] || [ ! $SUMMARY -eq 0 ] ; then
    exit 2
fi
