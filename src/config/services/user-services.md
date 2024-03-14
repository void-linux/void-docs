# Per-User Services

Sometimes it can be nice to have user-specific runit services. For example, you
might want to open an ssh tunnel as the current user, run a virtual machine, or
regularly run daemons on your behalf. The most common way to do this is to
create a system-level service that runs
[runsvdir(8)](https://man.voidlinux.org/runsvdir.8) as your user, in order to
start and monitor the services in a personal services directory.

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

## Example services

A common pattern when setting up services used by other applications is to setup
the socket / port in a fixed location and then create an environmental variable
for the user session that refers to it.

### SSH Agent

In this example, ssh-agent puts information into ~/.ssh/ssh-agent-env to be
read.

```
#!/bin/sh

exec > ~/.ssh/ssh-agent-env
exec ssh-agent -D
```

For example, if using bash, adding `source ~/.ssh/ssh-agent-env` to `~/.bashrc`
will populate the environmental variables to be picked up by ssh.

### D-Bus Session

Instead of the system D-Bus, applications sometimes require a session D-Bus. A
session D-Bus sets `DBUS_SESSION_BUS_ADDRESS` in the user environment for
applications. In this example, we set the socket to be the service directory and
then setup `.profile` to populate it for the user session.

```
#!/bin/sh
set -eu
exec 2>&1

exec dbus-daemon --nofork --nopidfile --nosyslog --session --address="unix:path=`pwd`/sock"
```

To make this socket available in the user session, it needs to be loaded on the
start of the users session. For example, when using lightdm the following could
be added to `~/.profile`.

```
export DBUS_SESSION_BUS_ADDRESS="unix:path=$HOME/<path_to_user_dbus_service/sock"
```
