# Xorg

This section details the manual installation and configuration of the Xorg
display server and common related services and utilities. If you would just like
to install a full desktop environment, it is recommended to try one of the
[flavor images](../../installation/live-images/index.md#flavor-images)

## Installation

Void provides a comprehensive `xorg` package which installs the server and all
of the free video drivers, input drivers, fonts, and base applications. This
package is a safe option, and should be adequate for most systems which don't
require proprietary video drivers.

If you would like to select only the packages you need, the `xorg-minimal`
package contains the base xorg server *only*. If you install only
`xorg-minimal`, you will likely need to install a font package (like
`xorg-fonts`), a terminal emulator (like `xterm`), and a window manager to have
a usable graphics system.

## Video Drivers

Void provides both open-source and proprietary (non-free) video drivers.

### Open Source Drivers

Xorg can use two categories of open source drivers: DDX or modesetting.

#### DDX

The DDX drivers are installed with the `xorg` package by default, or may be
installed individually if the `xorg-minimal` package was installed. They are
provided by the `xf86-video-*` packages.

For advanced configuration, see the man page corresponding to the vendor name,
like [intel(4)](https://man.voidlinux.org/intel.4).

#### Modesetting

Modesetting requires the `mesa-dri` package, and no additional vendor-specific
driver package.

Xorg defaults to DDX drivers if they are present, so in this case modesetting
must be explicitly selected: see [Forcing the modesetting
driver](#forcing-the-modesetting-driver).

For advanced configuration, see
[modesetting(4)](https://man.voidlinux.org/modesetting.4).

### Proprietary Drivers

Void also provides [proprietary NVIDIA drivers](./graphics-drivers/nvidia.md),
which are available in the [nonfree
repository](../../xbps/repositories/index.md#nonfree).

## Input Drivers

A number of input drivers are available for Xorg. If `xorg-minimal` was
installed and a device is not responding, or behaving unexpectedly, a different
driver may correct the issue. These drivers can grab everything from power
buttons to mice and keyboards. They are provided by the `xf86-input-*` packages.

## Xorg Configuration

Although Xorg normally auto-detects drivers and configuration is not needed, a
config for a specific keyboard driver may look something like a file
`/etc/X11/xorg.conf.d/30-keyboard.conf` with the contents:

```
Section "InputClass"
  Identifier "keyboard-all"
  Driver "evdev"
  MatchIsKeyboard "on"
EndSection
```

### Forcing the modesetting driver

Create the file `/etc/X11/xorg.conf.d/10-modesetting.conf`:

```
Section "Device"
    Identifier "GPU0"
    Driver "modesetting"
EndSection
```

and restart Xorg. Verify that the configuration has been picked up with:

```
$ grep -m1 '(II) modeset([0-9]+):' /var/log/Xorg.0.log
```

If there is a match, modesetting is being used.

## Starting X Sessions

### startx

The `xinit` package provides the [startx(1)](https://man.voidlinux.org/startx.1)
script as a frontend to [xinit(1)](https://man.voidlinux.org/xinit.1), which can
be used to start X sessions from the console. For example, to start
[i3(1)](https://man.voidlinux.org/i3.1), edit `~/.xinitrc` to contain `exec
/bin/i3` on the last line.

To start arbitrary programs together with an X session, add them in `~/.xinitrc`
before the last line. For example, to start
[pipewire(1)](https://man.voidlinux.org/pipewire.1) before starting i3, add
`pipewire &` before the last line.

A `~/.xinitrc` file which starts `pipewire` and `i3` is shown below:

```
pipewire &
exec /bin/i3
```

Then call `startx` to start a session.

If a D-Bus session bus is required, you can [manually start
one](../session-management.md#d-bus).

### Display Managers

Display managers (DMs) provide a graphical login UI. A number of DMs are
available in the Void repositories, including `gdm` (the GNOME DM), `sddm` (the
KDE DM) and `lightdm`. When setting up a display manager, be sure to [test the
service](../services/index.md#testing-services) before enabling it.
