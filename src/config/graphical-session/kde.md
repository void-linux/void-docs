# KDE

## Installation

Install the `kde5` package, and optionally, the `kde5-baseapps` package.

To use the "Networks" widget, enable the `dbus` and `NetworkManager` services.

Installing the `kde5` package also installs the `sddm` package, which provides
the `sddm` service for the Simple Desktop Display Manager; [test the
service](../services/managing.html#testing-services) before enabling it. If you
are not intending to run SDDM via a remote X server, you will need to install
either the `xorg-minimal` package or the `xorg` package. By default, SDDM will
start an Xorg-based Plasma session, but you can request a Wayland-based Plasma
session instead.

If you wish to start an Xorg-based session from the console, use
[startx](./xorg.html#startx) to run `startplasma-x11`. For a Wayland-based
session, run `startplasma-wayland` directly.
