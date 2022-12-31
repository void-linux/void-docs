# 安装指南

[下载](../index.md#下载安装媒介)好 Void 镜像，[准备](./prep.md)好安装媒介后，就可以开始安装 Void Linux 了。

正式开始安装前，请确定你的机器是用 BIOS 还是 UEFI 引导开机，这会影响你的分区，详情参考[分区说明](./partitions.md)。

安装器脚本不支持这些功能：

- [LVM](https://en.wikipedia.org/wiki/Logical_volume_management)
- [LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup)
- [ZFS](https://en.wikipedia.org/wiki/ZFS)

## 引导

从你的安装媒介上引导启动，如果你的内存够大，可以在引导界面上选择把整个镜像加载到内存中，这会花费一些时间，但可以加速整个安装过程。

引导好 live 镜像后，以 `root` 登录，密码是 `voidlinux`，运行：

```
# void-installer
```

下面的章节将详述安装器的每个界面：

## 键盘

选择你键盘的映射；标准的“qwerty”键盘一般使用“us”映射。

## 网络


选择你的主网络接口，如果你选择不使用 DHCP，你会被要求输入 IP 地址、网关和 DNS 服务器。

If you choose a wireless network interface, you will be prompted to provide the
SSID, encryption type (`wpa` or `wep`), and password. If `void-installer` fails
to connect to your network, you may need to exit the installer and configure it
manually using [wpa_supplicant](../../config/network/wpa_supplicant.md) and
[dhcpcd](../../config/network/index.md#dhcpcd) before continuing.

如果您选择无线网络接口，系统将提示您提供 SSID、加密类型(`wpa` 要么 `wep`), 和密码。果 `void-installer` 失败要连接到您的网络，您可能需要退出安装程序并进行配置手动使用 [wpa_supplicant](../../config/network/wpa_supplicant.md) 和 [dhcpcd](../../config/network/index.md#dhcpcd) 在继续之前。 

## 安装源

要安装镜像上提供的软件包，选择 `Local`。或者你也可以选择 `Network`，来从 Void 仓库下载最新的软件包。

> **警告:** 如果你要从 xfce 像上安装桌面环境，你**必须**选择 `Local` 安装源。

## 主机名

选择设备的主机名（全部小写，没有空格）。

## 语言环境

设置你的地区，只有 glibc 有这个选项，因为 musl 目前不支持地区。

## 时区

基于标准时区选择你的时区。
## Root 密码

输入并确认你新系统的 `root` 密码，密码不会在屏幕上显示出来。

## 用户账户

选择一个登录账户（默认是 `void`）并为你的账户起一个描述性的名字。然后输入并确认新用户的密码，接下来你会被要求确认新用户的用户组。默认会将新用户加入 `wheel` 用户组，并有 `sudo` 权限。默认用户组和说明请查看[这里](../../config/users-and-groups.html#default-groups)。

登录名有一些限制，在
[useradd(8)](https://man.voidlinux.org/useradd.8#CAVEATS).

## 引导程序

安装 Void 时，选择安装引导程序的硬盘，你可以选择 `none` 跳过这个步骤，然后在安装过程完成后手动安装引导程序。如果你选择自动安装引导程序，你会被要求选择是否要为 GRUB 菜单添加一个图形终端。

## 分区

然后你需要为你的硬盘分区。Void 不提供预设分区方案，所以你需要用 [cfdisk(8)](https://man.voidlinux.org/cfdisk.8) 手动分区。界面会展示硬盘的列表，选择你想要分区的硬盘，安装器会启动 `cfdisk`。记得在推出分区编辑器前写入分区表。

如果使用 UEFI，建议你选择 GPT 作为分区表，创建一个类型为 `EFI System` 的分区（通常大小是 200MB-1GB），该分区会被挂载到 `/boot/efi`。

如果使用 BIOS，建议你选择 MBR 作为分区表。进阶用户可能会想要用 GPT 作为分区表，记得为 GRUB [创建一个特殊的 BIOS 分区](/partitions.md#bios系统笔记)

## 文件系统

为每个你创建的分区创建文件系统。你会被要求为每个分区选择文件系统、是否创建文件系统和可用的挂载点。完成后选择 `Done`，返回主菜单。

如果使用 UEFI，创建一个 `vfat` 文件系统，挂载到 `/boot/efi`。

## 检查设定

在继续之前，最好重审一下你的设定。使用右方向键选择设置按钮，按下 `<enter>`。程序会展示你的所有选择，以供检查。

## 安装

在菜单上选择 `Install`，开始安装。安装器会创建所有选择的文件系统、安装基础系统软件包、生成 initramfs 并安装 GRUB2 引导器到引导分区。

这些步骤会自动进行，安装结束后你就可以重启进入新 Void Linux 了！

## 安装之后

重启到新 Void 后，[进行系统更新](../../xbps/index.md#updating)。

