# Live Installers

Void provides live installer images containing a base set of utilities, an
installer program, and package files to install a new Void system. These live
images are also useful for repairing a system that is not able to boot or
function properly.

There are `x86_64` images for both `glibc` and `musl` based systems. There are
also images for `i686`, but only `glibc` is supported for this architecture.
Live installers are not provided for other architectures. Users of other
architectures will need to use rootfs tarballs, or perform an installation
manually.

## Installer images

Void releases two types of images: base images and "flavor" images. Linux
beginners are encouraged to try one of the more full-featured flavor images, but
more advanced users may often prefer to start from a base image to install only
the packages they need.

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
- **Web Browser:** Firefox ESR
- **Terminal:** xfce4-terminal
- **Plain text editor:** Mousepadd
- **Image viewer:** Ristretto
- **Other:** Bulk rename, Orage Globaltime, Orage Calendar, Task Manager, Parole
   Media Player, Audio Mixer, MIME type editor, Application finder

The install process for the xfce image is the same as the base images, except
that you **must** select the `Local` source when installing. If you select
`Network` instead, the installer will download and install the latest version of
the base system, without any additional packages included on the live image.
