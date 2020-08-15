# Repositories

Repositories are the heart of the XBPS package system. Repositories can be local
or remote. A repository contains binary package files, which may have
signatures, and a data file named `$ARCH-repodata` (e.g. `x86_64-repodata`),
which may also be signed.

Note that, while local repositories do not require signatures, remote
repositories *must* be signed.

## The main repository

The locations of the main repository in relation to a base [mirror
URL](./mirrors/index.md) are:

- glibc: `/current`
- musl: `/current/musl`
- aarch64 and aarch64-musl: `/current/aarch64`

## Subrepositories

In addition to the main repository, which is enabled upon installation, Void
provides other official repositories maintained by the Void project, but not
enabled by default:

- nonfree: contains software packages with non-free licenses
- multilib: contains 32-bit libraries for 64-bit systems (glibc only)
- multilib/nonfree: contains non-free multilib packages
- debug: contains debugging symbols for packages

These repositories can be enabled via the installation of the relevant package.
These packages only install a repository configuration file in
`/usr/share/xbps.d`.

### nonfree

Void has a `nonfree` repository for packages that don't have free licenses. It
can enabled by installing the `void-repo-nonfree` package.

Packages can end up in the `nonfree` repository for a number of reasons:

- Non-free licensed software with released source-code.
- Software released only as redistributable binary packages.
- Patented technology, which may or may not have an (otherwise) open
   implementation.

### multilib

The `multilib` repository provides 32-bit packages as a compatibility layer
inside a 64-bit system. It can be enabled by installing the `void-repo-multilib`
package.

These repositories are only available for `x86_64` systems running the `glibc` C
library.

### multilib/nonfree

The `multilib/nonfree` repository provides additional 32-bit packages which have
non-free licenses. It can be enabled by installing the
`void-repo-multilib-nonfree` package.

### debug

Void Linux packages come without debugging symbols. If you want to debug
software or look at a core dump you will need the debugging symbols. These
packages are contained in the debug repository. It can be enabled by installing
the `void-repo-debug` package.

Once enabled, symbols may be obtained for `<package>` by installing
`<package>-dbg`.

#### Finding debug dependencies

The `xtools` package contains the [xdbg(1)](https://man.voidlinux.org/xtools.1)
utility to retrieve a list of debug packages, including dependencies, for a
package:

```
$ xdbg bash
bash-dbg
glibc-dbg
# xbps-install -S $(xdbg bash)
```
