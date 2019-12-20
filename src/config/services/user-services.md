# Per-User Services

Sometimes it would be nice to have user-specific runit services. Services that,
for example, open an ssh tunnel as your current user, run a virtual machine, or
regularly run daemons on your behalf. The most common way to do this to ask a
system-level runsv daemon to start a runsvdir daemon as your user for your
personal service directory.

As example create a service `/etc/sv/runsvdir-<username>` with the `run` script as shown
below:

```
#!/bin/sh

chpst -u "<username>:$(id -Gn <username> | tr ' ' ':')" runsvdir /home/<username>/service
```

Then you can create runit services and symlink them under
`/home/<username>/service`. The `chpst` command will run `runsvdir` as your
specified user and the `runsvdir` process can then start, monitor your user
services as the user specified.

The part following the `:` (colon) in the `-u` flag specify the groups the user
is part of, `chpst` itself doesn't initialize secondary groups, the example
`run` script uses the `id`/`tr` pipe to make a list of all the groups the
specified user is part of that `chpst` understands. You can leave this out and
just specify the username but in general initializing all groups is more
desirable.
