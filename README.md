# Void Docs

Welcome to the Void documentation. This repository contains the source data
behind <https://docs.voidlinux.org/>. Contributing to this repository follows
the same protocol as the packages tree. For details, please read
[CONTRIBUTING](./CONTRIBUTING.md).

## Building

The [res/build.sh](./res/build.sh) script builds HTML, roff and PDF versions of
the Void documentation and the `void-docs.1` man page. It requires the following
Void packages:

- `mdBook`
- `findutils`
- `lowdown` (version 0.8.1 or greater)
- `texlive`
- `perl`
- `perl-JSON`
- `librsvg-utils`

In order to build and install these files, set the `PREFIX` and `DESTDIR`
environment variables to appropriate values and run `res/build.sh` followed by
`res/install.sh`.
