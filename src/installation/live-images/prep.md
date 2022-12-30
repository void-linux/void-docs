# 准备安装介质

[下载安装镜像](../index.md#下载安装镜像)后，必须将镜像写入可引导的媒介，比如 U 盘、SD 卡或者 CD/DVD。

## 在 Linux 上创建可引导 U 盘或 SD 卡

###  确认设备

在写入镜像前，先确认你要写入的设备。你可以用 [fdisk(8)](https://man.voidlinux.org/man8/fdisk.8)。插入存储设备后，用下面的命令识别设备的路径：

```
# fdisk -l
Disk /dev/sda: 7.5 GiB, 8036286464 bytes, 15695872 sectors
Disk model: Your USB Device's Model
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

上例中，输出显示 USB 设备在 `/dev/sda`。在 Linux 上，USB 设备的路径一般都是 `/dev/sdX`（X 是数字），SD 卡一般都是 `/dev/mmcblkX`，具体路径取决于设备。如果你不确定你设备的路径，你可以用型号和空间大小（上例中是 `7.5GiB`）来辨识。


确认你要用的设备之后，确保你的设备 **没有** 被挂载，用 [umount(8)](https://man.voidlinux.org/man8/umount.8) 卸载设备：

```
# umount /dev/sdX
umount: /dev/sdX: not mounted.
```

### 写入 live 镜像


命令 [dd(1)](https://man.voidlinux.org/man1/dd.1)  可以用来将 live 镜像拷贝到存储设备上。用 `dd`，将 live 镜像写入：

**警告！**: 这会删除设备上的所有数据，一定要小心。

```
# dd bs=4M if=/path/to/void-live-ARCH-DATE-VARIANT.iso of=/dev/sdX
90+0 records in
90+0 records out
377487360 bytes (377 MB, 360 MiB) copied, 0.461442 s, 818 MB/s
```

在完成写入（或写入失败）之前，`dd` 不会打印出任何信息。该命令可能需要几分钟或更长时间执行，取决于具体设备。如果你使用 GNU coreutils `dd`，你可以添加 `status=progress` 选项，让 `dd` 在写入过程中输出信息。

最后，在断开与设备连接前，确保数据已完全写入：

```
$ sync
```
写入的数据、写入的文件量、写入速率取决于具体的设备和你选择的 live 镜像。

## 烧录 CD 或 DVD

任何一个光盘烧录应用应该都可以写入 `.iso` 文件到 CD 或 DVD 上。可以用这些自由软件应用（跨平台支持可能不尽相同）：

- [Brasero](https://wiki.gnome.org/Apps/Brasero/)
- [K3B](https://userbase.kde.org/K3b)
- [Xfburn](https://docs.xfce.org/apps/xfburn/start)
- 
注意，用 CD 或 DVD 时，live 会话反应会比用 U 盘或硬盘时迟钝一点。
