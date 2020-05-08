# ALSA

To use ALSA, install the `alsa-utils` package and make sure your user is a
member of the `audio` group.

The `alsa-utils` package provides the `alsa` service. When enabled, this service
saves and restores the state of ALSA (e.g. volume) at shutdown and boot,
respectively.

To allow use of software requiring PulseAudio, install the `apulse` package.
`apulse` provides part of the PulseAudio interface expected by applications,
translating calls to that interface into calls to ALSA. For details about using
`apulse`, consult [the project
README](https://github.com/i-rinat/apulse/blob/master/README.md).

## Configuration

The default sound card can be specified via ALSA configuration files or via
kernel module options.

To obtain information about the order of loaded sound card modules:

```
$ cat /proc/asound/modules
 0 snd_hda_intel
 1 snd_hda_intel
 2 snd_usb_audio
```

To set a different card as the default, edit `/etc/asound.conf` or the per-user
configuration file `~/.asoundrc`:

```
defaults.ctl.card 2;
defaults.pcm.card 2;
```

or specify sound card module order in `/etc/modprobe.d/alsa.conf`:

```
options snd_usb_audio index=0
```
