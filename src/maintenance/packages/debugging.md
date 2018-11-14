# Package debugging

Void Linux packages come without debugging symbols, if you want to debug
software or look at a coredump it is helpful to have the debugging
symbols. To get debugging symbols for packages you need to activate the
debug repo, afterwards its possible to install packages with the `-dbg`
suffix.

    $ xbps-install -S void-repo-debug
    $ xbps-install -S <package name>-dbg

The `xtools` package contains the `xdbg` utility to retrieve a list of
debug packages including dependencies for a package.

    $ xdbg bash
    bash-dbg
    glibc-dbg
    # xbps-install -S $(xdbg bash)
