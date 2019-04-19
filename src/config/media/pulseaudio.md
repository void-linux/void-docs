# PulseAudio

PulseAudio depends on a `dbus` system daemon, make sure its enabled.

```
# xbps-install -S alsa-utils pulseaudio
# ln -s /etc/sv/dbus /var/service/
```

For applications which use ALSA directly and don't support PulseAudio, the
`alsa-plugins-pulseaudio`package can be installed to make them use PulseAudio
through ALSA.

```
# xbps-install -S alsa-plugins-pulseaudio
```

The PulseAudio package comes with a services file, which is not necessary in
most setups and the PulseAudio maintainers
[discourage](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/SystemWide/)
using a system-wide setup. Instead, PulseAudio will automatically start when
needed.

There are different methods that work with PulseAudio to allow access to the
audio devices, the simplest one is to just the `audio` group alternatively you
can use a session manager, like [elogind](#elogind) or
[ConsoleKit2](#consolekit2).
