# PipeWire

PipeWire is a modern server for handling audio (and video) streams. It is highly
flexible and can interface with applications designed for ALSA, PulseAudio, and
JACK audio systems. It is also designed to work well with Flatpak applications
and provides a method for screenshotting and screensharing on Wayland via
[xdg-desktop-portal](../graphical-session/portals.md).

## Prerequisites

PipeWire requires an active [D-Bus user session
bus](../session-management.md#d-bus). If your desktop environment, window
manager, or Wayland compositor is configured to provide this, no further
configuration should be required. If not, the desktop environment, window
manager, or Wayland compositor may need to be launched with
[`dbus-run-session(1)`](https://man.voidlinux.org/dbus-run-session.1) or a [dbus
user-service](../services/user-services.md#d-bus-session) should be setup.

PipeWire also requires the
[`XDG_RUNTIME_DIR`](../session-management.html#xdg_runtime_dir) environment
variable to be defined in your environment to work properly.

If not using [elogind](../session-management.md), it is necessary to be in the
`audio` group to access audio devices and the `video` group to access video
devices.

## Basic Setup

To use PipeWire, install the `pipewire` package. This will also install a
PipeWire session manager, `wireplumber`.

### Session Management

In PipeWire, a session manager assumes responsibility for interconnecting media
sources and sinks as well as enforcing routing policy. Without a session
manager, PipeWire will not function.

> If you have installed an earlier version of the Void `pipewire` package, make
> sure to update your system to eliminate any stale system configuration that
> may attempt to launch `pipewire-media-session`, the original PipeWire session
> manager. Users who previously overrode the system configuration to use
> `wireplumber`, *e.g.* by placing a custom `pipewire.conf` file in
> `/etc/pipewire` or `${XDG_CONFIG_HOME}/pipewire`, may wish to reconcile these
> overrides with `/usr/share/pipewire/pipewire.conf` installed by the most
> recent `pipewire` package. If the sole purpose of a prior override was to
> disable `pipewire-media-session`, deleting the custom configuration may be
> sufficient.

Currently, there is only one session manager available: WirePlumber. To
configure PipeWire to use this session manager and ensure proper startup
ordering, PipeWire should be configured to launch the session manager directly.
This can be accomplished by running

```
# mkdir -p /etc/pipewire/pipewire.conf.d
# ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
```

for system-wide configuration, or

```
$ : "${XDG_CONFIG_HOME:=${HOME}/.config}"
$ mkdir -p "${XDG_CONFIG_HOME}/pipewire/pipewire.conf.d"
$ ln -s /usr/share/examples/wireplumber/10-wireplumber.conf "${XDG_CONFIG_HOME}/pipewire/pipewire.conf.d/"
```

for per-user configuration.

### PulseAudio interface

The PulseAudio interface is optional but highly recommended. Most applications
cannot speak directly to PipeWire, but instead speak to PipeWire's PulseAudio
interface.

If `pulseaudio` is installed, uninstall it and ensure `pulseaudio` is not
running.

Modify the PipeWire configuration to launch `pipewire-pulse`:

```
# mkdir -p /etc/pipewire/pipewire.conf.d
# ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
```

for system configurations, or

```
$ : "${XDG_CONFIG_HOME:=${HOME}/.config}"
$ mkdir -p "${XDG_CONFIG_HOME}/pipewire/pipewire.conf.d"
$ ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf "${XDG_CONFIG_HOME}/pipewire/pipewire.conf.d/"
```

for per-user configurations.

### Testing

[pipewire(1)](https://man.voidlinux.org/pipewire.1) should be started as your
user. To test that PipeWire works, run the `pipewire` command in a terminal
emulator in your session:

```
$ pipewire
```

Launching `pipewire` should be sufficient to establish a working PipeWire
session that uses `wireplumber` for session management.

The status of WirePlumber can be checked with:

```
$ wpctl status
PipeWire 'pipewire-0' [0.3.82, ...]
[...]
```

If the [PulseAudio interface](#pulseaudio-interface) was configured, use
[pactl(1)](https://man.voidlinux.org/pactl.1) (provided by the
`pulseaudio-utils` package) to ensure it is working properly:

```
$ pactl info
[...]
Server Name: PulseAudio (on PipeWire 0.3.82)
[...]
```

### Launching Automatically

Once `pipewire` works as expected, it can be configured to launch when starting
a graphical session. There are several ways this can be achieved:

- **Use the autostarting mechanism of your desktop environment**: many desktop
   environments have a way to configure applications and programs to start
   automatically.
- **Use XDG Desktop Application Autostart**: many desktop environments also
   support the [Desktop Application Autostart
   Specification](https://specifications.freedesktop.org/autostart-spec/autostart-spec-latest.html).
   The `pipewire` package ships a Desktop Entry file for `pipewire` in
   `/usr/share/applications`. If your environment supports the Desktop
   Application Autostart, you can start `pipewire` by symlinking the desktop
   file to the system (`/etc/xdg/autostart`) or user
   (`${XDG_CONFIG_HOME}/autostart` or `~/.config/autostart`) autostart
   directory. If you are using a desktop environment, window manager, or Wayland
   compositor that does not support this, a tool like
   [`dex(1)`](https://man.voidlinux.org/dex.1) can be used to add support for
   Desktop Application Autostart, for example: `dex --environment <window
   manager> --autostart --search-paths ~/.config/autostart`.
- **Use your window manager's startup scripts**: `pipewire` can be launched
   directly from your window manager or Wayland compositor's startup script.

## Optional Setup

### Command-line and Terminal interfaces

A variety of tools for interacting with PipeWire are included in the `pipewire`
package, including [pw-cli(1)](https://man.voidlinux.org/pw-cli.1),
[pw-top(1)](https://man.voidlinux.org/pw-top.1), and
[pw-cat(1)](https://man.voidlinux.org/pw-cat.1).

`wpctl` can be used to control the WirePlumber [session
manager](#session-management).

If using the [PulseAudio interface](#pulseaudio-interface), PulseAudio
configuration tools like `pactl` (from `pulseaudio-utils`) and `ncpamixer` can
also be used.

### Graphical interfaces

`qpwgraph` and `helvum` provide a node-and-graph-style interface for connecting
applications and devices.

If using the [PulseAudio interface](#pulseaudio-interface), PulseAudio
configuration tools like `pavucontrol`, `pavucontrol-qt`, and the widgets and
applets integrated into many desktop environments can also be used to configure
PipeWire.

### Bluetooth audio

Install the `libspa-bluetooth` package.

### ALSA integration

Install `alsa-pipewire`, then enable the PipeWire ALSA device and make it the
default:

```
# mkdir -p /etc/alsa/conf.d
# ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
# ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
```

### JACK interface

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

then reboot.

## Troubleshooting

### Common errors

```
[E][...] mod.rt       | [     module-rt.c:  262 pw_rtkit_bus_get()] Failed to connect to system bus: Failed to connect to socket /run/dbus/system_bus_socket: No such file or directory
```

This indicates the system D-Bus is not running.
[Enable](../services/index.md#enabling-services) the `dbus` service.

```
[E][...] mod.rt       | [     module-rt.c:  262 pw_rtkit_bus_get()] Failed to connect to session bus: D-Bus library appears to be incorrectly set up: see the manual page for dbus-uuidgen to correct this issue. (Failed to open "/var/lib/dbus/machine-id": No such file or directory; Failed to open "/etc/machine-id": No such file or directory)
```

This indicates the [user session D-Bus](../session-management.md#d-bus) is not
running.

```
[E][...] mod.protocol-native | [module-protocol-:  710 init_socket_name()] server 0x55e09658e9d0: name pipewire-0 is not an absolute path and no runtime dir found. Set one of PIPEWIRE_RUNTIME_DIR, XDG_RUNTIME_DIR or USERPROFILE in the environment
```

This indicates [`XDG_RUNTIME_DIR`](../session-management.html#xdg_runtime_dir)
is not set up properly.

### Only a "dummy" output is found

If a session manager (like `wireplumber`) is not running, [configure
it](#session-management) and restart PipeWire.

If a session manager is running, check if your user is in the `audio` and
`video` groups. If not using `elogind`, this is necessary for PipeWire to access
devices.
