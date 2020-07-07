# PulseAudio

Depending on which applications you use, you might need to provide PulseAudio
with a D-BUS session bus (e.g. via `dbus-run-session`) or a D-BUS system bus
(via the `dbus` service).

For applications which use ALSA directly and don't support PulseAudio, the
`alsa-plugins-pulseaudio` package can make them use PulseAudio through ALSA.

The PulseAudio package comes with a service file, which is not necessary in most
setups - the PulseAudio maintainers
[discourage](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/SystemWide/)
using a system-wide setup. Instead, PulseAudio will automatically start when
needed.

There are several methods of allowing PulseAudio to access to audio devices. The
simplest one is to add your user to the `audio` group. Alternatively, you can
use a session manager, like `elogind`.
