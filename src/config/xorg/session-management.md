# Session and Seat Management

Session and seat management is not necessary for every setup, it is used to
provide device access on the fly for the currently active user session.

Please note that [ConsoleKit2](#ConsoleKit2) is virtually unmaintained upstream and is thus no longer the default session and seat manager in Void Linux. If you are having issues with it, the recommended way is to remove [ConsoleKit2](#ConsoleKit2) and install [elogind](#elogind) instead. [ConsoleKit2](#ConsoleKit2) can still be used but requires manual setup of policykit rules to achieve full functionality. For desktop environments like Gnome, [elogind](#elogind) is necessary in any case.

## elogind

[elogind(8)](https://man.voidlinux.org/elogind.8) is a standalone version of
systemd-logind, a service to manage user logins. Install the `elogind` package:

```
# xbps-install -S elogind
```

## ConsoleKit2

Install `ConsoleKit2` and activate its service. Ensure both the `dbus` and the
`cgmanager` services are activated too.

```
# xbps-install -S ConsoleKit2
# ln -s /etc/sv/dbus /var/service/
# ln -s /etc/sv/cgmanager /var/service/
# ln -s /etc/sv/consolekit /var/service/
```

If you don't use a display manager, or your display manager doesn't start a
ConsoleKit2 session on its own, you need to start a ConsoleKit2 session from
your `.xinitrc`. ConsoleKit2 comes with a `xinitrc.d` script
(`/etc/X11/xinit/xinitrc.d/90-consolekit`) which sets the `STARTUP` variable to
the appropriate way to start the session.

The following `.xinitrc` script sources all scripts in
`/etc/X11/xinit/xinitrc.d` and starts the window manager of your choice with a
session.

```
#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

exec $STARTUP <window manager>
```

If any functionality that is controlled by policykit  still not available after setting up ConsoleKit2, you need to place rules in `/etc/polkit-1/rules.d` to allow access by your user or group. This may be necessary for instance to allow shutdown and reboot, mounting and unmounting of disks via udisks2 or using the NetworkManager applet in your desktop environment.
