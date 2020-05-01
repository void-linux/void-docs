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

## Applying the rules at runtime

`iptables` comes with a runit service which is handy to quickly flush or restore
the rules on demand.

## Applying the rules at boot

The aforementioned service file is not suitable to ensure iptables rules are
applied before network is up (due to the fact that runit starts services in
parallel in stage 2).

To apply the rules at stage 1, either install the `runit-iptables` package
(which adds a core-service) or add these lines to `/etc/rc.local`:

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
