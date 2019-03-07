# IWD

[IWD](https://iwd.wiki.kernel.org/) (iNet Wireless Daemon) is a wireless daemon
for Linux that aims to replace [WPA supplicant](./wpa_supplicant.md).

## Installation

Install the `iwd` package.

```
# xbps-install -S iwd
```

Enable the `dbus` and `iwd` services.

```
# ln -s /etc/sv/dbus /var/service
# ln -s /etc/sv/iwd /var/service
```

> Note: To use EAP-TLS, EAP-TTLS, and EAP-PEAP based configurations, version
> ≥4.20 of the kernel is required. Previous kernel versions do not include the
> necessary cryptographic authentication modules.

## Usage

IWD provides a command line client, `iwctl`. It can be used to add, remove, and
configure network connections; running it produces an interactive prompt. To
list available options, enter `help`.

```
$ iwctl

[iwd]# help
                               Available commands
--------------------------------------------------------------------------------
  Commands                                          Description
--------------------------------------------------------------------------------

Adapters:
  adapter list                                      List adapters
  adapter <phy> show                                Show adapter info
  adapter <phy> set-property <name> <value>         Set property
...
```

> Note: By default, only the root user and those in the `wheel` group have
> permission to operate `iwctl`.

Some useful commands:

```
[iwd]# device list                                       # List all Wi-Fi devices
[iwd]# device <interface> show                           # Display details of a Wi-Fi device 
[iwd]# station <interface> scan                          # Scan for networks
[iwd]# station <interface> get-networks                  # List networks
[iwd]# station <interface> connect <network-name>        # Connect to a network
[iwd]# station <interface> connect-hidden <network-name> # Connect to a hidden network
[iwd]# station <interface> disconnect                    # Disconnect from a network
[iwd]# known-networks list                               # List known networks
[iwd]# known-networks forget <network-name>              # Forget a known network
```

> Note: `iwctl` also supports passing commands as arguments.
> 
> ```
> $ iwctl station <interface> get-networks
> ```

## Configuration

Consult the [upstream
documentation](https://iwd.wiki.kernel.org/networkconfigurationsettings) for
options and examples available to configure the daemon and networks as described
below.

### Daemon configuration

The main configuration file is located in `/etc/iwd/main.conf`. If it does not
exist, you may create it.

### Network configuration

IWD stores information on known networks, and reads information on
pre-provisioned networks from network configuration files located in
`/var/lib/iwd`; IWD monitors the directory for changes. Network configuration
filenames consist of the encoding of the SSID followed by `.open`, `.psk`, or
`.8021x` as determined by the security type.

A simple example of a WPA2/PSK secured network configuration at
`/var/lib/iwd/<ssid>.psk` contains the pre-shared key, and optionally the
plaintext password.

```
[Security]
PreSharedKey=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Passphrase=<password>
```
