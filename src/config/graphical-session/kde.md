# KDE

## Installation

Install the `kde5` package, and optionally, the `kde5-baseapps` package.

To use the "Networks" widget, enable the `dbus` and `NetworkManager` services.

Installing the `kde5` package also installs the `sddm` package, which provides
the `sddm` service for the Simple Desktop Display Manager. This service depends
on the `dbus` service being enabled; [test the
service](../services/index.md#testing-services) before enabling it. If you are
not intending to run SDDM via a remote X server, you will need to install either
the `xorg-minimal` package or the `xorg` package. By default, SDDM will start an
X-based Plasma session, but you can request a Wayland-based Plasma session
instead.

If you wish to start an X-based session from the console, use
[startx](./xorg.md#startx) to run `startplasma-x11`. For a Wayland-based
session, run `startplasma-wayland` directly.

## Dolphin

Dolphin is the default file manager of the KDE desktop environment. It can be
installed on its own by installing the `dolphin` package, or it can be installed
as part of the `kde5-baseapps` meta-package.

### Thumbnail Previews

To enable thumbnail file previews, install the `kdegraphics-thumbnailers`
package. If you want video thumbnails, the `ffmpegthumbs` package is also
necessary. Enable previews in "Control" -> "Configure Dolphin" -> "General" ->
"Previews" by checking the corresponding boxes. File previews will be shown for
the selected file types after clicking "Preview" in Dolphin's toolbar.
