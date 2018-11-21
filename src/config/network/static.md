# Static configuration

A static network in Void Linux can be configured with
[ip(8)](https://man.voidlinux.org/ip.8).

A simple way to configure the static network at boot is to add the necessary
[ip(8)](https://man.voidlinux.org/ip.8) commands to the `/etc/rc.local` file.

```
# Static IP configuration via iproute
ip link set dev eth0 up
ip addr add 192.168.1.2/24 brd + dev eth0
ip route add default via 192.168.1.1
```

