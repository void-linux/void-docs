# rc.conf, rc.local and rc.shutdown

The files `/etc/rc.conf`, `/etc/rc.local` and `/etc/rc.shutdown` can be used to
configure certain parts of your Void system. `rc.conf` is often configured by
`void-installer`.

## rc.conf

Sourced in runit stages 1 and 3. This file can be used to set variables,
including the following:

### KEYMAP

Specifies which keymap to use for the Linux console. Available keymaps are
listed in `/usr/share/kbd/keymaps`. For example:

```
KEYMAP=fr
```

For further details, refer to
[loadkeys(1)](https://man.voidlinux.org/loadkeys.1).

### HARDWARECLOCK

Specifies whether the hardware clock is set to UTC or local time.

By default this is set to `utc`. However, Windows sets the hardware clock to
local time, so if you are dual-booting with Windows, you need to either
configure Windows to use UTC, or set this variable to `localtime`.

For further details, refer to [hwclock(8)](https://man.voidlinux.org/hwclock.8).

### FONT

Specifies which font to use for the Linux console. Available fonts are listed in
`/usr/share/kbd/consolefonts`. For example:

```
FONT=eurlatgr
```

For further details, refer to [setfont(1)](https://man.voidlinux.org/setfont.1).

## rc.local

Sourced in runit stage 2. A shell script which can be used to specify
configuration to be done prior to login.

## rc.shutdown

Sourced in runit stage 3. A shell script which can be used to specify tasks to
be done during shutdown.
