# Cron

Void Linux comes without a default cron daemon, you can choose one of multiple
cron implementations, by installing the package and enabling the system service.

Available choices include [cronie](https://github.com/cronie-crond/cronie/),
[dcron](http://www.jimpryor.net/linux/dcron.html),
[fcron](http://fcron.free.fr/) and more.

As alternative to the standard cron implementations you can use something like
[snooze](https://github.com/leahneukirchen/snooze) or
[runwhen](http://code.dogmap.org/runwhen/) which go hand in hand with service
supervision.
