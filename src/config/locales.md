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

## Application locale

Some programs have their translations in a separate package and must be
installed in order to use them.

```
$ xbps-query -Rs german
[-] aspell-de-20161207.7.0_1      German dictionary for aspell
[-] firefox-esr-i18n-de-68.7.0_1  Firefox ESR German language pack
[-] firefox-i18n-de-75.0_1        Firefox German language pack
[-] fortune-mod-de-0.34_1         Collection of German fortune cookie files
# xbps-install -S firefox-i18n-de
```
