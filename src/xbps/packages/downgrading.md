# Downgrading to a specific package version

## Via xdowngrade

The easiest way to downgrade is to use `xdowngrade` from the `xtools` package,
specifying the package version you wish to downgrade to:

```
# xdowngrade /var/cache/xbps/pkg-1.0_1.xbps
```

## Via XBPS

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

The `-f` flag is necessary to force downgrade/reinstallation of an already
installed package.
