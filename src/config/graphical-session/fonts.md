# Fonts

A number of fonts and font collections are [available from
XBPS](../../xbps/index.md#finding-files-and-packages). `dejavu-fonts-ttf` or
`xorg-fonts` are a good baseline if you're unsure of what to pick.
`noto-fonts-ttf` contains fonts for many languages and scripts. `noto-fonts-cjk`
extends this with fonts for Chinese, Japanese, and Korean, and
`noto-fonts-emoji` provides emojis. `nerd-fonts` provides a number of fonts with
special characters like custom icons included.

Fonts not available from XBPS can be manually installed to either
`/usr/share/fonts` (system-wide) or `~/.local/share/fonts` (per-user).

To customize font display in your graphical session, you can use configurations
provided in `/usr/share/fontconfig/conf.avail/`. To do so, create a symlink to
the relevant `.conf` file in `/etc/fonts/conf.d/`, then use
[xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) to
reconfigure the `fontconfig` package.

For example, to disable use of bitmap fonts:

```
# ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps-except-emoji.conf /etc/fonts/conf.d/
# xbps-reconfigure -f fontconfig
```

Use [fc-conflist(1)](https://man.voidlinux.org/fc-conflist.1) to list which
configurations are in effect.
