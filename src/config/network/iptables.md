# Firewall with iptables

The `iptables` package is installed by default on the base system, but not
activated.

## Firewall rules

Two rulesets are already installed in the `/etc/iptables` directory:

```
$ ls /etc/iptables
...
empty.rules
simple_firewall.rules
...
```

### Adjusting the rules

You can take the `simple_firewall.rules` file as a basis, copy it, then modify
the copy according to your needs.

```
$ cd /etc/iptables
# cp simple_firewall.rules iptables.rules
# vi iptables.rules
```

## Applying the rules

`iptables` should not be activated as a runit service. The runit services start
in parallel, so the web service might start before the iptables rules are
loaded.

Instead, add these lines to `/etc/rc.local` to import the rules from
`/etc/iptables/iptables.rules`:

```
if [ -e /etc/iptables/iptables.rules ]; then
  iptables-restore /etc/iptables/iptables.rules
fi
```

Reboot, and check the active firewall rules:

```
# iptables -L
```

## IP6 firewall rules

As described above, but work with `/sbin/ip6tables-restore` instead.
