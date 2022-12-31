# 驱动

Void 在软件库中提供了一些固件包。有些固件只有在你启用了 [nonfree](../xbps/repositories/index.md#nonfree) 软件库后才能使用。

## 微码

微码在启动时由 BIOS 加载到 CPU 或 GPU 上，但以后可以由操作系统本身替换。微码的更新可以使 CPU 或 GPU 的行为被修改，以解决某些尚未发现的错误，而不需要更换硬件。

### Intel

安装英特尔微代码包，`intel-ucode`。这个包在非自由软件库中，必须[启用](../xbps/repositories/index.md)它。安装这个包后，有必要重新生成你的 [initramfs](./kernel.md#kernel-hooks)。对于后续的更新，微代码将被自动添加到 initramfs 中。

### AMD

安装 AMD 软件包，`linux-firmware-amd`，其中包含 AMD CPU 和 GPU 的微码。AMD CPU 和 GPU 将自动加载微码，不需要进一步配置

### 确认
`/proc/cpuinfo` 文件在微码下有一些信息，可以用来验证微码的更新。

## 删除驱动

默认情况下，`linuxX.Y` 包和 `base-system` 包会安装一些固件包。没有必要删除未使用的固件包，但如果你想这样做，你可以配置 XBPS 来[忽略](../xbps/advanced-usage.md#ignoring-packages)这些包，然后删除它们。

