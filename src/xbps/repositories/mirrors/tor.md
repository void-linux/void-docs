# Using Tor Mirrors

Tor is an anonymizing software that bounces traffic via computers all around the
world. It can provide access to regular sites on the internet or to hidden sites
only available on the network.

The following Void Linux Mirrors are available on the Tor Network:

| Repository                                                                             | Location   |
|----------------------------------------------------------------------------------------|------------|
| <http://lysator7eknrfl47rlyxvgeamrv7ucefgrrlhk7rouv3sna25asetwid.onion/pub/voidlinux/> | EU: Sweden |

## Using XBPS with Tor

XBPS can be made to connect to mirrors using Tor. These mirrors can be normal
mirrors, via exit relays, or, for potentially greater anonymity, hidden service
mirrors on the network.

XBPS respects the `SOCKS_PROXY` environment variable, which makes it easy to use
via Tor.

### Installing Tor

Tor is contained in the `tor` package.

After having installed Tor, you can start it as your own user:

```
$ tor
```

or enable its system service.

By default, Tor will act as a client and open a SOCKS5 proxy on TCP port 9050 on
localhost.

### Making XBPS connect via the SOCKS proxy

XBPS reads the `SOCKS_PROXY` environment variable and will use any proxy
specified in it. By simply setting the variable to the address and port of the
proxy opened by the Tor client, all XBPS's connections will go over the Tor
network.

An example upgrading your system over Tor:

```
# export SOCKS_PROXY="socks5://127.0.0.1:9050"
# xbps-install -Su
```

### Using a hidden service mirror

To use a hidden service mirror, the default mirrors need to be overwritten with
configuration files pointing to `.onion`-addresses that are used internally on
the Tor network. XBPS allows overriding repository addresses under
`/etc/xbps.d`.

Copy your repository files from `/usr/share/xbps.d` to `/etc/xbps.d` and replace
the addresses with that of an onion service (Lysator's onion used as an
example):

```
# mkdir -p /etc/xbps.d
# cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d/
# sed -i 's|https://repo-default.voidlinux.org|http://lysator7eknrfl47rlyxvgeamrv7ucefgrrlhk7rouv3sna25asetwid.onion/pub/voidlinux|g' /etc/xbps.d/*-repository-*.conf
```

Tor provides layered end-to-end encryption so HTTPS is not necessary.

When installing packages, with `SOCKS_PROXY` set like the earlier example, XBPS
should indicate that it is synchronizing the repositories from the onion address
specified in the override:

```
# xbps-install -S
[*] Updating `http://lysator7eknrfl47rlyxvgeamrv7ucefgrrlhk7rouv3sna25asetwid.onion/pub/voidlinux/current/aarch64/nonfree/aarch64-repodata' ...
aarch64-repodata: 4030B [avg rate: 54KB/s]
[*] Updating `http://lysator7eknrfl47rlyxvgeamrv7ucefgrrlhk7rouv3sna25asetwid.onion/pub/voidlinux/current/aarch64/aarch64-repodata' ...
aarch64-repodata: 1441KB [avg rate: 773KB/s]
```

### Security consideration

It is advisable to set `SOCKS_PROXY` automatically in your environment if you
are using an onion. If the setting is missing, a DNS query for the name of the
hidden service will leak to the configured DNS server.

To automatically set the environment variable, add it to a file in
`/etc/profile.d`:

```
# cat - <<EOF > /etc/profile.d/socksproxy.sh
#!/bin/sh
export SOCKS_PROXY="socks5://127.0.0.1:9050"
EOF
```
