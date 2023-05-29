# PipeWire

To use PipeWire, install the `pipewire` package.

[pipewire(1)](https://man.voidlinux.org/pipewire.1) should be started as a user.
Run the pipewire command in a terminal emulator in your session.

```
$ pipewire
```

When pipewire works as expected, use the autostarting mechanism of your desktop
environment or [startx](../graphical-session/xorg.md#startx). The `pipewire`
package ships [Desktop
Entry](https://specifications.freedesktop.org/desktop-entry-spec/latest/) files
for `pipewire` and `pipewire-pulse` in `/usr/share/applications`. If your
environment supports the [Desktop Application Autostart
Specification](https://specifications.freedesktop.org/autostart-spec/autostart-spec-latest.html),
you can enable pipewire by symlinking the desktop files to the autostart
directory:

```
# ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
```

## Session Management

In PipeWire, a session manager assumes responsibility for interconnecting media
sources and sinks as well as enforcing routing policy. Without a session
manager, PipeWire will not function. The reference
[`pipewire-media-session`](https://gitlab.freedesktop.org/pipewire/media-session)
was originally provided in the Void `pipewire` package and configured to run by
default to satisfy this requirement. However, `pipewire-media-session` is
deprecated and the authors recommend using
[WirePlumber](https://pipewire.pages.freedesktop.org/wireplumber/) in its place.
Install the `wireplumber` package to use this session manager with PipeWire.

> If you have installed an earlier version of the Void `pipewire` package, make
> sure to update your system to eliminate any stale system configuration that
> may attempt to launch `pipewire-media-session`. Users who previously overrode
> the system configuration to use `wireplumber`, *e.g.* by placing a custom
> `pipewire.conf` file in `/etc/pipewire` or `${XDG_CONFIG_HOME}/pipewire`, may
> wish to reconcile these overrides with `/usr/share/pipewire/pipewire.conf`
> installed by the most recent `pipewire` package. If the sole purpose of a
> prior override was to disable `pipewire-media-session`, deleting the custom
> configuration may be sufficient.

There are several methods for starting `wireplumber` alongside `pipewire`. If
your window manager or desktop environment auto-start mechanism is used to start
`pipewire`, it is recommended to use the same mechanism for starting
`wireplumber`. The `wireplumber` package includes a `wireplumber.desktop`
Desktop Entry file that may be useful in this situation.

> Be aware that `wireplumber` must launch *after* the `pipewire` executable. The
> Desktop Application Autostart Specification makes no provision for ordering of
> services started via Desktop Entry files. When relying on these files to
> launch `pipewire` and `wireplumber`, consult the documentation for your window
> manager or desktop environment to determine whether proper ordering of
> services can be achieved.

If proper ordering of separate `pipewire` and `wireplumber` services is
infeasible, it is possible to configure `pipewire` to launch the session manager
directly. This can be accomplished by running

```
# mkdir -p /etc/pipewire/pipewire.conf.d
# ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
```

for system configurations or, for per-user configurations, running

```
$ true "${XDG_CONFIG_HOME:=${HOME}/.config}"
$ mkdir -p "${XDG_CONFIG_HOME}/pipewire/pipewire.conf.d"
# ln -s /usr/share/examples/wireplumber/10-wireplumber.conf "${XDG_CONFIG_HOME}/pipewire/pipewire.conf.d/"
```

With either of these configurations, launching `pipewire` should be sufficient
to establish a working PipeWire session that uses `wireplumber` for session
management.

In its default configuration, WirePlumber requires an active [D-Bus
session](../session-management.md#d-bus). If your desktop environment or window
manager is configured to provide a D-Bus session as well as launch `pipewire`
and `wireplumber`, no further configuration should be required. Users wishing to
launch `pipewire` on its own, *e.g.*, in a `.xinitrc` script, may find it
necessary to configure `pipewire` to launch `wireplumber` directly and wrap the
`pipewire` invocation as

```
dbus-run-session pipewire
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
autostart it from the same place where you start PipeWire. Alternatively, the
`pipewire` configuration can be modified to launch `pipewire-pulse` directly:

```
# mkdir -p /etc/pipewire/pipewire.conf.d
# ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
```

for system configurations, or

```
$ true "${XDG_CONFIG_HOME:=${HOME}/.config}"
$ mkdir -p "${XDG_CONFIG_HOME}/pipewire/pipewire.conf.d"
# ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf "${XDG_CONFIG_HOME}/pipewire/pipewire.conf.d/"
```

for per-user configurations.

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

The PulseAudio replacement requires the
[`XDG_RUNTIME_DIR`](../session-management.html#xdg_runtime_dir) environment
variable to work correctly.
