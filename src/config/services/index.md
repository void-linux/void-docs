# Services and Daemons - runit

Void uses the [runit(8)](https://man.voidlinux.org/runit.8) supervision suite to
run system services and daemons.

Some advantages of using runit include:

- a small code base, making it easier to audit for bugs and security issues.
- each service is given a clean process state, regardless of how the service was
   started or restarted: it will be started with the same environment, resource
   limits, open file descriptors, and controlling terminals.
- a reliable logging facility for services, where the log service stays up as
   long as the relevant service is running and possibly writing to the log.

If you don't need a program to be running constantly, but would like it to run
at regular intervals, you might like to consider using a [cron
daemon](../cron.md).

## Section Contents

- [Per-User Services](./user-services.md)
- [Logging](./logging.md)

## Service Directories

Each service managed by runit has an associated *service directory*.

A service directory requires only one file: an executable named `run`, which is
expected to exec a process in the foreground.

Optionally, a service directory may contain:

- an executable named `check`, which will be run to check whether the service is
   up and available; it's considered available if `check` exits with 0.
- an executable named `finish`, which will be run on shutdown/process stop.
- a `conf` file; this can contain environment variables to be sourced and
   referenced in `run`.
- a directory named `log`; a pipe will be opened from the output of the `run`
   process in the service directory to the input of the `run` process in the
   `log` directory.

When a new service is created, a `supervise` folder will be automatically
created on the first run.

### Configuring Services

Most services can take configuration options set by a `conf` file in the service
directory. This allows service customization without modifying the service
directory provided by the relevant package.

Check the service file for how to pass configuration parameters. A few services
have a field like `OPTS="--value ..."` in their `conf` file.

To make more complex customizations, you should [edit the
service](#editing-services).

### Editing Services

To edit a service, first copy its service directory to a different directory
name. Otherwise, [xbps-install(1)](https://man.voidlinux.org/xbps-install.1) can
overwrite the service directory. Then, edit the new service file as needed.
Finally, the old service should be stopped and disabled, and the new one should
be started.

## Managing Services

### Runsvdirs

A **runsvdir** is a directory in `/etc/runit/runsvdir` containing enabled
services in the form of symlinks to service directories. On a running system,
the current runsvdir is accessible via the `/var/service` symlink.

The `runit-void` package comes with two runsvdirs, `single` and `default`:

- `single` just runs [sulogin(8)](https://man.voidlinux.org/sulogin.8) and the
   necessary steps to rescue your system.
- `default` is the default runsvdir on a running system, unless [specified
   otherwise by the kernel command line](#booting-a-different-runsvdir).

Additional runsvdirs can be created in `/etc/runit/runsvdir/`.

See [runsvdir(8)](https://man.voidlinux.org/runsvdir.8) and
[runsvchdir(8)](https://man.voidlinux.org/runsvchdir.8) for further information.

#### Booting A Different runsvdir

To boot a runsvdir other than `default`, the name of the desired runsvdir can be
added to the [kernel command-line](../kernel.md#cmdline). As an example, adding
`single` to the kernel command line will boot the `single` runsvdir.

### Basic Usage

To start, stop, restart or get the status of a service:

```
# sv up <services>
# sv down <services>
# sv restart <services>
# sv status <services>
```

The `<services>` placeholder can be:

- Service names (service directory names) inside the `/var/service/` directory.
- The full paths to the services.

For example, the following commands show the status of a specific service and of
all enabled services:

```
# sv status dhcpcd
# sv status /var/service/*
```

See [sv(8)](https://man.voidlinux.org/sv.8) for further information.

#### Enabling Services

Void Linux provides service directories for most daemons in `/etc/sv/`.

To enable a service on a booted system, create a symlink to the service
directory in `/var/service/`:

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

The `down` file mechanism also makes it possible to disable services that are
enabled by default, such as the [agetty(8)](https://man.voidlinux.org/agetty.8)
services for ttys 1 to 6. This way, package updates which affect these services
(in this case, the `runit-void` package) won't re-enable them.

#### Disabling Services

To disable a service, remove the symlink from the running runsvdir:

```
# rm /var/service/<service>
```

Or, for example, from the `default` runsvdir, if either the specific runsvdir,
or the system, is not currently running:

```
# rm /etc/runit/runsvdir/default/<service>
```

#### Testing Services

To check if a service is working correctly when started by the service
supervisor, run it once before fully enabling it:

```
# touch /etc/sv/<service>/down
# ln -s /etc/sv/<service> /var/service/
# sv once <service>
```

If everything works, remove the `down` file to enable the service.
