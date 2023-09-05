# Session and Seat Management

Session and seat management is not necessary for every setup, but it can be used
to safely create temporary runtime directories, provide access to hardware
devices and multi-seat capabilities, and control system shutdown.

## D-Bus

D-Bus is an IPC (inter-process communication) mechanism used by userspace
software in Linux. D-Bus can provide a system bus and/or a session bus, the
latter being specific to a user session.

- To provide a system bus, you should
   [enable](./services/index.md#enabling-services) the `dbus` service. This
   might require a system reboot to work properly.
- To provide a session bus, you can start a given program (usually a window
   manager or interactive shell) with
   [dbus-run-session(1)](https://man.voidlinux.org/dbus-run-session.1). Most
   desktop environments, if launched through an adequate display manager, will
   launch a D-Bus session themselves. If a D-Bus session is active for the
   current session, the environment variable `DBUS_SESSION_BUS_ADDRESS` should
   be defined.

Note that some software assumes the presence of a system bus, while other
software assumes the presence of a session bus.

## elogind

[elogind(8)](https://man.voidlinux.org/elogind.8) manages user logins and system
power, as a standalone version of `systemd-logind`. elogind provides necessary
features for most desktop environments and Wayland compositors. It can also be
one of the mechanisms for rootless [Xorg](./graphical-session/xorg.md).

Please read the "[Power Management](./power-management.md)" section for things
to consider before installing elogind.

To make use of its features, install the `elogind` package and make sure the
[system D-Bus](#d-bus) is enabled. You might need to log out and in again.

If you're having any issues with elogind, [enable](./services/index.md) its
service, as waiting for a D-Bus activation can lead to issues.

## seatd

[seatd(1)](https://man.voidlinux.org/seatd.1) is a minimal seat management
daemon and an alternative to elogind primarily for [wlroots
compositors](./graphical-session/wayland.md#standalone-compositors).

To use it, install the `seatd` package and enable its service. If you want
non-root users to be able to access the seatd session, add them to the `_seatd`
group.

Note that, unlike elogind, seatd doesn't do anything besides managing seats.

## XDG_RUNTIME_DIR

`XDG_RUNTIME_DIR` is an environment variable defined by the [XDG Base Directory
Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).
Its value sets the path to the base directory where programs should store
user-specific runtime files.

Install [elogind](#elogind) as your session manager to automatically set up
`XDG_RUNTIME_DIR`.

Alternatively, manually set the environment variable through the shell. Make
sure to create a dedicated user directory and set its permissions to `700`. A
good default location is `/run/user/$(id -u)`.
