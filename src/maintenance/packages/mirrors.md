# Mirrors

## Available mirrors

Void Linux maintains mirrors in several geographic regions for you to use. In
normal use your traffic will be routed to the nearest mirror to you based on
your IP Address. If you would like to directly use a particular mirror you can
set this manually. This can also be handy if you are on a different continent
than the primary mirror, or if you are not on the same continent as any
officially managed mirrors.

Mirrors are separated into two categories. Tier 1 mirrors sync directly from
the build-master and will always have the latest packages available. These
repositories are maintained by the Void Linux Infrastructure Team. In rare
occasions we may permit a mirror that we don’t manage to sync directly from our
primary servers if there are extenuating circumstances. Tier 2 mirrors sync from
a nearby tier 1 mirror when possible, but there is no guarantee of a mirror
being nearby. These mirrors are not managed by Void nor do they have any
specific guarantees for staleness or completeness of packages. Tier 2 mirrors
are free to sync only specific architectures and exclude sub-repositories
(nonfree/multilib).

### Tier 1 Mirrors

| Repository                                                                           | Location         |
|--------------------------------------------------------------------------------------|------------------|
| <http://alpha.de.repo.voidlinux.org>                                                 | EU: Germany      |
| <http://beta.de.repo.voidlinux.org>                                                  | EU: Germany      |
| <http://alpha.us.repo.voidlinux.org>                                                 | USA: Kansas City |
| <http://mirror.clarkson.edu/voidlinux/>                                              | USA: New York    |
| [http://mirrors.servercentral.com/voidlinux/](http://mirror.clarkson.edu/voidlinux/) | USA: Chicago     |

### Tier 2 Mirrors

| Repository                                   | Location      |
|----------------------------------------------|---------------|
| <http://mirror.aarnet.edu.au/pub/voidlinux/> | AU: Canberra  |
| <http://ftp.swin.edu.au/voidlinux/>          | AU: Melbourne |
| <http://ftp.acc.umu.se/mirror/voidlinux.eu/> | EU: Sweden    |
| <https://mirrors.dotsrc.org/voidlinux/>      | EU: Denmark   |
| <http://www.gtlib.gatech.edu/pub/VoidLinux/> | USA: Atlanta  |

## Changing mirrors

Copy all repository configuration files from `/usr/share/xbps.d` to
`/etc/xbps.d` and then change the repository urls in `/etc/xbps.d`.

```
# mkdir -p /etc/xbps.d
# cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d/
# sed -i 's|https://repo.voidlinux.org/current|<repository>|g' /etc/xbps.d/*-repository-*.conf
```

You can use `xbps-query` to verify that all repositories are changed to the
mirror you prefer.

```
$ xbps-query -L
 9970 https://alpha.de.repo.voidlinux.org/current (RSA signed)
   27 https://alpha.de.repo.voidlinux.org/current/multilib/nonfree (RSA signed)
 4230 https://alpha.de.repo.voidlinux.org/current/multilib (RSA signed)
   47 https://alpha.de.repo.voidlinux.org/current/nonfree (RSA signed)
 5368 https://alpha.de.repo.voidlinux.org/current/debug (RSA signed)
```

