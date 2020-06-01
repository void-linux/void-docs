# Void Docs

Welcome to the Void documentation. This repository contains the source data
behind <https://docs.voidlinux.org/>. Contributing to this repository follows
the same protocol as the packages tree. For details, please read
[CONTRIBUTING](./CONTRIBUTING.md).

## Building

The [build.sh](./build.sh) script builds HTML and roff versions of the Void
documentation and the `void-docs.7` man page. It requires the following
dependencies:

- `mdBook`
- `fd`
- `pandoc`
