# Managing Services

## Basic usage

To start, stop, restart or get the status of a service:

```
# sv up <services>
# sv down <services>
# sv restart <services>
# sv status <services>
```

The `<services>` placeholder can be:

- Service names (service directory names) inside of the `/var/service`
   directory.
- The full path to the services.

As example the following commands show the status of a specific service and of
all enabled services:

```
# sv status dhcpcd
# sv status /var/service/*
```

See [sv(8)](https://man.voidlinux.org/sv.8) for further information.

### Enabling services

Void Linux provides service directories for most daemons in `/etc/sv/`.

To enable a service on a booted system, create a symlink to the service
directory in `/var/service`:

```
# ln -s /etc/sv/<service> /var/service/
```

If the system is not currently running, the service can be linked directly into
the `default` [runsvdir](#runsvdirs):

```
# ln -s /etc/sv/<service> /etc/runit/runsvdir/default/
```

This will automatically start the service. Once a service is linked it will
always start on boot and restart if it stops, unless administratively downed.

To prevent a service from starting at boot while allowing runit to manage it,
create a file named `down` in its service directory:

```
# touch /etc/sv/<service>/down
```

### Disabling services

To disable a service, remove the symlink from the running runsvdir:

```
# rm /var/service/<service>
```

Or from the `default` runsvdir if the system or the specific runsvdir is not
currently running:

```
# rm /etc/runit/runsvdir/default/<service>
```

## Runsvdirs

A `runsvdir` is a directory in `/etc/runit/runsvdir` containing enabled
services. The currently running `runsvdir` will be linked to `/var/service` when
the system is booted.

The `runit-void` package comes with two runsvdir directories; `single` and
`default`.

- `single` just runs sulogin(8) and the necessary steps to rescue your system.
- `default` the default runsvdir.

Additional runsvdirs can be created in `/etc/runit/runsvdir/`.

See [runsvdir(8)](https://man.voidlinux.org/runsvdir.8) and
[runsvchdir(8)](https://man.voidlinux.org/runsvchdir.8) for further information.

### Booting a different runsvdir

To boot a different runsvdir, the name of the runsvdir can be added to the
[kernel command-line](../kernel.html#cmdline). As example adding `single` to the
[kernel command line](../kernel.html#cmdline) will boot the `single` runsvdir.
