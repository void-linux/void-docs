# NetworkManager

[NetworkManager(8)](https://man.voidlinux.org/NetworkManager.8) is a daemon that
manages network connections on Ethernet, WiFi, and mobile broadband devices and
operates as an all-in-one solution to network management. The `NetworkManager`
package contains the basic utilities to run
[NetworkManager(8)](https://man.voidlinux.org/NetworkManager.8).

## Starting NetworkManager

To enable the [NetworkManager(8)](https://man.voidlinux.org/NetworkManager.8)
daemon, first [disable](../services/index.md) any other network managing
services like [dhcpcd](dhcpcd.md), [wpa_supplicant](wpa_supplicant.md), or
`wicd`. These services all control network interface configuration, and
interfere with each other.

Also, ensure that the `dbus` service is [enabled](../services/index.md) and
running. [NetworkManager(8)](https://man.voidlinux.org/NetworkManager.8) uses
`dbus` to expose networking information and a control interface to clients and
will fail to start without it.

Finally, enable the
[NetworkManager(8)](https://man.voidlinux.org/NetworkManager.8) service:

```
# ln -s /etc/sv/NetworkManager /var/service/
```

## Configuring NetworkManager

The `NetworkManager` package includes a command line tool,
[nmcli(1)](https://man.voidlinux.org/nmcli.1), and a Text User Interface,
[nmtui(1)](https://man.voidlinux.org/nmtui.1) to control network settings.

There are many other front-ends to
[NetworkManager(8)](https://man.voidlinux.org/NetworkManager.8), including
`nm-applet` for system trays, `nm-plasma` for KDE Plasma, and a built in network
configuration tool in GNOME.

# Eduroam with NetworkManager

Eduroam is a roaming service providing international, secure Ad-Hoc internet
access at universities and other academic institutions. More information can be
found [here](https://www.eduroam.org/).

## Dependencies

Make sure the NetworkManager and D-Bus services are running and enabled. Then
install the `python3-dbus` package.

## Installation

Download the correct eduroam_cat installer for your university from
[here](https://cat.eduroam.org/) and execute it. It'll provide a user interface
guiding you through the process.
