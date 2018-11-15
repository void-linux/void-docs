# Mirrors

## Available mirrors

### Tier 1 Mirrors

| Repository | Location |
|:--------|:-------:|
| <http://alpha.de.repo.voidlinux.org> | EU: Germany |
| <http://beta.de.repo.voidlinux.org> | EU: Germany |
| <http://alpha.us.repo.voidlinux.org> | USA: Kansas City |
| <http://mirror.clarkson.edu/voidlinux/> | USA: New York |
| <http://mirrors.servercentral.com/voidlinux/> | USA: Chicago |

### Tier 2 Mirrors


| Repository | Location |
|:--------|:-------:|
| <http://mirror.aarnet.edu.au/pub/voidlinux/> | AU: Canberra |
| <http://ftp.swin.edu.au/voidlinux/> | AU: Melbourne |
| <http://ftp.acc.umu.se/mirror/voidlinux.eu/> | EU: Sweden |
| <https://mirrors.dotsrc.org/voidlinux/> | EU: Denmark |
| <http://www.gtlib.gatech.edu/pub/VoidLinux/> | USA: Atlanta |



## Changing mirrors

Copy all repository configuration files from `/usr/share/xbps.d` to
`/etc/xbps.d` and then change the repository urls in `/etc/xbps.d`.

```
# mkdir -p /etc/xbps.d
# cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d/
# sed -i 's|https://repo.voidlinux.org/current|<repository>|g' /etc/xbps.d/*-repository-*.conf
```

You can use `xbps-query` to verify that all repositories are changed
to the mirror you prefer.

```
$ xbps-query -L
 9970 https://alpha.de.repo.voidlinux.org/current (RSA signed)
   27 https://alpha.de.repo.voidlinux.org/current/multilib/nonfree (RSA signed)
 4230 https://alpha.de.repo.voidlinux.org/current/multilib (RSA signed)
   47 https://alpha.de.repo.voidlinux.org/current/nonfree (RSA signed)
 5368 https://alpha.de.repo.voidlinux.org/current/debug (RSA signed)
```

