# Repositories

Repositories are the heart of the XBPS package system. Repositories can be local
or remote. A repository contains binary package files, which may have
signatures, and a data file named `$ARCH-repodata` (e.g. `x86_64-repodata`),
which may also be signed.

Note that, while local repositories do not require signatures, remote
repositories *must* be signed.

## Official Repositories

In addition to the main repository, which is enabled upon installation, Void
provides other official repositories maintained by the Void project, but not
enabled by default:

- [debug](./debug.md): contains debugging symbols for packages
- [multilib](./multilib.md): contains 32-bit libraries for 64-bit systems (glibc
   only)
- [multilib/nonfree](./multilib.md): contains non-free multilib packages
- [nonfree](./nonfree.md): contains software packages with non-free licenses

These repositories can be enabled via the installation of the relevant package.
For example, to enable the `nonfree` repository, install the `void-repo-nonfree`
package. These packages only install a repository configuration file in
`/usr/share/xbps.d`.
