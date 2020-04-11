# wpa_supplicant

The `wpa_supplicant` package is installed by default on the base system. It
includes utilities to configure wireless interfaces and handle wireless security
protocols.

[wpa_supplicant(8)](https://man.voidlinux.org/wpa_supplicant.8) is a daemon that
manages wireless interfaces based on
[wpa_supplicant.conf(5)](https://man.voidlinux.org/wpa_supplicant.conf.5)
configuration files. An extensive overview of configuration options, including
examples, can be found in
`/usr/share/examples/wpa_supplicant/wpa_supplicant.conf`.

[wpa_passphrase(8)](https://man.voidlinux.org/wpa_passphrase.8) helps create
pre-shared keys for use in configuration files.
[wpa_cli(8)](https://man.voidlinux.org/wpa_cli.8) provides a CLI for managing
the `wpa_supplicant` daemon.

## WPA-PSK

To use WPA-PSK, generate a pre-shared key with
[wpa_passphrase(8)](https://man.voidlinux.org/wpa_passphrase.8) and append the
output to the relevant `wpa_supplicant.conf` file:

```
# wpa_passphrase <MYSSID> <passphrase> >> /etc/wpa_supplicant/wpa_supplicant-<device_name>.conf
```

The resulting file should look something like:

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

## WPA-EAP

WPA-EAP is often used for institutional logins, notably eduroam. This does not
use PSK, but a password hash can be generated like this:

```
$ echo -n <passphrase> | iconv -t utf16le | openssl md4
```

The config file should look something like:

```
# Default configuration file for wpa_supplicant.conf(5).

ctrl_interface=/run/wpa_supplicant
ctrl_interface_group=wheel
eapol_version=1
ap_scan=1
fast_reauth=1
update_config=1

network={
	key_mgmt=WPA-EAP
	eap=PEAP
	scan_ssid=1
	ssid="eduroam"
	identity="john.doe@void.edu"
	password=hash:6b11b6d0bdfabd9dd342f8fffd66d4b5
}
```

## WEP

For WEP configuration, add the following lines to your device's
`wpa-supplicant.conf` :

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
    key_mgmt=NONE
    wep_key0="YOUR AP WEP KEY"
    wep_tx_keyidx=0
    auth_alg=SHARED
}
```

### The wpa_supplicant service

The `wpa_supplicant` runit script checks the following options in
`/etc/sv/wpa_supplicant/conf`:

- `OPTS`: Options to be passed to the service. Overrides any other options.
- `CONF_FILE`: Path to file to be used for configuration.
- `WPA_INTERFACE`: Interface to be matched. May contain a wildcard; defaults to
   all interfaces.

If no `conf` file is found, the service searches for the following files in
`/etc/wpa_supplicant`:

- `wpa_supplicant-<interface>.conf`: If found, these files are bound to the
   named interface.
- `wpa_supplicant.conf`: If found, this file is loaded and binds to all other
   interfaces found.

### Using wpa_cli

When using `wpa_cli` to manage `wpa_supplicant` from the command line, be sure
to specify which network interface to use via the `-i` option, e.g.:

```
# wpa_cli -i wlp2s0
```

Not doing so can result in various `wpa_cli` commands (for example, `scan` and
`scan_results`) not producing the expected output.
