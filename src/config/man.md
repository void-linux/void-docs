# Manual Pages

Void packages come with manual pages and the default installation includes the
[mandoc](https://mandoc.bsd.lv/) manpage toolset.

The [man(1)](https://man.voidlinux.org/man.1) command can be used to show manual
pages.

```
$ man 1 chroot
```

The `mandoc` toolset contains [apropos(1)](https://man.voidlinux.org/apropos.1),
which can be used to search for manual pages. `apropos` uses a database that can
be updated and generated with the
[makewhatis(8)](https://man.voidlinux.org/makewhatis.8) command.

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

`man-pages-devel` and `man-pages-posix` are extra packages which are not
installed by default. They contain development and POSIX manuals, respectively.
