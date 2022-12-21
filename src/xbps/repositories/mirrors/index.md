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

| Repository                                     | Region        | Location                   |
|------------------------------------------------|---------------|----------------------------|
| <https://repo-fi.voidlinux.org/>               | Europe        | Finland                    |
| <https://repo-de.voidlinux.org/>               | Europe        | Frankfurt, Germany         |
| <https://mirrors.servercentral.com/voidlinux/> | North America | Chicago, United States     |
| <https://repo-us.voidlinux.org/>               | North America | Kansas City, United States |

## Tier 2 mirrors

Tier 2 mirrors sync from a nearby Tier 1 mirror when possible. These mirrors are
not managed by Void and do not have any guarantees of freshness or completeness
of packages, nor are they required to sync every available architecture or
sub-repository.

### Globally-available mirrors

| Repository                                         | Region        | Location                  |
|----------------------------------------------------|---------------|---------------------------|
| <https://mirror.ps.kz/voidlinux/>                  | Asia          | Almaty, Kazakhstan        |
| <https://mirrors.bfsu.edu.cn/voidlinux/>           | Asia          | Beijing, China            |
| <https://mirrors.cnnic.cn/voidlinux/>              | Asia          | Beijing, China            |
| <https://mirrors.tuna.tsinghua.edu.cn/voidlinux/>  | Asia          | Beijing, China            |
| <https://mirror.nju.edu.cn/voidlinux/>             | Asia          | China                     |
| <https://mirror.sjtu.edu.cn/voidlinux/>            | Asia          | Shanghai, China           |
| <https://void.webconverger.org/>                   | Asia          | Singapore                 |
| <https://void.cijber.net/>                         | Europe        | Amsterdam, Netherlands    |
| <https://mirror.puzzle.ch/voidlinux/>              | Europe        | Bern, Switzerland         |
| <http://ftp.dk.xemacs.org/voidlinux/>              | Europe        | Denmark                   |
| <https://mirrors.dotsrc.org/voidlinux/>            | Europe        | Denmark                   |
| <https://quantum-mirror.hu/mirrors/pub/voidlinux/> | Europe        | Hungary                   |
| <https://voidlinux.mirror.garr.it/>                | Europe        | Italy                     |
| <http://ftp.debian.ru/mirrors/voidlinux/>          | Europe        | Russia                    |
| <https://mirror.yandex.ru/mirrors/voidlinux/>      | Europe        | Russia                    |
| <https://mirror.accum.se/mirror/voidlinux/>        | Europe        | Sweden                    |
| <https://ftp.lysator.liu.se/pub/voidlinux/>        | Europe        | Sweden                    |
| <https://void.sakamoto.pl/>                        | Europe        | Warsaw, Poland            |
| <https://mirror.vofr.net/voidlinux/>               | North America | California, United States |
| <https://mirror2.sandyriver.net/pub/voidlinux/>    | North America | Kentucky, United States   |
| <https://mirror.clarkson.edu/voidlinux/>           | North America | New York, United States   |
| <https://mirror.aarnet.edu.au/pub/voidlinux/>      | Oceania       | Canberra, Australia       |
| <https://ftp.swin.edu.au/voidlinux/>               | Oceania       | Melbourne, Australia      |
| <https://voidlinux.com.br/repo/>                   | South America | Ouro Preto, Brazil        |
| <http://void.chililinux.com/voidlinux/>            | South America | Pimenta Bueno, Brazil     |

## Tor Mirrors

Void Linux is also mirrored on the Tor network. See [Using Tor
Mirrors](./tor.md) for more information.

## Creating a mirror

If you'd like to set up a mirror, and are confident you can keep it reasonably
up-to-date, follow one of the many guides available for mirroring with
[rsync(1)](https://man.voidlinux.org/rsync.1), then submit a pull request to
[the void-docs repository](https://github.com/void-linux/void-docs) to add your
mirror to the appropriate mirror table on this page.

A full mirror requires around 1.0 TB of storage. It is also possible to mirror
only part of the repositories. Excluding debug packages is one way of decreasing
the load on the Tier 1 mirrors, with low impact on users.

Please keep in mind that we pay bandwidth for all data sent out from the Tier 1
mirrors. You can respect this by only mirroring if your use case for your mirror
will offset the network throughput consumed by your mirror syncing.
