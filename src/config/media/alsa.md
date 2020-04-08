# ALSA

To use ALSA, install the `alsa-utils` package and make sure your user is a
member of the `audio` group.

The `alsa-utils` package provides the `alsa` service. When enabled, this service
saves and restores the state of ALSA (e.g. volume) at shutdown and boot,
respectively.

## Configuration

The default soundcard can be specified via ALSA configuration files or via
kernel module options.

To obtain information about the order of loaded soundcard modules:

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

or specify soundcard module order in `/etc/modprobe.d/alsa.conf`:

```
options snd_usb_audio index=0
```
