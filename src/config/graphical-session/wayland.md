# Wayland

This section details the manual installation and configuration of Wayland
compositors and related services and utilities.

## Installation

Unlike [Xorg](./xorg.md), Wayland implementations combine the display server,
the window manager and the compositor in a single application.

### Desktop Environments

GNOME, KDE Plasma and Enlightenment have Wayland sessions. GNOME uses its
Wayland session by default. When using these desktop environments, applications
built with GTK+ will automatically choose the Wayland backend, while Qt5 and EFL
applications might require [setting some environment
variables](#native-applications) if used outside KDE or Enlightenment,
respectively.

### Standalone compositors

Void Linux currently packages the following Wayland compositors:

- Weston: reference compositor for Wayland
- Sway: an i3-compatible Wayland compositor
- Wayfire: 3D Wayland compositor
- Hikari: a stacking compositor with some tiling features
- Cage: a Wayland kiosk

### Video drivers

Both GNOME and KDE Plasma have EGLStreams backends for Wayland, which means they
can use the proprietary NVIDIA drivers. Most other Wayland compositors require
drivers that implement the GBM interface. The main driver for this purpose is
provided by the `mesa-dri` package. The "[Graphics
Drivers](./graphics-drivers/index.md)" section has more details regarding
setting up graphics in different systems.

### Seat management

Wayland compositors require some way of controlling the video display and
accessing input devices. In Void systems, this requires a seat manager service,
which can be either elogind or seatd. Enabling them is explained in the
["Session and Seat Management"](../session-management.md) session.

### Native applications

[Qt5](https://wayland.freedesktop.org/qt5.html)-based applications require
installing the `qt5-wayland` package and setting the environment variable
`QT_QPA_PLATFORM=wayland-egl` to enable their Wayland backend. Some KDE specific
applications also require installing the `kwayland` package.
[EFL](https://wayland.freedesktop.org/efl.html)-based applications require
setting the environment variable `ELM_DISPLAY=wl`, and can have issues without
it, due to not supporting XWayland properly.
[GTK+](https://wiki.gnome.org/Initiatives/Wayland/GTK%2B)-based applications
should use the Wayland backend automatically. Information about other toolkits
can be found in the [Wayland
documentation](https://wayland.freedesktop.org/toolkits.html).

Media applications, such as [mpv(1)](https://man.voidlinux.org/mpv.1),
[vlc(1)](https://man.voidlinux.org/vlc.1) and `imv` work natively on Wayland.

#### Web browsers

Mozilla Firefox ships with a Wayland backend which is disabled by default. To
enable the Wayland backend, either set the environment variable
`MOZ_ENABLE_WAYLAND=1` before running `firefox` or use the provided
`firefox-wayland` script.

Browsers based on GTK+ or Qt5, such as Midori and
[qutebrowser(1)](https://man.voidlinux.org/qutebrowser.1), should work on
Wayland natively.

#### Running X applications inside Wayland

If an application doesn't support Wayland, it can still be used in a Wayland
context. XWayland is an X server that bridges this gap for most Wayland
compositors, and is installed as a dependency for most of them. Its package is
`xorg-server-xwayland`. For Weston, the correct package is `weston-xwayland`.

## Configuration

The Wayland library requires the
[`XDG_RUNTIME_DIR`](../session-management.html#xdg_runtime_dir) environment
variable to determine the directory for the Wayland socket.

It is also possible that some applications use the `XDG_SESSION_TYPE`
environment variable in some way, which requires that you set it to `wayland`.
