# ALSA

Install the `alsa-utils` package make sure your user is part of the `audio`
group to access audio devices.

```
# xbps-install -S alsa-utils
# usermod -a -G audio <username>
```

The `alsa-utils` package comes with the system service `/etc/sv/alsa` which can
be activated to save and restore the state of alsa controls like the volume at
shutdown and boot respectively.

If the soundcard you want to use is not the default you can either use kernel
module options or the alsa config to change the default card.

The current module order can be retrieved from the procfs filesystem.

```
$ cat /proc/asound/modules
 0 snd_hda_intel
 1 snd_hda_intel
 2 snd_usb_audio
```

To use the kernel module options you can create a file like
`/etc/modprobe.d/alsa.conf` with following content.

```
options snd_usb_audio index=0
```

Alternatively using the alsa configuration file `/etc/asound.conf` or the
per-user configuration file `~/.asoundrc` to set a different card as the
default.

```
defaults.ctl.card 2;
defaults.pcm.card 2;
```
## Apulse
The `apulse` package is a compatibility layer that allows ALSA to play
sound in applications that require pulseaudio using ALSA only. Install 
the apulse package by running the command below.
```
# xbps-install -S apulse
```
Once installed you can use the apulse wrapper script with this command.
```
$ apulse <program-name>
```
Environment variables such as `APULSE_CAPTURE_DEVICE` and `APULSE_PLAYBACK_DEVICE` can be used to set which capture and playback device you want apulse to use.
```
APULSE_CAPTURE_DEVICE=default APULSE_PLAYBACK_DEVICE=default apulse firefox
```
The above example would run firefox with apulse using the default alsa capture and playback devices.
