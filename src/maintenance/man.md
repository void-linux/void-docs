# Manual pages

Void packages come with manual pages and the default installation
includes the [mandoc](http://mandoc.bsd.lv/) manpage toolset.

The [man(1)](https://man.voidlinux.eu/man.1) command can be used to
show manual pages.

```
$ man 1 chroot
```

The [mandoc](http://mandoc.bsd.lv/) toolset contains
[apropos(1)](https://man.voidlinux.eu/apropos.1) to search for manual
pages, [apropos(1)](https://man.voidlinux.eu/apropos.1) uses a
database that can be updated and generated with the
[makewhatis(1)](https://man.voidlinux.eu/makewhatis.1) command.

```
# makewhatis -a
$ apropos chroot
chroot(1) - run command or interactive shell with special root directory
xbps-uchroot(1) - XBPS utility to chroot and bind mount with Linux namespaces
xbps-uchroot(1) - XBPS utility to chroot and bind mount with Linux namespaces
xbps-uunshare(1) - XBPS utility to chroot and bind mount with Linux user namespaces
xbps-uunshare(1) - XBPS utility to chroot and bind mount with Linux user namespaces
chroot(2) - change root directory
```

There are two extra packages for development and POSIX manuals that
are not installed by default.

```
$ xbps-query -Rs man-pages
[*] man-pages-4.11_1        Linux Documentation Project (LDP) manual pages
[-] man-pages-devel-4.11_1  Linux Documentation Project (LDP) manual pages - development pages
[-] man-pages-posix-2013a_3 Manual pages about POSIX systems
# xbps-install -S man-pages-devel man-pages-posix
```
