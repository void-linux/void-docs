# wpa_supplicant

The `wpa_supplicant` package is installed by default on the base system and
includes utilities to configure wireless interfaces and, more specifically, to
handle wireless security protocols.

[wpa_supplicant(8)](https://man.voidlinux.org/wpa_supplicant.8) is a daemon that
manages wireless interfaces based on
[wpa_supplicant.conf(5)](https://man.voidlinux.org/wpa_supplicant.conf.5)
configuration files.
[wpa_passphrase(8)](https://man.voidlinux.org/wpa_passphrase.8) and
[wpa_cli(8)](https://man.voidlinux.org/wpa_cli.8) are frontends to manage the
configuration files and the running service.

## WEP configuration

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

## WPA-PSK encryption

For `WPA-PSK` encryption, we must generate a `pre shared key` with
[wpa_passphrase(8)](https://man.voidlinux.org/wpa_passphrase.8). To do so, run
the following command:

```
$ wpa_passphrase <MYSSID> <key>
```

You must append the output to your `wpa_supplicant.conf` file like so:

```
# wpa_passphrase <MYSSID> <key> >> /etc/wpa_supplicant/wpa_supplicant-<device_name>.conf
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

### Running wpa_supplicant under runit

The runit scripts checks the following options in `/etc/sv/wpa_supplicant/conf`.

- `OPTS`: Options to be passed to the service. (Overrides any other options!)
- `CONF_FILE`: Path to file to be used for configuration.
- `WPA_INTERFACE`: Interface to be matched (May contain a wildcard; Defaults to
   all interfaces.)

If no `conf` file is found, the service searches for the following files in
`/etc/wpa_supplicant`:

- `wpa_supplicant-<interface>.conf`: if found, these files are bound to the
   named interface.
- `wpa_supplicant.conf`: if found, this file is loaded and binds to all other
   interfaces found.

To enable the [wpa_supplicant(8)](https://man.voidlinux.org/wpa_supplicant.8)
service.

```
# ln -s /etc/sv/wpa_supplicant /var/service/
```

### Using wpa_cli

When using `wpa_cli` to manage `wpa_supplicant` from the command line, be sure
to specify which network interface to use via the `-i` option, e.g.:

```
# wpa_cli -i wlp2s0
```

Not doing so can result in various `wpa_cli` commands (for example, `scan` and
`scan_results`) not producing the expected output.
