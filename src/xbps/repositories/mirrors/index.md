# Mirrors

Void Linux maintains mirrors in several geographic regions for you to use. A
fresh install will default to using the master mirror in Europe, but you may
also [select a different mirror](./changing.md) manually.

## Tier 1 mirrors

Tier 1 mirrors are maintained by the Void Linux Infrastructure Team. These
mirrors sync directly from the build-master and will always have the latest
packages available.

By default XBPS will reach out to <https://repo-default.voidlinux.org> which may
map to any tier 1 mirror.

| Repository                                     | Location         |
|------------------------------------------------|------------------|
| <https://repo-fi.voidlinux.org/>               | EU: Finland      |
| <https://mirrors.servercentral.com/voidlinux/> | USA: Chicago     |
| <https://repo-us.voidlinux.org/>               | USA: Kansas City |
| <https://repo-de.voidlinux.org/>               | EU: Germany      |

## Tier 2 mirrors

Tier 2 mirrors sync from a nearby Tier 1 mirror when possible. These mirrors are
not managed by Void and do not have any guarantees of freshness or completeness
of packages, nor are they required to sync every available architecture or
sub-repository.

### Globally-available mirrors

| Repository                                         | Location          |
|----------------------------------------------------|-------------------|
| <https://mirror.ps.kz/voidlinux/>                  | Asia: Almaty, KZ  |
| <https://mirrors.bfsu.edu.cn/voidlinux/>           | Asia: China       |
| <https://mirrors.cnnic.cn/voidlinux/>              | Asia: China       |
| <https://mirrors.tuna.tsinghua.edu.cn/voidlinux/>  | Asia: China       |
| <https://mirror.sjtu.edu.cn/voidlinux/>            | Asia: China       |
| <https://mirror.nju.edu.cn/voidlinux/>             | Asia: China       |
| <https://void.webconverger.org/>                   | Asia: Singapore   |
| <https://mirror.aarnet.edu.au/pub/voidlinux/>      | AU: Canberra      |
| <https://ftp.swin.edu.au/voidlinux/>               | AU: Melbourne     |
| <https://void.cijber.net/>                         | EU: Amsterdam, NL |
| <http://ftp.dk.xemacs.org/voidlinux/>              | EU: Denmark       |
| <https://mirrors.dotsrc.org/voidlinux/>            | EU: Denmark       |
| <https://quantum-mirror.hu/mirrors/pub/voidlinux/> | EU: Hungary       |
| <https://voidlinux.mirror.garr.it/>                | EU: Italy         |
| <http://ftp.debian.ru/mirrors/voidlinux/>          | EU: Russia        |
| <https://mirror.yandex.ru/mirrors/voidlinux/>      | EU: Russia        |
| <https://mirror.accum.se/mirror/voidlinux/>        | EU: Sweden        |
| <https://ftp.lysator.liu.se/pub/voidlinux/>        | EU: Sweden        |
| <https://void.sakamoto.pl/>                        | EU: Warsaw, PL    |
| <https://mirror.vofr.net/voidlinux/>               | USA: California   |
| <https://mirror2.sandyriver.net/pub/voidlinux/>    | USA: Kentucky     |
| <https://mirror.clarkson.edu/voidlinux/>           | USA: New York     |
| <https://mirror.puzzle.ch/voidlinux/>              | EU: Bern, CH      |

## Tor Mirrors

Void Linux is also mirrored on the Tor network. See [Using Tor
Mirrors](./tor.md) for more information.

## Creating a mirror

If you'd like to set up a mirror, and are confident you can keep it reasonably
up-to-date, follow one of the many guides available for mirroring with
[rsync(1)](https://man.voidlinux.org/rsync.1), then submit a pull request to
[the void-docs repository](https://github.com/void-linux/void-docs) to add your
mirror to the appropriate mirror table on this page.

A full mirror requires around 1TB of storage. It is also possible to mirror only
part of the repositories. Excluding debug packages is one way of decreasing the
load on the Tier 1 mirrors, with low impact on users.

Please keep in mind that we pay bandwidth for all data sent out from the Tier 1
mirrors. You can respect this by only mirroring if your use case for your mirror
will offset the network throughput consumed by your mirror syncing.
