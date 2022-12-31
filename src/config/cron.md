# Cron

[cron](https://en.wikipedia.org/wiki/Cron) 是按一定时间间隔运行程序的守护进程。运行的程序和时间间隔可以通过 `crontab` 文件设定，可以用 [crontab(1)](https://man.voidlinux.org/crontab.1) 编辑 crontab 文件。以超级用户运行 `crontab -e` 编辑系统 crontab；否则就是编辑当前用户的 crontab。

Void 预设没有安装 cron 守护进程，但 Void 提供了多种 cron 实现，包括 [cronie](https://github.com/cronie-crond/cronie/)、[dcron](http://www.jimpryor.net/linux/dcron.html)、[fcron](http://fcron.free.fr/)等等。

选择 cron 实现并安装，[启用](./services/index.md#enabling-services)对应的服务。这些实现都提供了通用的 `crond` 服务，但使用它并没有什么好处，只会让你的系统设定更加困难。

作为标准 cron 实现的替代，你可以使用 `snooze` 软件包提供的 [snooze(1)](https://man.voidlinux.org/snooze.1)，以及 `snooze-hourly`、`snooze-daily`、`snooze-weekly`、`snooze-monthly` 服务。这些服务对应 `/etc/cron.*` 中的目录。
