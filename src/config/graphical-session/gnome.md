# GNOME

## Pre-installation

Install the `dbus` package, ensure the `dbus` service is enabled, and reboot for
the changes to take effect.

## Installation

Install the `gnome` package for a GNOME environment which includes GNOME
applications.

A minimal GNOME environment can be created by installing the `mesa-dri`,
`gnome-session`, `gdm` and `adwaita-icon-theme` packages. (Note, however, that
not all GNOME features may be present or functional.)

The `gdm` package provides the `gdm` service for the GNOME Display Manager;
[test the service](../services/index.md#testing-services) before enabling it.
GDM defaults to providing a Wayland session via the `mutter` window manager, but
an X session can be chosen instead.

If you wish to start an X-based GNOME session from the console, use
[startx](./xorg.md#startx) to run `gnome-session`.

GNOME applications can be installed via the `gnome-apps` package.

If you require [ZeroConf](http://www.zeroconf.org/) support, install the `avahi`
package and enable the `avahi-daemon` service.
