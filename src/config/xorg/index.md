# Xorg

This section details the manual installation and configuration of the Xorg
display server and common related services and utilities. If you would just like
to install a full desktop environment, it is recommended to try one of the
[flavor images](../../installation/live-images/index.md#flavor-images)

## Installation

Void provides a comprehensive `xorg` package which installs the server and all
of the free video drivers, fonts, and base applications. This package is a safe
option, and should be adequate for most systems which don't require proprietary
video drivers.

If you would like to select only the packages you need, the `xorg-minimal`
package contains the base xorg server *only*. If you install only
`xorg-minimal`, you will likely need to install a font package (like
`xorg-fonts`), a terminal emulator (like `xterm`), and a window manager to have
a usable graphics system.

## Drivers

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

> Note: Fourth generation intel users may want to use the default xorg driver,
> rather than installing `xf86-video-intel` driver package. For more
> information, see the [Arch wiki
> page](https://wiki.archlinux.org/index.php/Intel_graphics#Installation).

### Proprietary Drivers

Void also provides proprietary video drivers, which are available in the
[non-free](../../maintenance/repositories/official/nonfree.md) repository.

| Brand      | Type        | Model                           | Driver Package |
|------------|-------------|---------------------------------|----------------|
| ATI/Radeon | Proprietary |                                 | `catalyst`     |
| NVIDIA     | Proprietary | 500+                            | `nvidia`       |
| NVIDIA     | Proprietary | 300/400 Series                  | `nvidia390`    |
| NVIDIA     | Proprietary | GeForce8/9 + 100/200/300 Series | `nvidia340`    |
