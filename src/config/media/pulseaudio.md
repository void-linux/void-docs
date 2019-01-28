# PulseAudio

PulseAudio depends on a `dbus` system daemon, make sure its enabled.

```
# xbps-install -S alsa-utils pulseaudio
# ln -s /etc/sv/dbus /var/service/
```

The PulseAudio package comes with a services file, which is not necessary in
most setups and its
[discouraged](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/SystemWide/)
by the PulseAudio maintainers to use the system wide setup. PulseAudio can be
started for X sessions on a per-user basis by adding the following line to
`~/.xinitrc`:

```
start-pulseaudio-x11 &
```

There are different methods that work with PulseAudio to allow access to the
audio devices, the simplest one is to just the `audio` group alternatively you
can use a session manager, like [elogind](#elogind) or
[ConsoleKit2](#consolekit2).
