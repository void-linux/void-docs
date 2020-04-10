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
packages](../repositories/restricted.md).

## Non-x86_64 Arch

The Void build system runs on x86_64 servers, both for compiling and cross
compiling packages. However, some packages (e.g. `libreoffice`) do not support
cross-compilation. These packages have to be built locally on a computer running
the same architecture and libc as the system on which the package is to be used.
For building packages, see the [building instructions](../packages/building.md).

## Flatpak

Flatpak is another method for installing external proprietary applications on
Linux. For information on using Flatpak with Void Linux, see the [official
Flatpak documentation](https://flatpak.org/setup/Void%20Linux/).

> Flatpak's sandboxing will not necessarily protect you from any security and/or
> privacy-violating features of proprietary software.

### Troubleshooting

Some apps may not function properly (e.g. not being able to access the host
system's files). This may be fixed by installing one or more of the
`xdg-desktop-portal`, `xdg-desktop-portal-gtk`, `xdg-user-dirs`,
`xdg-user-dirs-gtk` or `xdg-utils` packages.

Some Flatpaks require D-Bus. If you are using a window manager (e.g. i3wm), you
can launch your window manager with
[dbus-run-session(1)](https://man.voidlinux.org/dbus-run-session.1). Some
Flatpaks can also require [Pulseaudio](./media/pulseaudio.md).

## Octave Packages

Some Octave packages require external dependencies to compile and run. For
example, to build the control package, you must install the `openblas-devel`,
`libgomp-devel`, `libgfortran-devel`, `gcc-fortran`, and `gcc` packages.
