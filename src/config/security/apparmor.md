# AppArmor

AppArmor 是一种强制性的访问控制机制（如 SELinux ）。它可以根据预先定义或生成的策略来约束程序。

Void 附带了一些用于多种服务的默认配置文件，例如 `dhcpcd` 和 `wpa_supplicant`。 `LXC` 和 `podman` 等容器运行时与 AppArmor 可提高容器 payloads 的安全性。 

要在系统上使用 AppArmor，必须： 

1. 安装 `apparmor` 软件包。
2. 在内核 commandline 上写 `apparmor=1 security=apparmor`

要完成第二步请看 [the documentation on how to modify the
kernel cmdline](./../kernel.md#cmdline).

The `APPARMOR` variable in `/etc/default/apparmor` controls how profiles will be
loaded at boot, the value is set to `complain` by default and corresponds to
AppArmor modes (`disable`, `complain`, `enforce`).

`/etc/default/apparmor` 中的 `APPARMOR` 变量控制启动时如何加载配置文件，该值默认设置为 `complain` ，对应于 AppArmor模式（`disable`, `complain`, `enforce`）。

AppArmor 工具 [aa-genprof(8)](https://man.voidlinux.org/aa-genprof.8) 和 [aa-logprof(8)](https://man.voidlinux.org/aa-logprof.8) 需要配置 [syslog](../services/logging.md) 或运行 [auditd(8)](https://man.voidlinux.org/auditd.8) 服务。
