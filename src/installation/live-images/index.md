# Live Installer Images

Void releases include two types of images: base images and "flavor" images. Both
types of image, and the different flavor images, are described below.

## Base images

Void provides installer images containing a base set of utilities, an installer
program, and package files to install a Void base system. Images are provided
for glibc based systems on both i686 and x86_64 processors, as well as musl
based systems on x86_64-compatible processors.

## Flavor images

In addition to the base image, Void provides additional "flavors" which each
include a full desktop environment and web browser, and are pre-configured with
basic applications for that system. The install process for each of these images
is the same as the base image. The flavor images only differ from the base image
by which packages are included and installed.

> Note: we encourage Linux beginners to try one of the flavor images. Users
> comfortable with a more advanced setup may prefer to install Void from a base
> image.

### Comparison of flavor images

Here's a quick overview of the main components and applications included with
each flavor:

|                   | Enlightenment                                         | Cinnamon        | LXDE                                    | LXQT           | MATE                                                                                                                                                                | XFCE                                                                                                                                |
|-------------------|-------------------------------------------------------|-----------------|-----------------------------------------|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| Window Manager    | Enlightenment Window Manager                          | Mutter (Muffin) | Openbox                                 | Openbox        | Metacity (Macro)                                                                                                                                                    | xfwm4                                                                                                                               |
| File Manager      | Enlightenment File Manager                            | Nemo            | PCManFM                                 | PCManFM-Qt     | Caja                                                                                                                                                                | Thunar                                                                                                                              |
| Web Browser       | Firefox ESR                                           | Firefox ESR     | Firefox ESR                             | QupZilla       | Firefox ESR                                                                                                                                                         | Firefox ESR                                                                                                                         |
| Terminal          | Terminology                                           | gnome-terminal  | LXTerminal                              | QTerminal      | MATE terminal                                                                                                                                                       | xfce4-Terminal                                                                                                                      |
| Document Viewer   | -                                                     | -               | -                                       | -              | Atril (PS/PDF)                                                                                                                                                      | -                                                                                                                                   |
| Plain text viewer | -                                                     | -               | -                                       | -              | Pluma                                                                                                                                                               | Mousepad                                                                                                                            |
| Image viewer      | -                                                     | -               | GPicView                                | LXImage        | Eye of MATE                                                                                                                                                         | Ristretto                                                                                                                           |
| Archive unpacker  | -                                                     | -               | -                                       | -              | Engrampa                                                                                                                                                            | -                                                                                                                                   |
| Other             | Mixer, EConnMan (connection manager), Elementary Test | -               | LXTask (task manager), MIME type editor | Screen grabber | Screen grabber, file finder, MATE color picker, MATE font viewer, Disk usage analyzer, Power statistics, System monitor (task manager), Dictionary, Log file viewer | Bulk rename, Orage Globaltime, Orage Calendar, Task Manager, Parole Media Player, Audio Mixer, MIME type editor, Application finder |
