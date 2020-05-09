# Session and Seat Management

Session and seat management is not necessary for every setup, but it can be used
to safely create temporary runtime directories, provide access to hardware
devices and multi-seat capabilities, and control system shutdown.

## D-Bus

D-Bus is an IPC (inter-process communication) mechanism used by userspace
software in Linux. D-Bus can be run as a system bus or as a session bus, the
latter being specific to a user session.

- To use it as a system bus, you should [enable](./services/index.md) the `dbus`
   service. This might require a system reboot to work properly.
- To use it as a session bus, you can start a given program (usually a window
   manager or interactive shell) with
   [dbus-run-session(1)](https://man.voidlinux.org/dbus-run-session.1). Most
   desktop environments, if launched through an adequate display manager, will
   launch a D-Bus session themselves.

## elogind

[elogind(8)](https://man.voidlinux.org/elogind.8) is a standalone version of
`systemd-logind`, a service to manage user logins. This service provides
necessary features for most desktop environments and Wayland compositors. It can
also be one of the mechanisms for rootless [Xorg](./graphical-session/xorg.md).
To make use of its features, install the `elogind` package and make sure the
[system D-Bus](#d-bus) is enabled. You might need to log out and in again.

### Troubleshooting

If you're having any issues with `elogind`, [enable](./services/index.md) its
service, as waiting for a D-Bus activation can lead to issues.

By default, `elogind` listens for and processes ACPI events related to
lid-switch activation and presses of *power*, *suspend* and *hibernate* keys.
This will conflict with the [acpid(8)](https://man.voidlinux.org/acpid) service
if it is installed and enabled. Either disable `acpid` when enabling `elogind`
or configure `elogind` to `ignore` ACPI events in
[logind.conf(5)](https://man.voidlinux.org/logind.conf.5). There are several
configuration options, all starting with the keyword `Handle`, that should be
set to `ignore` to avoid interfering with `acpid`.
