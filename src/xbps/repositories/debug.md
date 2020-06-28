# debug

Void Linux packages come without debugging symbols, if you want to debug
software or look at a core dump you will need the debugging symbols. These
packages are contained in the debug repo. Install the `void-repo-debug` package
to enable this repository.

## Installing debugging symbols

To get debugging symbols for packages, activate the `void-repo-debug` repo. Once
enabled, symbols may be obtained for `package` by installing `package-dbg`.

## Finding debug dependencies

The `xtools` package contains the `xdbg` utility to retrieve a list of debug
packages including dependencies for a package.

```
$ xdbg bash
bash-dbg
glibc-dbg
# xbps-install -S $(xdbg bash)
```
