# 日志

## Syslog

默认安装没有配备 syslog 守护程序。但是，在 Void 软件库里有 syslog 的实现。

### Socklog

[socklog(8)](https://man.voidlinux.org/socklog.8) 是 [runit(8)](https://man.voidlinux.org/runit.8) 的作者提供的一个 syslog 实现。如果你不确定要使用哪种系统日志实现，就使用 socklog 。要启用它，请安装 `socklog-void` 软件包并启用 `socklog-unix` 和 `nanoklogd` 服务。确保没有其他的 syslog 守护程序在运行。

日志被保存在 `/var/log/socklog/` 的子目录中，可以用 `svlogtail` 来访问它们。


读取日志的权限仅限于 `root` 和属于 `socklog` 组的用户。 

### 其他系统日志守护进程

Void 软件库还包括用于 `rsyslog` 和 `metalog`. 
