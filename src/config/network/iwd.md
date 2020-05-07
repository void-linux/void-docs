# IWD

[IWD](https://iwd.wiki.kernel.org/) (iNet Wireless Daemon) is a wireless daemon
for Linux that aims to replace [WPA supplicant](./wpa_supplicant.md).

## Installation

Install the `iwd` package and enable the `dbus` and `iwd` services.

> Note: To use EAP-TLS, EAP-TTLS, and EAP-PEAP based configurations, version
> ≥4.20 of the kernel is required. Previous kernel versions do not include the
> necessary cryptographic authentication modules.

## Usage

The command-line client `iwctl(1)` can be used to add, remove, and configure
network connections. Commands can be passed as arguments; when run without
arguments, it provides an interactive session. To list available commands, run
either `iwctl help` or enter `help` at the interactive prompt.

> Note: By default, only the root user and those in the `wheel` group have
> permission to operate `iwctl`.

## Configuration

Configuration options and examples are described below. Consult the relevant
manual pages and the [upstream
documentation](https://iwd.wiki.kernel.org/networkconfigurationsettings) for
further information.

### Daemon configuration

The main configuration file is located in `/etc/iwd/main.conf`. If it does not
exist, you may create it. It is documented in `iwd.config(5)`.

### Network configuration

Network configuration, including examples, is documented in `iwd.network(5)`.
IWD stores information on known networks, and reads information on
pre-provisioned networks from network configuration files located in
`/var/lib/iwd`; IWD monitors the directory for changes. Network configuration
filenames consist of the encoding of the SSID followed by `.open`, `.psk`, or
`.8021x` as determined by the security type.

As an example, a basic configuration file for a WPA2/PSK secured network would
be called `<ssid>.psk`, and it would contain the plain text password:

```
[Security]
Passphrase=<password>
```

## Troubleshooting

By default, IWD will create and destroy the wireless interfaces (e.g. `wlan0`)
that it manages. This can interfere with `udevd`, which may attempt to rename
the interface using its rules for persistent network interface names. The
following messages may be printed to your screen as a symptom of this
interference:

```
[   39.441723] udevd[1100]: Error changing net interface name wlan0 to wlp59s0: Device or resource busy
[   39.442472] udevd[1100]: could not rename interface '3' from 'wlan0' to 'wlp59s0': Device or resource busy
```

A simple fix is to prevent IWD from manipulating the network interfaces in this
way by adding `UseDefaultInterface=true` to the `[General]` section of
`/etc/iwd/main.conf`.

An alternative approach is to disable the use of persistent network interface
names by `udevd`. This may be accomplished either by adding `net.ifnames=0` to
your kernel [cmdline](../kernel.md#cmdline) or by creating a symbolic link to
`/dev/null` at `/etc/udev/rules.d/80-net-name-slot.rules` to mask the renaming
rule. This alternative approach will affect the naming of all network devices.
