# dhcpcd

To run [dhcpcd(8)](https://man.voidlinux.org/dhcpcd.8) on all interfaces you can
enable the `dhcpcd` service.

```
# ln -s /etc/sv/dhcpcd /var/service
```

If you want to run dhcpcd just on a specific interface you can use the
`dhcpcd-eth0` service if this matches your interface name. Otherwise you can
just copy `dhcpcd-eth0` and change it to match your interface.

```
$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/ether ff:ff:ff:ff:ff:ff brd ff:ff:ff:f
# cp -R /etc/sv/dhcpcd-eth0 /etc/sv/dhcpcd-enp3s0
# sed -i 's/eth0/enp3s0/' /etc/sv/dhcpcd-enp3s0/run
# ln -s /etc/sv/dhcpcd-enp3s0 /var/service
```

For more information on configuring dhcpcd see
[dhcpcd.conf(5)](https://man.voidlinux.org/dhcpcd.conf.5)

