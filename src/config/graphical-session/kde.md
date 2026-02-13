# KDE

## Installation

Install the `kde-plasma` package, and optionally, the `kde-baseapps` package.

To use the "Networks" widget, install `NetworkManager` and enable the `dbus` and
`NetworkManager` services. To use the "Volume" widget, set up
[PipeWire](../media/pipewire.md) or [PulseAudio](../media/pulseaudio.md).

Installing the `kde-plasma` package also installs the `sddm` package, which
provides the `sddm` service for the Simple Desktop Display Manager. This service
depends on the `dbus` service being enabled; [test the
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
as part of the `kde-baseapps` meta-package.

### Thumbnail Previews

To enable thumbnail file previews, install the `kdegraphics-thumbnailers`
package. If you want video thumbnails, the `ffmpegthumbs` package is also
necessary. Enable previews in "Control" -> "Configure Dolphin" -> "General" ->
"Previews" by checking the corresponding boxes. File previews will be shown for
the selected file types after clicking "Preview" in Dolphin's toolbar.

### System Sound Themes

The `kde-plasma` package does not include the default KDE Plasma system sounds.
If you wish to install the default system sounds theme, install the
`ocean-sound-theme` package. Legacy sounds can be installed with the
`oxygen-sounds` package.

### Browser Integration

If you wish to enable browser integration, install the
`plasma-browser-integration` package.
