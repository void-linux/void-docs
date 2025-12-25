# Firewalls

## iptables

By default, the `iptables` package is installed on the base system. It provides
[iptables(8)/ip6tables(8)](https://man.voidlinux.org/iptables.8). The related
services use the `/etc/iptables/iptables.rules` and
`/etc/iptables/ip6tables.rules` ruleset files, which must be created by the
system administrator.

Two example rulesets are provided in the `/etc/iptables` directory:
`empty.rules` and `simple_firewall.rules`.

### Applying the rules at boot

To apply iptables rules at runit stage 1, install the `runit-iptables` package.
This adds a core-service which restores the `iptables.rules` and
`ip6tables.rules` rulesets.

Alternatively, to apply these rules at stage 2, add the following to
`/etc/rc.local`:

```
if [ -e /etc/iptables/iptables.rules ]; then
  iptables-restore /etc/iptables/iptables.rules
fi

if [ -e /etc/iptables/ip6tables.rules ]; then
  ip6tables-restore /etc/iptables/ip6tables.rules
fi
```

After rebooting, check the active firewall rules:

```
# iptables -L
# ip6tables -L
```

### Applying the rules at runtime

`iptables` comes with two runit services, `iptables` and `ip6tables`, to quickly
flush or restore the `iptables.rules` and `ip6tables.rules` rulesets. Once these
services are [enabled](../services/index.md#enabling-services), you can flush
the rulesets by downing the relevant service, e.g.:

```
# sv down iptables
```

and restore them by upping the relevant service, e.g.:

```
# sv up ip6tables
```

## nftables

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

### Applying the rules at boot

To apply nftables rules at runit stage 1, install the `runit-nftables` package.
This adds a core-service which restores the ruleset in `/etc/nftables.conf`.

### Applying the rules at runtime

The `nftables` package provides the `nftables` service, which uses rules from
`/etc/nftables.conf`. Once you [enable](../services/index.md#enabling-services)
the `nftables` service, to load the rules, run:

```
# sv up nftables
```

To flush the rules, run:

```
# sv down nftables
```
