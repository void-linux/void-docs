# Managing Services

## Basic usage

To start, stop or restart a service:

```
# sv up service_name
# sv down service_name
# sv restart service_name
```

To get the current status of a service:

```
# sv status service_name
```

To get the current status of all enabled services:

```
# sv status /var/service/*
```

## Enabling services

Void Linux provides service directories for most daemons in `/etc/sv/`. To
enable a service, create a symlink to the service directory in `/var/service`:

```
# ln -s /etc/sv/service_name /var/service/
```

This will automatically start the service. Once a service is linked it will
always start on boot and restart if it stops, unless administratively downed.

To prevent a service from starting at boot while allowing runit to manage it,
create a file named 'down' in its service directory:

```
# touch /etc/sv/service_name/down
```

## Disabling services

To disable a service, remove the symlink to its service directory from
/var/service:

```
# rm /var/service/service_name
```

## Runlevels

The `runit-void` package currently supports two runlevels: `single` and
`default`.

- `single` just runs sulogin(8) and the necessary steps to rescue your system.
- `default`, the default run level, runs all services linked in `/var/service/`.

## Void runit directories

- `/var/service`: always linked to the currently active runlevel. All entries in
   `/var/service` are considered 'active' services (and by default, are started
   upon linking).
- `/etc/sv`: contains subdirectories for available services (usually added by
   XBPS).
- `/etc/runit/runsvdir`: contains all available runlevels.
