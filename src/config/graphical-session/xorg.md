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

The open source drivers are installed with the `xorg` package by default, or may
be installed individually if the `xorg-minimal` was installed. Below is a table
of device brands and their driver packages.

| Brand  | Type        | Driver Package       |
|--------|-------------|----------------------|
| AMD    | Open Source | `xf86-video-amdgpu`  |
| ATI    | Open Source | `xf86-video-ati`     |
| Intel  | Open Source | `xf86-video-intel`   |
| NVIDIA | Open Source | `xf86-video-nouveau` |

> Note: Fourth generation Intel users may want to use the default xorg driver,
> rather than installing `xf86-video-intel` driver package. For more
> information, see the [Arch wiki
> page](https://wiki.archlinux.org/index.php/Intel_graphics#Installation).

### Proprietary Video Drivers

Void also provides proprietary video drivers, which are available in the
[non-free](../../xbps/repositories/official/nonfree.md) repository.

| Brand      | Type        | Model                           | Driver Package |
|------------|-------------|---------------------------------|----------------|
| ATI/Radeon | Proprietary |                                 | `catalyst`     |
| NVIDIA     | Proprietary | 500+                            | `nvidia`       |
| NVIDIA     | Proprietary | 300/400 Series                  | `nvidia390`    |
| NVIDIA     | Proprietary | GeForce8/9 + 100/200/300 Series | `nvidia340`    |

## Input Drivers

A number of input drivers are available for Xorg. If `xorg-minimal` was
installed and a device is not responding, or behaving unexpectedly, a different
driver may correct the issue. These drivers can grab everything from power
buttons to mice and keyboards.

| Driver                 |
|------------------------|
| `xf86-input-evdev`     |
| `xf86-input-joystick`  |
| `xf86-input-libinput`  |
| `xf86-input-mtrack`    |
| `xf86-input-synaptics` |
| `xf86-input-vmmouse`   |
| `xf86-input-wacom`     |

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
