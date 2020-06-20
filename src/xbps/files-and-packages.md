# Finding Files and Packages

The `xtools` package contains the
[xlocate(1)](https://man.voidlinux.org/xlocate.1) utility. `xlocate` works like
[locate(1)](https://man.voidlinux.org/locate.1), but for files in the Void
package repositories:

```
$ xlocate -S
Fetching objects: 11688, done.
From https://alpha.de.repo.voidlinux.org/xlocate/xlocate
 + e122c3634...a2659176f master     -> master  (forced update)
$ xlocate xlocate
xtools-0.59_1   /usr/bin/xlocate
xtools-0.59_1   /usr/share/man/man1/xlocate.1 -> /usr/share/man/man1/xtools.1
```

It is also possible to use
[xbps-query(1)](https://man.voidlinux.org/xbps-query.1) to find files, though
this is strongly discouraged:

```
$ xbps-query -Ro /usr/bin/xlocate
xtools-0.46_1: /usr/bin/xlocate (regular file)
```

This requires `xbps-query` to download parts of every package to find the file.
`xlocate`, however, queries a locally cached index of all files, so no network
access is required.

To get a list of all installed packages, without their version:

```
$ xbps-query -l | awk '{ print $2 }' | xargs -n1 xbps-uhelper getpkgname | fmt
```
