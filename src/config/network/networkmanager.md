# NetworkManager

[NetworkManager(8)](https://man.voidlinux.org/NetworkManager.8) is a daemon that
manages Ethernet, Wi-Fi, and mobile broadband network connections. Install the
`NetworkManager` package for the basic NetworkManager utilities.

## Starting NetworkManager

Before enabling the NetworkManager daemon, [disable](../services/index.md) any
other network management services, such as [dhcpcd](./index.md#dhcpcd),
[wpa_supplicant](./wpa_supplicant.md), or `wicd`. These services all control
network interface configuration, and will interfere with NetworkManager.

Also ensure that the `dbus` service is [enabled](../services/index.md) and
running. NetworkManager uses `dbus` to expose networking information and a
control interface to clients, and will fail to start without it.

NetworkManager uses `resolvconf` from the `openresolv` package to manage DNS
configuration by default. If `/etc/resolv.conf` is already a symlink or is
managed by another service, NetworkManager may not manage it as expected. Check
and remove or adjust the existing resolver configuration before switching to
NetworkManager.

Finally, enable the `NetworkManager` service.

## Configuring NetworkManager

NetworkManager uses polkit to authorize network management operations performed
by unprivileged users. The `NetworkManager` package provides a polkit rule that
grants these permissions to members of the `network` group. Install the `polkit`
package, [enable](../services/index.md) the `polkitd` service, and add the user
to the `network` group.

The `NetworkManager` package includes a command line tool,
[nmcli(1)](https://man.voidlinux.org/nmcli.1), and a text-based user interface,
[nmtui(1)](https://man.voidlinux.org/nmtui.1), to control network settings.

There are many other front-ends to NetworkManager, including `nm-applet` (from
`network-manager-applet`) or `nm-tray` for system trays, `plasma-nm` for KDE
Plasma, and a built-in network configuration tool in GNOME.

## Eduroam with NetworkManager

Eduroam is a roaming service providing international, secure Internet access at
universities and other academic institutions. More information can be found
[here](https://eduroam.org/).

### Dependencies

Install the `python3-dbus` package.

### Installation

Download the correct eduroam_cat installer for your institution from
[here](https://cat.eduroam.org/) and execute it. It will provide a user
interface guiding you through the process.
