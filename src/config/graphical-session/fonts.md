# Fonts

To customize font display in your graphical session, you can use configurations
provided in `/usr/share/fontconfig/conf.avail/`. To do so, create a symlink to
the relevant `.conf` file in `/etc/fonts/conf.d/`, then use
[xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) to
reconfigure the `fontconfig` package.

For example, to disable use of bitmap fonts:

```
# ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
# xbps-reconfigure -f fontconfig
```
