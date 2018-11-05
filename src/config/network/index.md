# Network

The Network configuration in Void Linux can be done with different methods, the
default installation comes with [dhcpcd(8)](https://man.voidlinux.eu/dhcpcd.1).

## Network configuration

### Interface names

In newer versions udev changed the well known traditional naming scheme (`eth0`, `eth0`, `wlan0`, ...).
This behaviour can be reverted by adding `net.ifnames=0` to the [kernel cmdline](#cmdline).

## Static networking

A static network in Void Linux can be configured with [ip(8)](https://man.voidlinux.eu/ip.8).

A simple way to configure the static network at boot is to add the necessary [ip(8)](https://man.voidlinux.eu/ip.8) commands to the `/etc/rc.local` file.

```
# Static IP configuration via iproute
ip link set dev eth0 up
ip addr add 192.168.1.2/24 brd + dev eth0
ip route add default via 192.168.1.1
```
