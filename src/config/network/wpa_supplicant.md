# wpa_supplicant

The `wpa_supplicant` package is installed by default on the base system and
includes utilities to configure wireless interfaces and, more specifically, to
handle wireless security protocols.

[wpa_supplicant(8)](https://man.voidlinux.org/wpa_supplicant.8) is a daemon that
manages wireless interfaces based on a
[wpa_supplicant.conf(5)](https://man.voidlinux.org/wpa_supplicant.conf.5)
configuration files.
[wpa_passphrase(8)](https://man.voidlinux.org/wpa_passphrase.8) and
[wpa_cli(8)](https://man.voidlinux.org/wpa_cli.8) are frontends to manage the
configuration files and the running service.

## Configuring wpa_supplicant

First, you must create a configuration file for your interface:

```
$ cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-<device>.conf
```

### WEP configuration

For WEP configuration, you can just add the following lines to your device's
`wpa-supplicant.conf` :

```
# Default configuration file for wpa_supplicant.conf(5).

ctrl_interface=/run/wpa_supplicant
ctrl_interface_group=wheel
eapol_version=1
ap_scan=1
fast_reauth=1
update_config=1

# Add here your networks.
network={
    ssid="MYSSID"
    key_mgmt=NONE
    wep_key0="YOUR AP WEP KEY"
    wep_tx_keyidx=0
    auth_alg=SHARED
}
```

### WPA-PSK encryption

For `WPA-PSK` encryption, we must generate a `pre shared key` with
[wpa_passphrase(8)](https://man.voidlinux.org/wpa_passphrase.8). To do so, run
the following command:

```
$ wpa_passphrase <MYSSID> <key>
```

You must append the output to your `wpa_supplicant.conf` file like so:

```
$ wpa_passphrase <MYSSID> <key> >> /etc/wpa_supplicant/wpa_supplicant-<device_name>.conf
```

The resulting file should look something like this:

```
# Default configuration file for wpa_supplicant.conf(5).

ctrl_interface=/run/wpa_supplicant
ctrl_interface_group=wheel
eapol_version=1
ap_scan=1
fast_reauth=1
update_config=1

# Add your networks here.
network={
    ssid="MYSSID"
    #psk="YOUR AP KEY"
    psk=a8c34100ab4e5afac33cad7184d45a29ee0079001577d579bec6b74e4d7b5ac8
}
```

## Running wpa_supplicant

There are two options for running
[wpa_supplicant.conf(5)](https://man.voidlinux.org/wpa_supplicant.conf.5). You
may simply run [dhcpcd(8)](https://man.voidlinux.org/dhcpcd.8), which will start
processes automatically for your wireless interfaces, or you can run
`wpa_supplicant` manually.

### Starting through dhcpcd hooks

You may run [dhcpcd(8)](https://man.voidlinux.org/dhcpcd.8), which has hooks to
start [wpa_supplicant(8)](https://man.voidlinux.org/wpa_supplicant.8)
automatically.

> See [dhcpcd](./dhcpcd.md) for more information on starting/configuring dhcpcd.

### Running wpa_supplicant manually

You may start
[wpa_supplicant.conf(5)](https://man.voidlinux.org/wpa_supplicant.conf.5)
manually, if you are not already running
[dhcpcd(8)](https://man.voidlinux.org/dhcpcd.8) :

```
# wpa_supplicant -B -i <interface_name> -c <path/to/configuration/file>
# dhcpcd <interface_name>
```

Now you can test the connection:

```
$ ping google.com
```
