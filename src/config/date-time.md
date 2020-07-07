# Date and Time

To view your system's current date and time information, as well as make direct
changes to it, use [date(1)](https://man.voidlinux.org/date.1).

## Timezone

The default system timezone can be set by linking the timezone file to
`/etc/localtime`:

```
# ln -sf /usr/share/zoneinfo/<timezone> /etc/localtime
```

To change the timezone on a per user basis, the `TZ` variable can be exported
from your shell's profile:

```
export TZ=<timezone>
```

## Hardware clock

By default, the hardware clock in Void is stored as UTC. Windows does not use
UTC by default, and if you are dual-booting, this will conflict with Void. You
can either change Windows to use UTC, or change Void Linux to use `localtime` by
setting the `HARDWARECLOCK` variable in `/etc/rc.conf`:

```
export HARDWARECLOCK=localtime
```

For more details, see [hwclock(8)](https://man.voidlinux.org/hwclock.8).

## NTP

To maintain accuracy of your system's clock, you can use the [Network Time
Protocol](https://en.wikipedia.org/wiki/Network_Time_Protocol) (NTP).

Void provides packages for three NTP daemons: NTP, OpenNTPD and Chrony.

Once you have installed an NTP daemon, you can [enable the
service](../config/services/index.md#managing-services).

### NTP

NTP is the official reference implementation of the Network Time Protocol.

The `ntp` package provides NTP and the `isc-ntpd` service.

For further information, visit [the NTP site](https://www.ntp.org/).

### OpenNTPD

OpenNTPD focuses on providing a secure, lean NTP implementation which "just
works" with reasonable accuracy for a majority of use-cases.

The `openntpd` package provides OpenNTPD and the `openntpd` service.

For further information, visit [the OpenNTPD site](http://www.openntpd.org/).

### Chrony

Chrony is designed to work well in a variety of conditions; it can synchronize
faster and with greater accuracy than NTP.

The `chrony` package provides Chrony and the `chronyd` service.

The Chrony site provides [a brief overview of its advantages over
NTP](https://chrony.tuxfamily.org/faq.html#_how_does_code_chrony_code_compare_to_code_ntpd_code),
as well as [a detailed feature comparison between Chrony, NTP and
OpenNTPD](https://chrony.tuxfamily.org/comparison.html).
