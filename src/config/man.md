# Manual Pages

Many Void packages come with manual ('man') pages. The default installation
includes the [mandoc](https://mandoc.bsd.lv/) manpage toolset, via the `mdocml`
package.

The [man(1)](https://man.voidlinux.org/man.1) command can be used to show man
pages:

```
$ man chroot
```

Every man page belongs to a particular *section*:

- 1: User commands (Programs)
- 2: System calls
- 3: Library calls
- 4: Special files (devices)
- 5: File formats and configuration files
- 6: Games
- 7: Overview, conventions, and miscellaneous
- 8: System management commands

Refer to [man-pages(7)](https://man.voidlinux.org/man-pages.7) for details.

There are some man pages which have the same name, but are used in different
contexts, and are thus in a different section. You can specify which one to use
by including the section number in the call to `man`:

```
$ man 1 printf
```

`man` can be configured via [man.conf(5)](https://man.voidlinux.org/man.conf.5).

The `mandoc` toolset contains [apropos(1)](https://man.voidlinux.org/apropos.1),
which can be used to search for manual pages. `apropos` uses a database that can
be generated and updated with the
[makewhatis(8)](https://man.voidlinux.org/makewhatis.8) command:

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

The `mdocml` package provides a cron job to update the database daily,
`/etc/cron.daily/makewhatis`. You will need to install a [cron
daemon](./cron.md) for this functionality to be activated.

Development and POSIX manuals are not installed by default, but are available
via the `man-pages-devel` and `man-pages-posix` packages.
