# Services and Daemons

Void uses the [runit(8)](https://man.voidlinux.org/runit.8) supervision suite to
run system services and daemons.

Some advantages of using runit include:

- a small code base, making it easier to audit for bugs and security issues.
- each service is given a clean process state, regardless of how the service was
   started or restarted: it will be started with the same environment, resource
   limits, open file descriptors, and controlling terminals.
- a reliable logging facility for services, where the log service stays up as
   long as the relevant service is running and possibly writing to the log.

## Section Contents

- [Managing Services](./managing.md)
- [Per-User Services](./user-services.md)

## Service directories

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

### Configuring services

Most services can take configuration options set by a `conf` file in the service
directory. This allows service customization without modifying the service
directory provided by the relevant package.

Check the service file for how to pass configuration parameters. Services
usually expect `OPTS="--value ..."` in the `conf` file.

To make more complex customizations than provided by default, [edit the
service](#editing-services).

### Editing services

To edit a service, first copy its service directory to a different directory
name, otherwise [xbps-install(1)](https://man.voidlinux.org/xbps-install.1) can
overwrite the service directory. Then, edit the new service file as needed.
Finally, the old service should be stopped and disabled, and the new one should
be started.

## Logging

### Syslog

The default installation comes with no syslog daemon. However, there are syslog
implementations available in the Void repositories.

#### Socklog

[socklog(8)](https://man.voidlinux.org/socklog.8) is a syslog implementation
from the author of [runit(8)](https://man.voidlinux.org/runit.8). Use socklog if
you're not sure which syslog implementation to use. To use it, install the
`socklog-void` package, and enable the `socklog-unix` and `nanoklogd` services.

The logs are saved in sub-directories of `/var/log/socklog/`, and `svlogtail`
can be used to help access them conveniently.

The ability to reading logs is limited to `root` and users who are part of the
`socklog` group.

#### Other syslog daemons

The Void repositories also include packages for `rsyslog` and `metalog`.

## Console

### Disabling default ttys

Void enables [agetty(8)](https://man.voidlinux.org/agetty.8) services for `ttys`
1 to 6 by default.

To disable agetty services, remove the service symlink and create a `down` file
in the agetty service directory to avoid that updates of the `runit-void`
package re-enable the service.

```
# unlink /var/service/agetty-tty6
# touch /etc/sv/agetty-tty6/down
```
