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

### Flavor images

Each of the Void "flavor" images includes a full desktop environment, web
browser, and basic applications configured for that environment. The only
difference from the base images is the additional packages and services
installed.

The install process for each of the flavor images is the same as the base
images, except that you **must** select the `Local` source when installing. If
you select `Network` instead, the installer will download and install the latest
version of the base system, without any additional packages included on the live
image.

#### Comparison of flavor images

Here's a quick overview of the main components and applications included with
each flavor:

|                   | Enlightenment                                         | Cinnamon        | LXDE                                    | LXQT           | MATE                                                                                                                                                                | XFCE                                                                                                                                |
|-------------------|-------------------------------------------------------|-----------------|-----------------------------------------|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| Window Manager    | Enlightenment Window Manager                          | Mutter (Muffin) | Openbox                                 | Openbox        | Metacity (Marco)                                                                                                                                                    | xfwm4                                                                                                                               |
| File Manager      | Enlightenment File Manager                            | Nemo            | PCManFM                                 | PCManFM-Qt     | Caja                                                                                                                                                                | Thunar                                                                                                                              |
| Web Browser       | Firefox ESR                                           | Firefox ESR     | Firefox ESR                             | QupZilla       | Firefox ESR                                                                                                                                                         | Firefox ESR                                                                                                                         |
| Terminal          | Terminology                                           | gnome-terminal  | LXTerminal                              | QTerminal      | MATE terminal                                                                                                                                                       | xfce4-Terminal                                                                                                                      |
| Document Viewer   | -                                                     | -               | -                                       | -              | Atril (PS/PDF)                                                                                                                                                      | -                                                                                                                                   |
| Plain text viewer | -                                                     | -               | -                                       | -              | Pluma                                                                                                                                                               | Mousepad                                                                                                                            |
| Image viewer      | -                                                     | -               | GPicView                                | LXImage        | Eye of MATE                                                                                                                                                         | Ristretto                                                                                                                           |
| Archive unpacker  | -                                                     | -               | -                                       | -              | Engrampa                                                                                                                                                            | -                                                                                                                                   |
| Other             | Mixer, EConnMan (connection manager), Elementary Test | -               | LXTask (task manager), MIME type editor | Screen grabber | Screen grabber, file finder, MATE color picker, MATE font viewer, Disk usage analyzer, Power statistics, System monitor (task manager), Dictionary, Log file viewer | Bulk rename, Orage Globaltime, Orage Calendar, Task Manager, Parole Media Player, Audio Mixer, MIME type editor, Application finder |
