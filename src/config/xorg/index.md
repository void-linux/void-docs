# Xorg

## Drivers

## Display managers

## Session and seat management

Session and seat management is not necessary for every setup, it is used to provide device access on the fly for the currently active user session.

For desktop environments like Gnome [elogind](#elogind) is necessary.

### ConsoleKit2

Install ConsoleKit2 and activate its service and make sure the dbus and the cgmanager services are activated too.

```
# xbps-install -S ConsoleKit2
# ln -s /etc/sv/dbus /var/service/
# ln -s /etc/sv/cgmanager /var/service/
# ln -s /etc/sv/consolekit /var/service/
```

If you don't use a display manager or your display manager doesn't start a ConsoleKit2 session on its own you need to start a ConsoleKit2 session from your `.xinitrc`. ConsoleKit2 comes with a `xinitrc.d` script (`/etc/X11/xinit/xinitrc.d/90-consolekit`) which sets the `STARTUP` variable to the appropriate way to start the session.

The following `.xinitrc` script sources all scripts in `/etc/X11/xinit/xinitrc.d` and starts the window manager of your choice with a session.

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

### elogind

```
# xbps-install -S elogind
```
