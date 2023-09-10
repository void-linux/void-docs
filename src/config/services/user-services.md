# Per-User Services

Sometimes it can be nice to have user-specific runit services. For example, you
might want to open an ssh tunnel as the current user, run a virtual machine, or
regularly run daemons on your behalf.

## runsvdir

The most basic way to do this is to create a system-level service that runs
[runsvdir(8)](https://man.voidlinux.org/runsvdir.8) as your user, in order to
start and monitor the services in a personal services directory. This does have
limitations and downsides, though, as per-user services are started at boot and
do not have access to things like the user's graphical session or D-Bus session
bus.

For example, you could create a service called `/etc/sv/runsvdir-<username>`
with the following `run` script, which should be executable:

```
#!/bin/sh

export USER="<username>"
export HOME="/home/<username>"

groups="$(id -Gn "$USER" | tr ' ' ':')"
svdir="$HOME/service"

exec chpst -u "$USER:$groups" runsvdir "$svdir"
```

In this example [chpst(8)](https://man.voidlinux.org/chpst.8) is used to start a
new [runsvdir(8)](https://man.voidlinux.org/runsvdir.8) process as the specified
user. [chpst(8)](https://man.voidlinux.org/chpst.8) does not read groups on its
own, but expects the user to list all required groups separated by a `:`. The
`id` and `tr` pipe is used to create a list of all the user's groups in a way
[chpst(8)](https://man.voidlinux.org/chpst.8) understands it. Note that we
export `$USER` and `$HOME` because some user services may not work without them.

The user can then create new services or symlinks to them in the
`/home/<username>/service` directory. To control the services using the
[sv(8)](https://man.voidlinux.org/sv.8) command, the user can specify the
services by path, or by name if the `SVDIR` environment variable is set to the
user's services directory. This is shown in the following examples:

```
$ sv status ~/service/*
run: /home/duncan/service/gpg-agent: (pid 901) 33102s
run: /home/duncan/service/ssh-agent: (pid 900) 33102s
$ SVDIR=~/service sv restart gpg-agent
ok: run: gpg-agent: (pid 19818) 0s
```

It may be convenient to export the `SVDIR=~/service` variable in your shell
profile.

## turnstile

[Turnstile](https://github.com/chimera-linux/turnstile) supports running
per-user services that start with the user session using either runit or
[dinit(8)](https://man.voidlinux.org/man8/dinit.8).

If using the runit service backend, user services should be placed in
`~/.config/service/`.

To ensure that a subset of services are started before login can proceed, these
services can be listed in `~/.config/service/turnstile-ready/conf`, for example:

```
core_services="dbus foo"
```

The `turnstile-ready` service is created by turnstile on first login.

To give user services access to important environment variables,
[chpst(8)](https://man.voidlinux.org/chpst.8)'s envdir functionality can be
used. Inside user services, the convenience variable `TURNSTILE_ENV_DIR` can be
used to refer to this directory.

To make a service aware of these variables, wrap the `exec` line with `chpst -e
"$TURNSTILE_ENV_DIR"`:

```
exec chpst -e "$TURNSTILE_ENV_DIR" foo
```

The helper script `turnstile-update-runit-env` can be used to update variables
in this shared envdir:

```
$ turnstile-update-runit-env DISPLAY XAUTHORITY FOO=bar BAZ=
```

To run the [D-Bus session bus](../session-management.md#d-bus) using a
turnstile-managed user service:

```
$ mkdir -p ~/.config/service/dbus
$ ln -s /usr/share/examples/turnstile/dbus.run ~/.config/service/dbus/run
```
