# Void Docs

Welcome to the Void documentation. This repository contains the source data
behind <https://docs.voidlinux.org/>. Contributing to this repository follows
the same protocol as the packages tree. For details, please read
[CONTRIBUTING](./CONTRIBUTING.md).

## Building

The `Makefile` builds HTML, roff and PDF versions of the Void documentation and
the `void-docs.1` man page. It requires the following Void packages:

- `mdBook-legacy`
- `findutils`
- `lowdown` (version 0.8.1 or greater)
- `mdbook-typst`
- `mdbook-linkcheck`
- `python3-md2gemini`

In order to build and install these files, set the `PREFIX` and `DESTDIR`
variables to appropriate values and run `make` to build, and `make install` to install.
