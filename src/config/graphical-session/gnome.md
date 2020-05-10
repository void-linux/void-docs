# GNOME

## Pre-installation

GNOME supports both X and Wayland sessions. Follow the "[Wayland](./wayland.md)"
or "[Xorg](./xorg.md)" sections to setup your preferred environment.

Install the `dbus` package, ensure the `dbus` service is enabled, and reboot for
the changes to take effect.

## Installation

Install the `gnome` package for a GNOME environment which includes the base
GNOME desktop and a subset of GNOME applications. Additional applications are
available via the `gnome-apps` package.

A minimal GNOME environment can be created by installing the `gnome-core`
package. Note, however, that not all GNOME features may be present or
functional.

If you require [ZeroConf](http://www.zeroconf.org/) support, install the `avahi`
package and enable the `avahi-daemon` service.

## Starting GNOME

The `gdm` package provides the `gdm` service for the GNOME Display Manager;
[test the service](../services/index.md#testing-services) before enabling it.
GDM defaults to providing a Wayland session via the `mutter` window manager, but
an X session can be chosen instead.
