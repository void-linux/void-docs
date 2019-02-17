# Repositories

Repositories are the heart of the xbps package system. Repositories can be
locally or remotely available. A repository contains binary package files, which
may have signatures, and a data file named `$ARCH-repodata` (i.e.
`x86_64-repodata`) which may also be signed.

Note that, while local repositories do not require signatures, remote
repositories *must* be signed.
