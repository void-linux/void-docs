# Power Management

## acpid

The `acpid` service for [acpid(8)](https://man.voidlinux.org/acpid.8) is
installed and, if Void was installed from a live image using the local source,
will be enabled by default. ACPI events are handled by `/etc/acpi/handler.sh`,
which uses [zzz(8)](https://man.voidlinux.org/zzz.8) for suspend-to-RAM events.

## elogind

The `elogind` service is provided by the `elogind` package. By default,
[elogind(8)](https://man.voidlinux.org/elogind.8) listens for, and processes,
ACPI events related to lid-switch activation and the *power*, *suspend* and
*hibernate* keys. This will conflict with the `acpid` service if it is installed
and enabled. Either disable `acpid` when enabling `elogind`, or configure
`elogind` to `ignore` ACPI events in
[logind.conf(5)](https://man.voidlinux.org/logind.conf.5). There are several
configuration options, all starting with the keyword `Handle`, that should be
set to `ignore` to avoid interfering with `acpid`.

To run `loginctl poweroff` and `loginctl reboot` without root privileges,
`polkit` must be installed.

## Power Saving - tlp

Laptop battery life can be extended by using
[tlp(8)](https://man.voidlinux.org/tlp.8). To use it, install the `tlp` package,
and [enable](./services/index.md#enabling-services) the `tlp` service. Refer to
[the TLP documentation](https://linrunner.de/tlp/) for details.
