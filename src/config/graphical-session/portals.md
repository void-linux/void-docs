# XDG Desktop Portals

Some applications, including [Flatpak](../external-applications.md#flatpak), use
[XDG Desktop Portals](https://github.com/flatpak/xdg-desktop-portal) to provide
access to various system interfaces, including file open and save dialogs, the
clipboard, screencasting, opening URLs, and more.

## Installation

XDG Desktop Portals require a [user D-Bus session
bus](../session-management.md#d-bus). Install `xdg-desktop-portal` and one or
more backends:

| Backend                    | Notes                                                                          |
|----------------------------|--------------------------------------------------------------------------------|
| `xdg-desktop-portal-gnome` | Provides most common and GNOME-specific interfaces (GTK+ UI)                   |
| `xdg-desktop-portal-gtk`   | Provides most common interfaces (GTK+ UI)                                      |
| `xdg-desktop-portal-kde`   | Provides most common and KDE-specific interfaces (Qt/KF5 UI)                   |
| `xdg-desktop-portal-lxqt`  | Only provides a file chooser (based on libfm-qt)                               |
| `io.elementary.files`      | Only provides a file chooser                                                   |
| `xdg-desktop-portal-wlr`   | Only provides a screenshot and screencasting interface for wlroots compositors |

If unsure what to choose, `xdg-desktop-portal-gtk` is a good default choice.

## Configuration

In most cases, the default configuration, located at
`/usr/share/xdg-desktop-portal/portals.conf`, should suffice. If necessary, this
configuration can be overridden for specific desktop environments and portal
interfaces by creating `$XDG_CURRENT_DESKTOP-portals.conf` or `portals.conf` at
the system or user level as described in
[portals.conf(5)](https://man.voidlinux.org/portals.conf.5).
