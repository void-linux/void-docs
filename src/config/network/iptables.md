# Firewall with iptables

The `iptables` package is installed by default on the base system, but not activated.

Check for the `iptables` and `ip6tables` directories:

```
$ ls /etc/sv
...
ip6tables
iptables
...
```

## Firewall rules

Two rulesets are already installed in the `/etc/iptables` directory:

```
$ ls /etc/iptables
...
empty.rules
simple_firewall.rules
...
```

The path to the ruleset is defined in the `run` file of the service directory:

```
$ cat /etc/sv/iptables/run

#!/bin/sh
[ ! -e /etc/iptables/iptables.rules ] && exit 0
iptables-restore -w 3 /etc/iptables/iptables.rules || exit 1
exec chpst -b iptables pause
```

## Adjusting the rules

You can take the `simple_firewall.rules` file as a basis, copy it so its name matches the one given in the `run` file, then modify the copy according to your needs.

```
$ cd /etc/iptables
# cp simple_firewall.rules iptables.rules
# vi iptables.rules
```

## Activating the service

Activate the service:

```
# ln -s /etc/sv/iptables /var/service/
```

Then check the active firewall rules:

```
# iptables -L
```

## IP6 firewall rules

Do something similar as desribed above, but work with the `/etc/sv/ip6tables` directory.
