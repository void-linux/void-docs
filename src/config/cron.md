# Cron

[cron](https://en.wikipedia.org/wiki/Cron) is a daemon for running programs at
regular intervals. The programs and intervals are specified in a `crontab` file,
which can be edited with [crontab(1)](https://man.voidlinux.org/crontab.1).
Running `crontab -e` as the superuser will edit the system crontab; otherwise,
it will edit the crontab for the current user.

By default, a cron daemon is not installed. However, multiple cron
implementations are available, including
[cronie](https://github.com/cronie-crond/cronie/),
[dcron](http://www.jimpryor.net/linux/dcron.html),
[fcron](http://fcron.free.fr/) and more.

Once you have chosen and installed an implementation,
[enable](./services/index.md#enabling-services) the `crond` service, which is a
symlink to the actual service (e.g. `dcron`). If you install several
implementations, you can choose which one to use via
[xbps-alternatives(1)](https://man.voidlinux.org/xbps-alternatives.1); this will
alter the `crond` symlink appropriately. Implementation documentation will be
available in [crond(8)](https://man.voidlinux.org/crond.8).

As an alternative to the standard cron implementations, you can use
[snooze(1)](https://man.voidlinux.org/snooze.1) together with the
`snooze-hourly`, `snooze-daily`, `snooze-weekly` and `snooze-monthly` services,
which are provided by the `snooze` package for this purpose. Each of these
services execute scripts in the respective `/etc/cron.*` directories.
