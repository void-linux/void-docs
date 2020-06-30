# Package Management

## Updating

Like any other system, it is important to keep Void up-to-date. Use
[xbps-install(1)](https://man.voidlinux.org/xbps-install.1) to update:

```
# xbps-install -Su
```

XBPS must use a separate transaction to update itself. If your update includes
the `xbps` package, you will need to run the above command a second time to
apply the rest of the updates.

### Restarting Services

XBPS does not restart services when they are updated. This task is left to the
administrator, so they can orchestrate maintenance windows, ensure reasonable
backup capacity, and generally be present for service upgrades.

To find processes running different versions than are present on disk, use the
`xcheckrestart` tool provided by the `xtools` package:

```
$ xcheckrestart
11339 /opt/google/chrome/chrome (deleted) (google-chrome)
```

`xcheckrestart` will print out the PID, path to the executable, status of the
path that was launched (almost always `deleted`) and the process name.

`xcheckrestart` can and should be run as an unprivileged user.

### Kernel Panic After Update

If you get a kernel panic after an update, it is likely your system ran out of
space in `/boot`. Refer to "[Removing old
kernels](../config/kernel.md#removing-old-kernels)" for further information.

## Downgrading

XBPS allows you to downgrade a package to a specific package version.

### Via xdowngrade

The easiest way to downgrade is to use `xdowngrade` from the `xtools` package,
specifying the package version to which you wish to downgrade:

```
# xdowngrade /var/cache/xbps/pkg-1.0_1.xbps
```

### Via XBPS

XBPS can be used to downgrade to a package version that is no longer available
in the repository index.

If the package version had been installed previously, it will be available in
`/var/cache/xbps/`. If not, it will need to be obtained from elsewhere; for the
purposes of this example, it will be assumed that the package version has been
added to `/var/cache/xbps/`.

First add the package version to your local repository:

```
# xbps-rindex -a /var/cache/xbps/pkg-1.0_1.xbps
```

Then downgrade with `xbps-install`:

```
# xbps-install -R /var/cache/xbps/ -f pkg-1.0_1
```

The `-f` flag is necessary to force downgrade/re-installation of an already
installed package.

## Finding Files and Packages

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
