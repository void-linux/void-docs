# Session and Seat Management

Session and seat management is not necessary for every setup, but it can be used
to safely create temporary runtime directories, provide access to hardware
devices, and control system shutdown.

## elogind

[elogind(8)](https://man.voidlinux.org/elogind.8) is a standalone version of
`systemd-logind`, a service to manage user logins. This service provides
necessary features for most desktop environments and Wayland compositors. To
make use of its features, install the `elogind` package and
[enable](../services/index.md) its service and [disable](../services/index.md)
the [acpid(8)](https://man.voidlinux.org/acpid) service as there is a suspend
conflict.
