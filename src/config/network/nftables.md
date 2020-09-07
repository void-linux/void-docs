# nftables

`nftables` replaces `iptables`, `ip6tables`, `arptables` and `ebtables`
(collectively referred to as `xtables`). The [nftables
wiki](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page) describes
[the main
differences](https://wiki.nftables.org/wiki-nftables/index.php/Main_differences_with_iptables)
from the `iptables` toolset.

To use `nftables`, install the `nftables` package, which provides
[nft(8)](https://man.voidlinux.org/nft.8). It also provides
[iptables-translate(8)/ip6tables-translate(8)](https://man.voidlinux.org/iptables-translate.8)
and
[iptables-restore-translate(8)/ip6tables-restore-translate(8)](https://man.voidlinux.org/iptables-restore-translate.8),
which convert `iptables` rules to `nftables` rules.

## Applying the rules at boot

To apply nftables rules at runit stage 1, install the `runit-nftables` package.
This adds a core-service which restores the ruleset in `/etc/nftables.conf`.

## Applying the rules at runtime

The `nftables` package provides the `nftables` service, which uses rules from
`/etc/nftables.conf`. [Enabling](../services/index.md#enabling-services) the
service will load the rules.

To flush the rules, run:

```
# sv down nftables
```

To re-load the rules, run:

```
# sv up nftables
```
