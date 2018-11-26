# Package debugging

Void Linux packages come without debugging symbols, if you want to debug
software or look at a coredump you will need the debugging symbols.

To get debugging symbols for packages, activate the debug repo. Once enabled,
symbols may be obtained for `package` by installing `package-dbg`.

```
$ xbps-install -S void-repo-debug
$ xbps-install -S <package name>-dbg
```

> Note: not all mirrors sync debug packages, most users will find that debug
> packages are slower to obtain as they may be crossing one or more oceans to
> get the files. Unless you need debugging symbols, it is recommended not to
> have the debug repository enabled.

The `xtools` package contains the `xdbg` utility to retrieve a list of debug
packages including dependencies for a package.

```
$ xdbg bash
bash-dbg
glibc-dbg
# xbps-install -S $(xdbg bash)
```
