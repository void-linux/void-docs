# PipeWire

To use PipeWire, install the `pipewire` package.

[pipewire(1)](https://man.voidlinux.org/pipewire.1) should be started as a user.
Run the pipewire command in a terminal emulator in your session.

```
$ pipewire
```

When pipewire works as expected, use the autostarting mechanism of your desktop
environment or [startx](../graphical-session/xorg.md#startx). The `pipewire`
package provides `pipewire` and `pipewire-pulse` system services, but they are
not recommended for a typical setup.

The `pipewire` package ships [Desktop
Entry](https://specifications.freedesktop.org/desktop-entry-spec/latest/) files
for `pipewire` and `pipewire-pulse` in `/usr/share/applications`. If your
environment supports the [Desktop Application Autostart
Specification](https://specifications.freedesktop.org/autostart-spec/autostart-spec-latest.html),
you can enable pipewire by symlinking the desktop files to the autostart
directory:

```
# ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
```

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

Once you confirmed that `pipewire-pulse` works as expected, it's recommended to
autostart it from the same place where you start PipeWire. It is possible to
modify [pipewire.conf(5)](https://man.voidlinux.org/pipewire.conf.5) for
auto-starting the PulseAudio server, but it's not recommended keep the PipeWire
configuration file unmodified for smoother future upgrades.

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
