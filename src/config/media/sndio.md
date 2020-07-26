# sndio

Install the `sndio` package and enable the
[sndiod(8)](https://man.voidlinux.org/sndiod.8) service.

## Configuration

The service can be configured by adding
[sndiod(8)](https://man.voidlinux.org/sndiod.8) flags to the `OPTS` variable in
the service configuration file (`/etc/sv/sndiod/conf`).

### Default device

[sndiod(8)](https://man.voidlinux.org/sndiod.8) uses the first ALSA device by
default. To use another ALSA device for sndio's default device `snd/0` add the
flags to use specific devices to the service configuration file.

```
# echo 'OPTS="-f rsnd/Speaker"' >/etc/sv/sndiod/conf
```

Use the `-f` flag to chooses a device by its ALSA device index or its ALSA
device name.

## Volume control

The master and per application volume controls are controlled with MIDI messages
by hardware or software.

[aucatctl(1)](https://man.voidlinux.org/aucatctl.1) is a tool specific to sndio
to send MIDI control messages to the
[sndiod(8)](https://man.voidlinux.org/sndiod.8) daemon. It can be found in the
`aucatctl` package.

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

MPV comes with sndio support, but to prevent it from using ALSA over sndio if
the ALSA device is available, set the `--ao=sndio` command line option. You can
also add the option to mpv's configuration file: `~/.config/mpv/mpv.conf` should
contain a line specifying `ao=sndio`.

### OpenAL

libopenal comes with sndio support, but prioritizes ALSA over sndio by default.
You can configure this behavior per user in `~/.alsoftrc` or system wide in
`/etc/openal/alsoft.conf` by adding the following lines:

```
[general]
drivers = sndio
```

### ALSA

Applications that only have an ALSA backend can still use sndio with the
`alsa-sndio` package. It contains an ALSA plugin that provides a pcm that
connects to a `sndiod` server, and currently only supports playback. In order to
enable the pcm, add the lines below to your [ALSA configuration
file](./alsa.md#configuration):

```
pcm.!default {
	type sndio
}
```
