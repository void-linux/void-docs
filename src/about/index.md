# About

Welcome to the Void Handbook! Please be sure to read the
"[../about-handbook/index.md](About this Handbook)" section to learn how to use
this documentation effectively.

Void is an independent, [rolling
release](https://en.wikipedia.org/wiki/Rolling_release) Linux distribution,
developed from scratch and not as a fork of any other distribution. There are a
few features that make Void unique:

- The [XBPS](https://github.com/void-linux/xbps) package manager, which is
   extremely fast, developed in-house, and performs checks when installing
   updates to ensure that libraries are not changed to incompatible versions
   which can break dependencies.
- The [musl libc](https://musl.libc.org/), which focuses on standards compliance
   and correctness, has first class support. This allows us to build certain
   components for musl systems statically, which would not be practical on glibc
   systems.
- The [LibreSSL](https://www.libressl.org/) fork is used instead of the mainline
   OpenSSL library. Developed as part of the OpenBSD project, LibreSSL is
   dedicated to the security, quality, and maintainability of this critical
   library.
- [runit](../config/services/index.md) is used for
   [init(8)](https://man.voidlinux.org/init.8). This allows Void to support musl
   as a second libc choice, which would not be possible with
   [systemd](https://www.freedesktop.org/wiki/Software/systemd/). A side effect
   of this decision is an init system with clean and efficient operation, and a
   small code base.

Void is developed in the spare time of a handful of developers, and is generally
considered stable enough for daily use. We do this for fun and hope that our
work will be useful to others.
