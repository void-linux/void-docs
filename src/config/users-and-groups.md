# 用户和用户组

[useradd(8)](https://man.voidlinux.org/useradd.8), [userdel(8)](https://man.voidlinux.org/userdel.8) 和 [usermod(8)](https://man.voidlinux.org/usermod.8) 命令分别用来添加、删除和修改用户。passwd(1)命令用来修改密码。

[groupadd(8)](https://man.voidlinux.org/groupadd.8) 、 [groupdel(8)](https://man.voidlinux.org/groupdel.8) 和 [groupmod(8)](https://man.voidlinux.org/groupmod.8) 命令分别用来添加、删除和修改组。[groups(1)](https://man.voidlinux.org/groups.1) 命令列出一个用户所属的所有组。

## 默认 shell

用户的默认shell可以用 [chsh(1)](https://man.voidlinux.org/chsh.1) 来更改。

```
$ chsh -s <shell> <user_name>
```
`<shell>` 必须是指定的 shell 的路径 `/etc/shells` 或者输出 `chsh -l`，它提供了已安装 shell 的列表。

## sudo

[sudo(8)](https://man.voidlinux.org/sudo.8) 是默认安装的。但可能没有根据您的需要进行适当配置。如果你想使用它，请配置 sudo。。

以 root 身份使用 [visudo(8)](https://man.voidlinux.org/visudo.8)  来编辑 [sudoers(5)](https://man.voidlinux.org/sudoers.5) 文件。

请取消注释该行

```
#%wheel ALL=(ALL) ALL
```

然后将用户添加到 `wheel` 用户组.

## 默认用户组

默认定义的一些组

| Group      | Description                                                   |
|------------|---------------------------------------------------------------|
| `root`     | Complete access to the system.                                |
| `bin`      | Unused - present for historical reasons.                      |
| `sys`      | Unused - present for historical reasons.                      |
| `kmem`     | Ability to read from `/dev/mem` and `/dev/port`.              |
| `wheel`    | Elevated privileges for specific system administration tasks. |
| `tty`      | Access to TTY-like devices:                                   |
|            | `/dev/tty*`, `/dev/pts*`, `/dev/vcs*`.                        |
| `tape`     | Access to tape devices.                                       |
| `daemon`   | System daemons that need to write to files on disk.           |
| `floppy`   | Access to floppy drives.                                      |
| `disk`     | Raw access to `/dev/sd*` and `/dev/loop*`.                    |
| `lp`       | Access to printers.                                           |
| `dialout`  | Access to serial ports.                                       |
| `audio`    | Access to audio devices.                                      |
| `video`    | Access to video devices.                                      |
| `utmp`     | Ability to write to `/var/run/utmp`, `/var/log/wtmp`          |
|            | and `/var/log/btmp`.                                          |
| `adm`      | Unused - present for historical reasons. This group was       |
|            | traditionally used for system monitoring, such as viewing     |
|            | files in `/var/log`.                                          |
| `cdrom`    | Access to CD devices.                                         |
| `optical`  | Access to DVD/CD-RW devices.                                  |
| `mail`     | Used by some mail packages, e.g. `dma`.                       |
| `storage`  | Access to removable storage devices.                          |
| `scanner`  | Ability to access scanners.                                   |
| `network`  | Unused - present for historical reasons.                      |
| `kvm`      | Ability to use KVM for virtual machines, e.g. via QEMU.       |
| `input`    | Access to input devices: `/dev/mouse*`, `/dev/event*`.        |
| `plugdev`  | Access to pluggable devices.                                  |
| `nogroup`  | System daemons that don't need to own any files.              |
| `usbmon`   | Access to `/dev/usbmon*`.                                     |
| `users`    | Ordinary users.                                               |
| `xbuilder` | To use xbps-uchroot(1) with `xbps-src`.                       |
