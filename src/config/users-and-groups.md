# Users and groups

## Default groups

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
