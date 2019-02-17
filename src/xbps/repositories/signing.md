## Signing repositories

Remote repositories **must** be signed, local repositories do not need to be
signed.

The [xbps-rindex(1)](https://man.voidlinux.org/xbps-rindex.1) tool is used to
sign repositories. First initialize the repository metadata with signing
properties (this is only required once).

```
$ xbps-rindex --sign --signedby "I'm Groot" /path/to/repository/dir
```

Afterwards sign one or more packages with the following command:

```
$ xbps-rindex --signedby "I'm Groot" --sign-pkg /path/to/repository/dir/*.xbps
```

> Note: Future packages will not be automatically signed.
