#!/bin/sh

# only show all the debug messages if ci is run with debug
if [ "$RUNNER_DEBUG" ]; then
    loglevel=debug
else
    loglevel=error
fi

printf "\033[37;1m=> Checking links\033[m\n"
RUST_LOG="linkcheck=$loglevel" mdbook-linkcheck -s -c always
