# Enabling wpa_supplicant

The `wpa_supplicant` package is installed by default on the base system. It
includes utilities to configure wireless interfaces and handle wireless security
protocols. To use wpa_supplicant, you will need to enable [the wpa_supplicant
service](#the-wpa_supplicant-service). 

`ln -s /etc/sv/wpa_supplicant /var/service`

The wireless service will be automatically started once soft link is done.

Then you need to run `rfkill` to make sure your radio device is not blocked.

Run `rfkill unblock id|type` if it is shown blocked.

# Using wpa_cli

`wpa_cli` is a tool comes with base system. You can use `wpa_cli` to manage `wpa_supplicant` from the command line, be sure
to specify which network interface to use via the `-i` option. Not doing so can result in various `wpa_cli` commands (for example, `scan` and
`scan_results`) not producing the expected output.

Sample Setup Commands:
```
# wpa_cli -i wlp2s0
(wpa)$ add_network 0
(wpa)$ set_network 0 ssid "wifi_name"
(wpa)$ set_network 0 password abc123
(wpa)$ enable_entwork 0
(wpa)$ quit
```

# More on wpa_supplicant

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

## WPA-EAP

WPA-EAP is often used for institutional logins, notably eduroam. This does not
use PSK, but a password hash can be generated like this:

```
$ echo -n <passphrase> | iconv -t utf16le | openssl md4
```

## WEP

For WEP configuration, add the following lines to your device's
`wpa-supplicant.conf`:

```
network={
    ssid="MYSSID"
    key_mgmt=NONE
    wep_key0="YOUR AP WEP KEY"
    wep_tx_keyidx=0
    auth_alg=SHARED
}
```

### The wpa_supplicant service

The `wpa_supplicant` service checks the following options in
`/etc/sv/wpa_supplicant/conf`:

- `OPTS`: Options to be passed to the service. Overrides any other options.
- `CONF_FILE`: Path to file to be used for configuration. Defaults to
   `/etc/wpa_supplicant/wpa_supplicant.conf`.
- `WPA_INTERFACE`: Interface to be matched. May contain a wildcard; defaults to
   all interfaces.
- `DRIVER`: Driver to use. See `wpa_supplicant -h` for available drivers.

If no `conf` file is found, the service searches for the following files in
`/etc/wpa_supplicant`:

- `wpa_supplicant-<interface>.conf`: If found, these files are bound to the
   named interface.
- `wpa_supplicant.conf`: If found, this file is loaded and binds to all other
   interfaces found.

Once you are satisfied with your configuration,
[enable](../services/index.md#enabling-services) the `wpa_supplicant` service.



