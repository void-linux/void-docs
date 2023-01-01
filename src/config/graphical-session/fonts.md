# 字体

为了在你的图形会话中定制字体显示，您可以使用 `/usr/share/fontconfig/conf.avail/` 中提供的配置。为此，在 `/etc/fonts/conf.d/` 中创建一个指向相关 `.conf` 文件的符号链接，然后使用 [xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) 来重新配置 `fontconfig` 包。

例如，禁用 bitmap 字体:

```
# ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
# xbps-reconfigure -f fontconfig
```

使用 [fc-conflist(1)](https://man.voidlinux.org/fc-conflist.1) 来列出哪些配置是有效的。
