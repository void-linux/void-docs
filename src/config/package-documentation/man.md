# 手册页

许多 Void 软件包都提供了手册（'man'）页。`mdocml` 软件包包含了 [mandoc](https://mandoc.bsd.lv/) Man 手册页工具组。

用 [man(1)](https://man.voidlinux.org/man.1)  命令显示手册页：

```
$ man chroot
```
手册页都隶属于下面这些*章节*：

1. 用户命令（程序）
2. 系统调用
3. 库调用
4. 特殊文件（设备）
5. 文件格式与配置文件
6. 游戏
7. 概览、惯例以及杂项
8. 系统管理命令

详情参见 [man-pages(7)](https://man.voidlinux.org/man-pages.7)。

有些内容不同的手册页拥有相同的名字，它们属于不同的章节。你可以在执行 `man` 时指定章节：

```
$ man 1 printf
```

用 [man.conf(5)](https://man.voidlinux.org/man.conf.5) 配置 `man`。

`mandoc` 工具组包含了用来搜索手册页的 [apropos(1)](https://man.voidlinux.org/apropos.1)。可以用 [makewhatis(8)](https://man.voidlinux.org/makewhatis.8) 命令来生成和更新 `apropos` 的数据库：

```
# makewhatis
$ apropos chroot
chroot(1) - run command or interactive shell with special root directory
xbps-uchroot(1) - XBPS utility to chroot and bind mount with Linux namespaces
xbps-uunshare(1) - XBPS utility to chroot and bind mount with Linux user namespaces
chroot(2) - change root directory
```

`mdocml` 软件包提供了每天更新 `apropos` 数据库的 cron 任务：`/etc/cron.daily/makewhatis`。要使用这个功能，你需要安装并启用 [cron 守护进程](../cron.md) 。

Void 默认不会安装开发与 POSIX 手册，但可以通过 `man-pages-devel` 与 `man-pages-posix` 软件包获得这些手册。

## 本地化手册页

`manpages-*` 软件包们提供了本地化的 Man 手册页，但使用这些 Man 手册页可能需要一些额外的配置。

### 用 mdocml

如果使用了 `mdocml`，且设置应该应用于所有用户，那么必须将相关的路径添加到 [man.conf(5)](https://man.voidlinux.org/man.conf.5)。例如，德语使用者会把这两行加入配置文件：

```
/usr/share/man/de
/usr/share/man/de.UTF-8
```

另外，各用户可以导出 `MANPATH` 变量到自己的环境中，详见 [man(1)](https://man.voidlinux.org/man.1)。
