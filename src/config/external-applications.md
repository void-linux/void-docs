# External Applications

## Programming Languages

The Void repositories have a number of Python and Lua packages. If possible,
install packages from the Void repositories or consider packaging the library or
application you need. Packaging your application allows for easier system
maintenance and can benefit other Void Linux users, so consider making a pull
request for it. The contribution instructions can be found
[here](https://github.com/void-linux/void-packages/blob/master/CONTRIBUTING.md).

To keep packages smaller, Void has separate `devel` packages for header files
and development tools. If you install a library or application via a language's
package manager (e.g. `pip`, `gem`), or compile one from source, you may need to
install the programming language's `-devel` package. This is specially relevant
for `musl` libc users, due to pre-built binaries usually targeting `glibc`
instead.

| Language | Package Manager                | Void Package    |
|----------|--------------------------------|-----------------|
| Python3  | pip, anaconda, virtualenv, etc | `python3-devel` |
| Python2  | pip, anaconda, virtualenv, etc | `python2-devel` |
| Ruby     | gem                            | `ruby-devel`    |
| lua      | luarocks                       | `lua-devel`     |

## Restricted Packages

Some packages have legal restrictions on their distribution (e.g. Discord), may
be too large, or have another condition that makes it difficult for Void to
distribute. These packages have build templates, but the packages themselves are
not built or distributed. As such, they must be built locally. For more
information see the page on [restricted
packages](../xbps/repositories/restricted.md).

## Non-x86_64 Architectures

The Void build system runs on x86_64 servers, both for compiling and
cross-compiling packages. However, some packages (e.g. `pandoc`) do not support
cross-compilation. These packages have to be built locally on a computer running
the same architecture and libc as the system on which the package is to be used.
To learn how to build packages, refer to [the README for the void-packages
repository](https://github.com/void-linux/void-packages/blob/master/README.md).

## Flatpak

Flatpak is another method for installing external proprietary applications on
Linux. For information on using Flatpak with Void Linux, see the [official
Flatpak documentation](https://flatpak.org/setup/Void%20Linux/).

If sound is not working for programs installed using Flatpak,
[PulseAudio](./media/pulseaudio.md) auto-activation might not be working
correctly. Make sure PulseAudio is running before launching the program.

Note that Flatpak's sandboxing will not necessarily protect you from any
security and/or privacy-violating features of proprietary software.

### Troubleshooting

Some apps may not function properly (e.g. not being able to access the host
system's files). Some of these issues can be fixed by installing one or more of
the `xdg-user-dirs`, `xdg-user-dirs-gtk` or `xdg-utils` packages, and setting up
[XDG Desktop Portals](./graphical-session/portals.md).

Some Flatpaks require [D-Bus](./session-management.md#d-bus) and/or
[Pulseaudio](./media/pulseaudio.md).

## AppImages

An [AppImage](https://appimage.org/) is a file that bundles an application with
everything needed to run it. An AppImage can be used by making it executable and
running it; installation is not required. AppImages can be run in a sandbox,
such as [firejail](https://firejail.wordpress.com/).

Some of the applications for which an AppImage is available can be found on
[AppImageHub](https://appimage.github.io/).

AppImages do not yet work on musl installations.

## Octave Packages

Some Octave packages require external dependencies to compile and run. For
example, to build the control package, you must install the `openblas-devel`,
`libgomp-devel`, `libgfortran-devel`, `gcc-fortran`, and `gcc` packages.

## MATLAB

To use MATLAB's help browser, live scripts, add-on installer, and simulink,
install the `libselinux` package.

## Steam

Steam can be installed either via a native package, which requires [enabling the
"nonfree" repository](../xbps/repositories/index.md#nonfree), or via
[Flatpak](#flatpak). The list of dependencies for different platforms and
troubleshooting information for the native package can be found in its
[Void-specific documentation](./package-documentation/index.md), while this
section deals with potential issues faced by Flatpak users.

If you are using a different drive to store your game library, the
`--filesystem` option from
[flatpak-override(1)](https://man.voidlinux.org/flatpak-override.1) can prove
useful.
