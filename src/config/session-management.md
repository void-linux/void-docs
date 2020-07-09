# Session and Seat Management

Session and seat management is not necessary for every setup, but it can be used
to safely create temporary runtime directories, provide access to hardware
devices and multi-seat capabilities, and control system shutdown.

## D-Bus

D-Bus is an IPC (inter-process communication) mechanism used by userspace
software in Linux. D-Bus can provide a system bus and/or a session bus, the
latter being specific to a user session.

- To provide a system bus, you should [enable](./services/index.md) the `dbus`
   service. This might require a system reboot to work properly.
- To provide a session bus, you can start a given program (usually a window
   manager or interactive shell) with
   [dbus-run-session(1)](https://man.voidlinux.org/dbus-run-session.1). Most
   desktop environments, if launched through an adequate display manager, will
   launch a D-Bus session themselves.

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

There is an alternative D-Bus configuration which takes advantage of elogind for
features such as seat detection. It requires installing the `dbus-elogind`,
`dbus-elogind-libs` and `dbus-elogind-x11` packages.
