# Per-User Services

Sometimes it would be nice to have user-specific runit services. Services that,
for example, open an ssh tunnel as your current user, run a virtual machine, or
regularly run daemons on your behalf. The most common way to do this to ask a
system-level service to start a
[runsvdir(8)](https://man.voidlinux.org/runsvdir.8) service as your user for
your personal service directory.

As example create a service `/etc/sv/runsvdir-<username>` service with the
following `run` script:

```
#!/bin/sh

exec chpst -u "<username>:$(id -Gn <username> | tr ' ' ':')" runsvdir /home/<username>/service
```

In this example [chpst(8)](https://man.voidlinux.org/chpst.8) is used to start a
new [runsvdir(8)](https://man.voidlinux.org/runsvdir.8) process as the specified
user. [chpst(8)](https://man.voidlinux.org/chpst.8) does not read groups on its
own but expects the user to list all required groups separated by a `:` (colon).
In the previous example the `id` and `tr` pipe is used to create a list of all
the users groups in a way [chpst(8)](https://man.voidlinux.org/chpst.8)
understands it.

The user can then create new service or symlinks to them in the
`/home/<username>/service` directory. To control the services using
[sv(8)](https://man.voidlinux.org/sv.8) command the user can specify the
services by path or by name if the `SVDIR` environment variable is set to the
users service directory as shown in the following examples:

```
$ sv status ~/service/*
run: /home/duncan/service/gpg-agent: (pid 901) 33102s
run: /home/duncan/service/ssh-agent: (pid 900) 33102s
$ export SVDIR=~/service
$ sv restart gpg-agent
ok: run: gpg-agent: (pid 19818) 0s
```
