# Date and Time

To maintain accuracy of your system's clock, you can use the [Network Time
Protocol](https://en.wikipedia.org/wiki/Network_Time_Protocol) (NTP).

Void provides packages for three NTP daemons: NTP, OpenNTPD and Chrony.

Once you have installed an NTP daemon, you can [enable the
service](../runit/managing.md).

## NTP

NTP is the official reference implementation of the Network Time Protocol.

The `ntp` package provides NTP and the `isc-ntpd` service.

For further information, visit [the NTP site](http://www.ntp.org/).

## OpenNTPD

OpenNTPD focuses on providing a secure, lean NTP implementation which "just
works" with reasonable accuracy for a majority of use-cases.

The `openntpd` package provides OpenNTPD and the `openntpd` service.

For further information, visit [the OpenNTPD site](http://www.openntpd.org/).

## Chrony

Chrony is designed to work well in a variety of conditions; it can synchronise
faster and with greater accuracy than NTP.

The `chrony` package provides Chrony and the `chronyd` service.

The Chrony site provides [a brief overview of its advantages over
NTP](https://chrony.tuxfamily.org/faq.html#_how_does_code_chrony_code_compare_to_code_ntpd_code),
as well as [a detailed feature comparison between Chrony, NTP and
OpenNTPD](https://chrony.tuxfamily.org/comparison.html).
