# PipeWire

To use PipeWire, install the `pipewire` package.

[pipewire(1)](https://man.voidlinux.org/pipewire.1) should be started as a user.
Run the pipewire command in a terminal emulator in your session.

```
$ pipewire
```

When pipewire works as expected, use the autostarting mechanism of your desktop
environment or [startx](../graphical-session/xorg.md#startx).

The `pipewire` package ships [Desktop
Entry](https://specifications.freedesktop.org/desktop-entry-spec/latest/) files
for `pipewire` and `pipewire-pulse` in `/usr/share/applications`. If your
environment supports the [Desktop Application Autostart
Specification](https://specifications.freedesktop.org/autostart-spec/autostart-spec-latest.html),
we recommend enabling pipewire by symlinking the desktop files to the autostart
directory:

```
# ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
```

*Warning*: the `pipewire` package provides `pipewire` and `pipewire-pulse`
system services, but they are experimental and we discourage their use except in
rare cases.

## PulseAudio replacement

Before starting `pipewire-pulse`, make sure that the PulseAudio service is
[disabled](../services/index.md#disabling-services) and that no other PulseAudio
server instance is running.

Start the PulseAudio server by running `pipewire-pulse` in a terminal emulator.

To check if the replacement is working correctly, use
[pactl(1)](https://man.voidlinux.org/pactl.1) (provided by the
`pulseaudio-utils` package):

```
$ pactl info

[...]
Server Name: PulseAudio (on PipeWire 0.3.18)
[...]
```

Once you confirmed that `pipewire-pulse` works as expected, we recommend to
autostart it via a PipeWire configuration drop-in:

```
context.exec = [
    { path = "/usr/bin/pipewire" args = "-c pipewire-pulse.conf" }
]
```

Place the above content in a file at either path:

- for per-user configuration (recommended):
   `~/.config/pipewire/pipewire.conf.d/10-exec-pipewire-pulse.conf`
- for system-wide configuration:
   `/etc/pipewire/pipewire.conf.d/10-exec-pipewire-pulse.conf`

See [pipewire.conf(5)](https://man.voidlinux.org/pipewire.conf.5) and
`/usr/share/pipewire/pipewire.conf` for further details.

Alternatively, you may use the Desktop Application Autostart mechanism:

```
# ln -s /usr/share/applications/pipewire-pulse.desktop /etc/xdg/autostart/pipewire-pulse.desktop
```

## Media session

PipeWire is not useful without a session manager.

We recommend using WirePlumber as your session manager, however advanced users
may find utility in the "example PipeWire session manager", media-session.

### WirePlumber

To use WirePlumber, install the `wireplumber` package.

Then, use a PipeWire configuration drop-in to autostart the daemon:

```
context.exec = {
    { path = "/usr/bin/wireplumber" args = "" }
}
```

Place the above content in a file at either path:

- for per-user configuration (recommended):
   `~/.config/pipewire/pipewire.conf.d/10-exec-wireplumber.conf`
- for system-wide configuration:
   `/etc/pipewire/pipewire.conf.d/10-exec-wireplumber.conf`

See [pipewire.conf(5)](https://man.voidlinux.org/pipewire.conf.5) and
`/usr/share/pipewire/pipewire.conf` for further details.

Alternatively, you may use the Desktop Application Autostart mechanism:

```
# ln -s /usr/share/applications/wireplumber.desktop /etc/xdg/autostart/wireplumber.desktop
```

*Warning*: the `wireplumber` package provides a `wireplumber` system service,
but it is experimental and we discourage its use except for rare cases.

### Example PipeWire session manager

The PipeWire developers publish a PipeWire Media Session program that they
describe as an "example session manager".

The PipeWire developers recommend using WirePlumber instead of this program.

Nevertheless, the example session manager may still be useful to some users
(perhaps those who encounter bugs in WirePlumber).

To use this session manager, install the `pipewire-media-session` package, then
configure the daemon to autostart.

You can use the same autostart mechanisms as `wireplumber`, but use
`/usr/bin/pipewire-media-session` as the daemon path or
`pipewire-media-session.desktop` as the Desktop Application file name.

## Bluetooth audio

For bluetooth audio to work, install the `libspa-bluetooth` package.

## ALSA integration

Install `alsa-pipewire`, then enable the PipeWire ALSA device and make it the
default:

```
# mkdir -p /etc/alsa/conf.d
# ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
# ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
```

## JACK replacement

Install `libjack-pipewire`.

Use [pw-jack(1)](https://man.voidlinux.org/pw-jack.1) to launch JACK clients
manually:

```
$ pw-jack <application>
```

Alternatively, override the library provided by `libjack` (see
[ld.so(8)](https://man.voidlinux.org/ld.so.8)). The following approach will work
on glibc-based systems:

```
# echo "/usr/lib/pipewire-0.3/jack" > /etc/ld.so.conf.d/pipewire-jack.conf
# ldconfig
```

## Troubleshooting

The Pulseaudio replacement requires the
[`XDG_RUNTIME_DIR`](../session-management.html#xdg_runtime_dir) environment
variable to work correctly.
