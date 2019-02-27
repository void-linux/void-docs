# Logging

## Syslog

The default installation comes with no syslog daemon, there are different
implementations available.

[socklog](http://smarden.org/socklog/) is the implementation from the
[runit(8)](https://man.voidlinux.org/runit.8) author and Void Linux provides a
package with some basic configuration for it, this makes it a good choice if you
don't know which one to choose.

```
# xbps-install -S socklog-void
# usermod -aG socklog <your username>
# ln -s /etc/sv/socklog-unix /var/service/
# ln -s /etc/sv/nanoklogd /var/service/
```

Other syslog implementations like `rsyslog` and `metalog` are available in the
package repository too.
