# Locales

For a list of currently enabled locales, run

```
locale -a
```

## Enabling locales

To enable the locale `xxxx`, un-comment or add the relevant line in
`/etc/default/libc-locale.conf` and run

```
# xbps-reconfigure -f glibc-locales
```

## Setting the system locale

Set `LANG=xxxx` in `/etc/locale.conf`.
