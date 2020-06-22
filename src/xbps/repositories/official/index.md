# Official Repositories

Void provides other official repositories, which are maintained by the Void
project, but not installed in the default configuration. The following table
describes XBPS packages you can install to enable additional repositories and
what those repositories contain.

| Package                      | Description                                           | Link                                  |
|------------------------------|-------------------------------------------------------|---------------------------------------|
| `void-repo-multilib`         | 32-bit compatibility packages                         | [multilib](#Multilib)                 |
| `void-repo-mulitlib-nonfree` | 32-bit compatibility packages with nonfree components | [multilib-nonfree](#Multilib-Nonfree) |
| `void-repo-nonfree`          | packages with non-free licenses                       | [nonfree](#Nonfree)                   |
| `void-repo-debug`            | debug symbols for packages                            | [debug](#Debug)                       |

## Installing

These repositories can be installed from the packages named in the table above.
For example, to install the `nonfree` repository, install the package
`void-repo-nonfree`.

These packages install a repository configuration file in `/usr/share/xbps.d`.

## Nonfree

Void has a `nonfree` repository for packages that don't have free licenses.
Install the `void-repo-nonfree` package to enable this repository.

Packages can end up in the `nonfree` repository for a number of reasons:

- Non-Free licensed software with released source-code.
- Software released only as redistributable binary packages.
- Patented technology, which may or may not have an (otherwise) open
   implementation.

## Multilib

The `multilib` repository provides 32-bit packages as a compatibility layer
inside a 64-bit system and is available through the package
`void-repo-multilib`.

These repositories are only available for `x86_64` systems running the `glibc` C
library.

## Mulilib-Nonfree

The `multilib/nonfree` repository (available through the package
`void-repo-multilib-nonfree`) provides additional 32-bit packages which have
non-free licenses. See [nonfree](./nonfree.md) for more information about why
these packages are separated.

## Debug

Void Linux packages come without debugging symbols, if you want to debug
software or look at a coredump you will need the debugging symbols. These
packages are contained in the debug repo. Install the `void-repo-debug` package
to enable this repository.

### Finding debug dependencies

The `xtools` package contains the `xdbg` utility to retrieve a list of debug
packages including dependencies for a package.

```
$ xdbg bash
bash-dbg
glibc-dbg
```

The output of `xdbg` can be piped into `xbps-install`:

```
# xbps-install -S $(xdbg bash)
```
