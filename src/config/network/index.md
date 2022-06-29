# Network

Network configuration in Void Linux can be done in several ways. The default
installation comes with the [dhcpcd(8)](https://man.voidlinux.org/dhcpcd.8)
service enabled.

## Interface Names

Newer versions of [udev(7)](https://man.voidlinux.org/udev.7) no longer use the
traditional Linux naming scheme for interfaces (`eth0`, `eth1`, `wlan0`, ...).

This behavior can be reverted by adding `net.ifnames=0` to the [kernel
cmdline](../kernel.md#cmdline).

## Static Configuration

A simple way to configure a static network at boot is to add the necessary
[ip(8)](https://man.voidlinux.org/ip.8) commands to the `/etc/rc.local` file:

```
ip link set dev eth0 up
ip addr add 192.168.1.2/24 brd + dev eth0
ip route add default via 192.168.1.1
```

## Bridge Interfaces

To configure bridge interfaces at boot, the `/etc/rc.local` file can be used to
run [ip(8)](https://man.voidlinux.org/ip.8) commands to add the bridge `br0` and
set it as the master for the `eth0` interface as example:

```
ip link add name br0 type bridge
ip link set eth0 master br0
ip link set eth0 up
```

## dhcpcd

To run [dhcpcd(8)](https://man.voidlinux.org/dhcpcd.8) on all interfaces, enable
the `dhcpcd` service.

To run `dhcpcd` only on a specific interface, copy the `dhcpcd-eth0` service and
modify it to match your interface:

```
$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/ether ff:ff:ff:ff:ff:ff brd ff:ff:ff:f
# cp -R /etc/sv/dhcpcd-eth0 /etc/sv/dhcpcd-enp3s0
# sed -i 's/eth0/enp3s0/' /etc/sv/dhcpcd-enp3s0/run
# ln -s /etc/sv/dhcpcd-enp3s0 /var/service/
```

For more information on configuring `dhcpcd`, refer to
[dhcpcd.conf(5)](https://man.voidlinux.org/dhcpcd.conf.5)

## Wireless

Before using wireless networking, use
[rfkill(8)](https://man.voidlinux.org/rfkill.8) to check whether the relevant
interfaces are soft- or hard-blocked.

Void provides several ways to connect to wireless networks:

- [wpa_supplicant](./wpa_supplicant.md)
- [iwd](./iwd.md)
- [NetworkManager](./networkmanager.md)
- [ConnMan](./connman.md)
