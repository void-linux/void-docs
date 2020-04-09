# sndio

Install the `sndio` package and enable the
[sndiod(8)](https://man.voidlinux.org/sndiod.8) service.

```
# xbps-install -S sndio
# ln -s /etc/sv/sndiod /var/service/
```

## Configuration

The service can be configured by adding
[sndiod(8)](https://man.voidlinux.org/sndiod.8) flags to the `OPTS` variable in
the service configuration file (`/etc/sv/sndiod/conf`).

### Default device

[sndiod(8)](https://man.voidlinux.org/sndiod.8) uses the first alsa device by
default. To use another alsa device for sndio's default device `snd/0` add the
flags to use specific devices to the service configuration file.

```
# echo 'OPTS="-f rsnd/Speaker"' >/etc/sv/sndiod/conf
```

Use the `-f` flag to chooses a device by its alsa device index or its alsa
device name.

## Volume control

The master and per application volume controls are controlled with MIDI messages
by hardware or software.

[aucatctl(1)](https://man.voidlinux.org/aucatctl.1) is a tool specific to sndio
to send MIDI control messages to the
[sndiod(8)](https://man.voidlinux.org/sndiod.8) daemon.

```
# xbps-install -S aucatctl
```

## Application specific configurations

### Firefox

Firefox is built with sndio support and should work out of the box since version
71 if libsndio is installed and the `snd/0` device is available.

The following `about:config` changes are required for versions prior to 71 and
should be removed when using version 71 or later:

```
media.cubeb.backend;sndio
media.cubeb.sandbox;false
security.sandbox.content.read_path_whitelist;/home/<username>/.sndio/cookie
security.sandbox.content.write_path_whitelist;/home/<username>/.sndio/cookie
```

### mpv

Mpv comes with sndio support, but to avoid it from using alsa over sndio if the
device is available set the `--ao=sndio` command line option or add the option
to mpv's configuration file.

```
$ echo 'ao=sndio' >> ~/.config/mpv/mpv.conf
```
