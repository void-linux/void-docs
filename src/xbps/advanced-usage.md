# Advanced Usage

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

## Holding packages

To prevent a package from being updated during a system update, use
[xbps-pkgdb(1)](https://man.voidlinux.org/xbps-pkgdb.1):

```
# xbps-pkgdb -m hold pkg
```

The hold can be removed with:

```
# xbps-pkgdb -m unhold pkg
```

## Repository-locking packages

If you've used `xbps-src` to build and install a package from a customized
template, or with custom build options, you may wish to prevent system updates
from replacing that package with a non-customized version. To ensure that a
package is only updated from the same repository used to install it, you can
*repolock* it via [xbps-pkgdb(1)](https://man.voidlinux.org/xbps-pkgdb.1):

```
# xbps-pkgdb -m repolock pkg
```

To remove the repolock:

```
# xbps-pkgdb -m repounlock pkg
```

## Ignoring Packages

Sometimes you may wish to remove a package whose functionality is being provided
by another package, but will be unable to do so due to dependency issues. For
example, you may wish to use [doas(1)](https://man.voidlinux.org/doas.1) instead
of [sudo(8)](https://man.voidlinux.org/sudo.8), but will be unable to remove the
`sudo` package due to it being a dependency of the `base-system` package. To
remove it, you will need to *ignore* the `sudo` package.

To ignore a package, add an appropriate `ignorepkg` entry in an
[xbps.d(5)](https://man.voidlinux.org/xbps.d.5) configuration file. For example:

```
ignorepkg=sudo
```

You will then be able to remove the `sudo` package using
[xbps-remove(1)](https://man.voidlinux.org/xbps-remove.1).

## Virtual Packages

Virtual packages can be created with
[xbps.d(5)](https://man.voidlinux.org/xbps.d.5) `virtualpkg` entries. Any
request to the virtual package will be resolved to the real package. For
example, to create a `linux` virtual package which will resolve to the
`linux5.6` package, create an `xbps.d` configuration file with the contents:

```
virtualpkg=linux:linux5.6
```
