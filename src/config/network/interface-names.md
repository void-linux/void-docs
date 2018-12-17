# Interface Names

In newer versions udev changed the well known traditional linux naming scheme
(`eth0`, `eth0`, `wlan0`, ...).

This behaviour can be reverted by adding `net.ifnames=0` to the [kernel
cmdline](/config/kernel.html#cmdline).
