#!/bin/sh

# reset variable so it doesn't use the environment one
MISSING=

printf "Checking for mdbook-linkcheck ... "
if ! command -v mdbook-linkcheck; then
    MISSING="$MISSING mdbook-linkcheck"
    echo "not found"
fi

printf "Checking for vmdfmt ... "
if ! command -v vmdfmt; then
    MISSING="$MISSING vmdfmt"
    echo "not found"
fi

if [ "$MISSING" ]; then

    printf "Checking for xbps-install ... "
    if ! command -v xbps-install; then
        echo "not found"
        echo "Please manually install: $MISSING"
        exit 1    
    fi

    printf "Checking for sudo ... "
    if command -v sudo; then
        SU_CMD='sudo'
    else
        echo "not found"
        echo "Checking for doas ... "
        if command -v doas; then
            SU_CMD='doas'
        else
            echo "not found"
            "Please manually install: $MISSING"
            exit 1
        fi
    fi

    printf "\nTrying to install %s ... " "${MISSING## }"
    $SU_CMD xbps-install $MISSING
    echo

    # Check whether executables are now present.

    for i in $MISSING; do
        if ! command -v "$i" >/dev/null 2>&1; then
            UNAVAILABLE="$UNAVAILABLE $i"
        fi
    done

    if [ "$UNAVAILABLE" ]; then
        echo "Can't proceed without: ${UNAVAILABLE## }. Aborting."
        exit 1
    fi

fi

vmdfmt -l -w src/

if command -v mdbook >/dev/null 2>&1; then
    echo "Building book and checking links with mdbook ..."
    mdbook build
else
    echo "Checking links with mdbook-linkcheck ..."
    mdbook-linkcheck -s
fi

echo "Checks completed."
