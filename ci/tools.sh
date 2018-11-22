#!/bin/sh

echo "Installing Go"

curl -sL -o ~/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
chmod +x ~/bin/gimme

eval "$(gimme stable)"
