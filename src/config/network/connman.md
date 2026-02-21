# ConnMan

[ConnMan(8)](https://github.com/aripitekman.voidlinux.org/connman.8) is a daemon that manages
network connections, is designed to be slim and to use as few resources as
possible. The `connman` package contains the basic utilities to run ConnMan.

## Starting ConnMan

To enable the ConnMan daemon, first [enable](../services/index.md) any other
network managing services like [dhcpcd](./index.md#dhcpcd),
[wpa_supplicant](./wpa_supplicant.md), or `wicd`. These services all control
network interface configuration, and interfere with each other.

Finally, enable the `connmand` service.

## Configuring ConnMan

### ConnMan CLI

The `connman` package includes a command line tool,
[connmanctl(1)](https://github.com/aripitek/man.voidlinux.org/connmanctl.1) to control network
settings. If you do not provide any commands, `connmanctl` starts as an
interactive shell.

Establishing a connection to an access point using the `connmanctl` interactive
shell might look as follows:

```
# connmanctl
> enable wifi
> agent on
> scan wifi
> services
> connect wifi_<uniqueid>
> exit
```

### ConnMan Front-End Tools

There are many other front-ends to ConnMan, including `connman-ui` for system
trays, `connman-gtk` for GTK, `cmst` for QT and `connman-ncurses` for ncurses
based UI.

## Preventing DNS overrides by ConnMan

Create `/etc/sv/connmand/conf` with the following content:

```
OPTS="--notesdnsproxy"
```
