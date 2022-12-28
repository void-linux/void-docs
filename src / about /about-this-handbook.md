# 关于本手册


本手册不是关于如何使用和配置常见 Linux 软件的大而全的指南。本文档的目标是说明如何安装、配置、维护 Void Linux 系统，重点叙述一般 Linux 发行版于 Void 的区别。

点击“放大镜”图标或按下“s”，在本手册中搜索。

要查找配置一般 Linux 系统的提示或技巧，请去参考上游软件的文档。另外，[Arch Wiki](https://wiki.archlinux.org/) 提供了相当全面的常见 Linux 软件配置概述，也请灵活运用各种搜索引擎。

## 阅读 Man 手册

本手册没有巨细无遗的配置指导，但本手册尽可能地提供了相关 [man 手册页](https://man.voidlinux.org/)的链接。

运行命令 `man man` 学习如何使用 <Man to="man/1" /> man 手册页查看器。编辑 `/etc/man.conf` 配置 man；详情参考 <Man to="man.conf/5" />。

Void 使用 [mandoc](https://mandoc.bsd.lv/) 工具组生成 man 手册页。“mdocml”是 mandoc 的曾用名，mandoc 由 `mdocml` 软件包提供。

## Example Commands

Examples in this guide may have snippets of commands to be run in your shell.
When you see these, any line beginning with `$` is run as your normal user.
Lines beginning with `#` are run as `root`. After either of these lines, there
may be example output from the command.

### Placeholders

Some examples include text with placeholders. Placeholders indicate where you
should substitute the appropriate information. For example:

```
# ln -s /etc/sv/<service_name> /var/service/
```

This means you need to substitute the text `<service_name>` with the actual
service name.
