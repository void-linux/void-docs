# Wayland

This section details the manual installation and configuration of Wayland
compositors and related services and utilities.

## Installation

Unlike [Xorg](./xorg.md), Wayland implementations combine the display server,
the window manager and the compositor in a single application.

### Desktop Environments

Both GNOME and KDE Plasma have Wayland sessions. For GNOME, Wayland is already
the default session, while Plasma still has a few issues to iron out, so their
default remains a Xorg session. While running these desktop environments,
applications built with GTK+ will automatically choose the Wayland backend, but
Qt applications might require the proper environment variable in GNOME. This is
explained [below](#native-applications).

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
provided by the `mesa-dri` package. The [graphics
section](./graphics-drivers/index.md) has more details regarding setting up
graphics in different systems.

### Native applications

Qt5 based applications require the installation of the `qt5-wayland` package and
setting the environment variable `QT_QPA_PLATFORM=wayland-egl` to enable their
Wayland backend. Some KDE specific applications might also require the
installation of the `kwayland` package. GTK+ applications should do it
automatically, but setting `GDK_BACKEND=wayland` can force the Wayland backend
(however, this can break applications such as Chromium).

#### Web browsers

Mozilla Firefox ships with a Wayland backend which is disabled by default. To
enable the Wayland backend, either set the environment variable
`MOZ_ENABLE_WAYLAND=1` before running `firefox` or use the provided
`firefox-wayland` script.

The Midori browser, which has a GTK+ interface, should also work on Wayland.

Qt5 based browsers, such as qutebrowser, also work on Wayland.

#### Terminal emulators

- Alacritty (it's the standard terminal emulator for Sway)
- Kitty
- Sakura

#### Media applications

Both mpv and VLC work on Wayland, with hardware acceleration (if available and
enabled).

For image viewing, imv works natively on Wayland.

#### General desktop utilities

- For screenshots: `grim` and `slurp`. `slurp` is required to define a geometry.
- For accessing the clipboard: `wl-clipboard`.
- For displaying notifications (notification daemon): `mako`.
- For launching applications:
   - wofi
   - bemenu
   - dmenu-wayland

#### Running X applications inside Wayland

If an application still doesn't support Wayland, it can still be run in a
Wayland context. XWayland is an X server that bridges this gap for most Wayland
compositors, and is installed as a dependency for most of them. Its package is
`xorg-server-xwayland`. For Weston, the correct package is `weston-xwayland`.

## Configuration

The Wayland API uses the `XDG_RUNTIME_DIR` environment variable to determine the
directory for the Wayland socket.

Install `elogind` as your [session manager](../session-management.md) to
automatically setup `XDG_RUNTIME_DIR`.

Alternatively, manually set the environment variable through the shell. Make
sure to create a dedicated user directory and set its permissions to `700`. A
good default location is `/run/user/$(id -u)`.

It is also possible that some applications use the `XDG_SESSION_TYPE`
environment variable in some way, which requires that you set it to `wayland`.
