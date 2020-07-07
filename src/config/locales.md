# Locales

For a list of currently enabled locales, run

```
$ locale -a
```

## Enabling locales

To enable a certain locale, un-comment or add the relevant lines in
`/etc/default/libc-locales` and [reconfigure](../xbps/index.md) the
`glibc-locales` package.

## Setting the system locale

Set `LANG=xxxx` in `/etc/locale.conf`.

## Application locale

Some programs have their translations in a separate package that must be
installed in order to use them. You can
[search](../xbps/index.md#finding-files-and-packages) for the desired language
(e.g. "german" or "portuguese") in the package repositories and install the
packages relevant to the applications you use.
