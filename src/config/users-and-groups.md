# Users and Groups

The [useradd(8)](https://man.voidlinux.org/useradd.8),
[userdel(8)](https://man.voidlinux.org/userdel.8) and
[usermod(8)](https://man.voidlinux.org/usermod.8) commands are used to add,
delete and modify users respectively. The
[passwd(1)](https://man.voidlinux.org/passwd.1) command is used to change
passwords.

The [groupadd(8)](https://man.voidlinux.org/groupadd.8),
[groupdel(8)](https://man.voidlinux.org/groupdel.8) and
[groupmod(8)](https://man.voidlinux.org/groupmod.8) commands are used to add,
delete and modify groups respectively. The
[groups(1)](https://man.voidlinux.org/groups.1) command lists all groups a user
belongs to.

## sudo

> Note: [sudo(8)](https://man.voidlinux.org/sudo.8) is installed by default but
> may not be configured. It is only necessary to configure sudo if you wish to
> use it.

Use [visudo(8)](https://man.voidlinux.org/visudo.8) as root to edit the
[sudoers(5)](https://man.voidlinux.org/sudoers.5) file.

To create a superuser, uncomment the line

```
#%wheel ALL=(ALL) ALL
```

and add users to the `wheel` group.

## Default Groups

Void Linux defines a number of groups by default.

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
| `nogroup`  | System daemons that don't need to own any files.              |
| `users`    | Ordinary users.                                               |
| `xbuilder` | To use xbps-uchroot(1) with `xbps-src`.                       |
