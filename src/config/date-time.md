# Date and Time

## Timezone

The default system timezone can be set by linking the timezone file to
`/etc/localtime`:

```
# ln -sf /usr/share/zoneinfo/<timezone> /etc/localtime
```

To change the timezone on a per user basis, the `TZ` variable can be exported
from your shells profile:

```
export TZ=<timezone>
```

## Hardware clock

By default the hardware clock is stored as UTC in Void Linux, Windows does not
use UTC by default and conflicts with Void Linux, you can either change windows
to use UTC or Void Linux to use `localtime`.

To change how the hardware clock is read and written, change the `HARDWARECLOCK`
variable in `/etc/rc.conf`.

## NTP

To maintain accuracy of your system's clock, you can use the [Network Time
Protocol](https://en.wikipedia.org/wiki/Network_Time_Protocol) (NTP).

Void provides packages for three NTP daemons: NTP, OpenNTPD and Chrony.

Once you have installed an NTP daemon, you can [enable the
service](../config/services/managing.md).

### NTP

NTP is the official reference implementation of the Network Time Protocol.

The `ntp` package provides NTP and the `isc-ntpd` service.

For further information, visit [the NTP site](http://www.ntp.org/).

### OpenNTPD

OpenNTPD focuses on providing a secure, lean NTP implementation which "just
works" with reasonable accuracy for a majority of use-cases.

The `openntpd` package provides OpenNTPD and the `openntpd` service.

For further information, visit [the OpenNTPD site](http://www.openntpd.org/).

### Chrony

Chrony is designed to work well in a variety of conditions; it can synchronise
faster and with greater accuracy than NTP.

The `chrony` package provides Chrony and the `chronyd` service.

The Chrony site provides [a brief overview of its advantages over
NTP](https://chrony.tuxfamily.org/faq.html#_how_does_code_chrony_code_compare_to_code_ntpd_code),
as well as [a detailed feature comparison between Chrony, NTP and
OpenNTPD](https://chrony.tuxfamily.org/comparison.html).
