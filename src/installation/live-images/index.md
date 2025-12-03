# Live Installers

Void provides live installer images containing a base set of utilities, an
installer program, and package files to install a new Void system. These live
images are also useful for repairing a system that is not able to boot or
function properly.

There are `x86_64` images for both `glibc` and `musl` based systems. There are
also images for `i686`, but only `glibc` is supported for this architecture.
Live images are provided for `aarch64` in both `glibc` and `musl` variants, but
they only support UEFI-capable devices. Live images for `aarch64` do not support
`void-installer`.

Live installers are not provided for other architectures. Users of other
architectures will need to use rootfs tarballs, or perform an installation
manually.

## Installer images

Void releases two types of images: base images and xfce images. Linux beginners
are encouraged to try one of the more full-featured xfce images, but more
advanced users may often prefer to start from a base image to install only the
packages they need.

### Base images

The base images provide only a minimal set of packages to install a usable Void
system. These base packages are only those needed to configure a new machine,
update the system, and install additional packages from repositories.

### Xfce image

The xfce image includes a full desktop environment, web browser, and basic
applications configured for that environment. The only difference from the base
images is the additional packages and services installed.

The following software is included:

- **Window manager:** xfwm4
- **File manager:** Thunar
- **Web Browser:** Firefox
- **Terminal:** xfce4-terminal
- **Plain text editor:** Mousepad
- **Image viewer:** Ristretto
- **Other:** Bulk rename, Orage Globaltime, Orage Calendar, Task Manager, Parole
   Media Player, Audio Mixer, MIME type editor, Application finder

The install process for the xfce image is the same as the base images, except
that you **must** select the `Local` source when installing. If you select
`Network` instead, the installer will download and install the latest version of
the base system, without any additional packages included on the live image.

## Accessibility support

All Void installer images support the console screenreader
[espeakup](https://man.voidlinux.org/espeakup.8) and the console braille display
driver [brltty](https://man.voidlinux.org/brltty.1). On UEFI-based systems, GRUB
is the bootloader, and it will play a two-tone chime when the menu is available.
On BIOS-based systems and UEFI systems in legacy/compatibility mode, SYSLINUX is
the bootloader, and no chime is played.

Several hotkeys exist in the bootloader, which will select different entries:

- `s` will boot with screenreader enabled
- `r` will boot with screenreader enabled and will load the live ISO into RAM
- `g` will boot with screenreader enabled and graphics disabled
- `m` will enter `Memtest86+` (if supported)
- `f` will enter the UEFI firmware setup interface (if supported)
- `b` will reboot the computer
- `p` will power off the computer

SYSLINUX requires pressing enter after pressing a hotkey.

After booting into the installer image with accessibility support enabled, if
there are multiple soundcards detected, a short audio menu allows for the
selection of the soundcard for the screenreader. Press enter when the beep for
the desired soundcard is heard to select it.

If the `Local` installation source is selected in the installer, `espeakup` and
`brltty` will also be installed and enabled on the installed system if enabled
in the live environment.

The xfce image also supports the graphical screenreader
[orca](https://man.voidlinux.org/orca.1). This can be enabled by pressing `Win +
R` and entering `orca -r`. Orca will also be available on the installed system
if the `Local` installation source is selected.

## Kernel Command-line Parameters

Void installer images support several kernel command-line arguments that can
change the behavior of the live system. See [the void-mklive README for a full
list](https://github.com/void-linux/void-mklive#kernel-command-line-parameters).
