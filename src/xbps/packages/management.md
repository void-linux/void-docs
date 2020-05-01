# General Package Management

Most general package management is done with the following commands:

- [xbps-query(1)](https://man.voidlinux.org/xbps-query.1) searches for and
   displays information about packages installed locally, or, if used with the
   `-R` flag, packages contained in repositories.
- [xbps-install(1)](https://man.voidlinux.org/xbps-install.1) installs and
   updates packages, and syncs repository indexes.
- [xbps-remove(1)](https://man.voidlinux.org/xbps-remove.1) removes installed
   packages, and can remove cached package files.
- [xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) runs the
   configuration steps for installed packages, and can be used to reconfigure
   certain packages after changes in their configuration files. The latter
   usually requires the `--force` flag.

Most questions can be answered by consulting the man pages for these tools,
together with the [xbps.d(5)](https://man.voidlinux.org/xbps.d.5) man page. For
a more detailed overview of the X Binary Package System (XBPS), see the
documentation in the [xbps repository](https://github.com/void-linux/xbps).
