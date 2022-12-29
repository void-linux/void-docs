# 关于本手册

本手册不是关于如何使用和配置常见 Linux 软件的大而全的指南。本文档的目标是说明如何安装、配置、维护 Void Linux 系统，重点叙述一般 Linux 发行版于 Void 的区别。
点击“放大镜”图标或按下“s”，在本手册中搜索。
要查找配置一般 Linux 系统的提示或技巧，请去参考上游软件的文档。另外，[Arch Wiki](https://wiki.archlinux.org/) 提供了相当全面的常见 Linux 软件配置概述，也请灵活运用各种搜索引擎。

## 阅读 Man 手册
本手册没有巨细无遗的配置指导，但本手册尽可能地提供了相关 [man 手册页](https://man.voidlinux.org/)的链接。
运行命令 `man man` 学习如何使用 man 手册页查看器。编辑 `/etc/man.conf` 配置 man；详情参考 [man.conf(5)](https://man.voidlinux.org/man.conf.5)。
Void 使用 [mandoc](https://mandoc.bsd.lv/) 工具组生成 man 手册页。“mdocml”是 mandoc 的曾用名，mandoc 由 `mdocml` 软件包提供。

## 命令样例

本手册中会展示在命令行中运行的代码片段作为例子。这些例子中，以 `$` 开头的行代表以普通用户运行的命令，以 `#` 开头的行代表以 `root` 运行的命令。命令之后可能会紧跟着几行该命令的输出样例。


### 占位符

一些例子会包括占位符，你应该用合适的信息替换占位符，比如：

```
# ln -s /etc/sv/<service_name> /var/service/
```

这表示你需要用实际的服务名称替换 `<service_name>`。

