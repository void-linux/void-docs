# XBPS Package Manager

The X Binary Package System (XBPS) is a fast package manager that has been
designed and implemented from scratch. XBPS is managed by the Void Linux team
and developed at <https://github.com/void-linux/xbps>.

Most general package management is done with the following commands:

- [xbps-query(1)](https://man.voidlinux.org/xbps-query.1) searches for and
   displays information about packages installed locally, or, if used with the
   `-R` flag, packages contained in repositories.
- [xbps-install(1)](https://man.voidlinux.org/xbps-install.1) installs and
   updates packages, and syncs repository indexes.
- [xbps-remove(1)](https://man.voidlinux.org/xbps-remove.1) removes installed
   packages, and can also remove orphaned packages and cached package files.
- [xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) runs the
   configuration steps for installed packages, and can be used to reconfigure
   certain packages after changes in their configuration files. The latter
   usually requires the `--force` flag.
- [xbps-alternatives(1)](https://man.voidlinux.org/xbps-alternatives.1) lists or
   sets the alternatives provided by installed packages. Alternatives is a
   system which allows multiple packages to provide common functionality through
   otherwise conflicting files, by creating symlinks from the common paths to
   package-specific versions that are selected by the user.
- [xbps-pkgdb(1)](https://man.voidlinux.org/xbps-pkgdb.1) can report and fix
   issues in the package database, as well as modify it.

Most questions can be answered by consulting the man pages for these tools,
together with the [xbps.d(5)](https://man.voidlinux.org/xbps.d.5) man page.

To learn how to build packages from source, refer to [the README for the
void-packages
repository](https://github.com/void-linux/void-packages/blob/master/README.md).

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
$ xbps-query -l | awk '{ print $2 }' | xargs -n1 xbps-uhelper getpkgname
```

## Verifying RSA keys

If you are installing Void for the first time or the RSA keys randomly change,
you may get a message from `xbps-install` claiming:

```
<REPO> repository has been RSA signed by <RSA-FINGERPRINT>
```

To verify the signature, ensure the <RSA-FINGERPRINT> matches one of the
fingerprints in
[void-packages](https://github.com/void-linux/void-packages/tree/master/common/repo-keys) 
or [void-mklive](https://github.com/void-linux/void-mklive/tree/master/keys),
because the keys in those repos should match.
