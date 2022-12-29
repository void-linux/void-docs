# 安装

本章包括安装 Void 的一般流程。对于特殊的情况，参考[《进阶安装》](./guides/index.md)一节

## 基本系统要求

尽管 Void 对硬件的要求很低，我们还是建议在比下述配置更高的系统上安装：

| Architecture | CPU              | RAM  | Storage |
|--------------|------------------|------|---------|
| x86_64-glibc | x86_64           | 96MB | 700MB   |
| x86_64-musl  | x86_64           | 96MB | 600MB   |
| i686-glibc   | Pentium 4 (SSE2) | 96MB | 700MB   |

请注意，xfce 映像安装需要更多资源。 

Void 不支持 i386、i486 或 i586 架构。

在安装 musl Void 前，请阅读本手册的 [musl](./musl.md) 一章，以了解软件的不兼容信息。

安装过程不需要连接网络，但还是非常建议在安装过程中连接网络以下载更新。ISO 镜像包含了安装系统所需要的数据，可以在无网络连接时安装。

## 下载安装介质

最近的 live 镜像和 rootfs 压缩包可以从 https://repo-default.voidlinux.org/live/current/ 下载，也可以从[其他镜像](https://docs.voidlinux.org/xbps/repositories/mirrors/index.html)下载。以日期排列的历史发布可以在 https://repo-default.voidlinux.org/live/ 找到。

##  验证镜像

每个镜像发布目录都包含两个用来验证镜像的文件。一个 `sha256sum.txt` 文件包含了镜像的校验和，可以用来验镜像的完整性。另有一个 `sha256sum.sig` 文件，用来检查校验和的真实性。

有必要验证镜像的完整性和真实性，因此建议也下载 `sha256sum.txt` 和 `sha256sum.sig` 两个文件。

### 验证镜像完整性


你可以用 [sha256sum(1)](https://man.voidlinux.org/sha256sum.1) 和上述的 `sha256sum.txt` 文件验证下载文件的完整性。下面的命令会检查你已下载镜像的完整性：

```
$ sha256sum -c --ignore-missing sha256sum.txt
void-live-x86_64-musl-20170220.iso: OK
```

以上输出说明镜像没有损坏。

### 验证数字签名

强烈建议在使用镜像前，先验证镜像的签名，确保镜像文件没有被篡改。

目前镜像都由用于发布的 siginfy 密钥签名。如果你已经在使用 Void 系统，你可以从 `void-release-keys` 软件包获取密钥，XBPS。你还需要 [signify(1)](https://man.voidlinux.org/signify.1) 或 [minisign(1)](https://man.voidlinux.org/minisign.1) 的拷贝；在 Void 系统上，它们分别由 `outils` 或 `minisign` 软件包提供。

在不是 Void Linux 的 Linux 发行版上获取 `signify`：

- 在 Arch Linux 和基于 Arch 的发行版上，安装 `signify` 软件包。
- 在 Debian 和基于 Debian 的发行版上，安装 `signify-openbsd` 软件包。
- 为你的的发行版安装[这里](https://repology.org/project/signify-openbsd/versions)列出的软件包。
- 在 macOS 上，用 homebrew 安装 `signify-osx`。

`minisign` 可执行程序一般由同名的软件包提供，即使没有 WSL 或 MinGW 也应该可以在 Windows 上安装。

如果你不在使用 Void Linux，也有必要从[我们的 Git 仓库](https://github.com/void-linux/void-packages/tree/master/srcpkgs/void-release-keys/files/)取得相应的签名密钥。

取得了密钥后就可以用 `sha256sum.sig` 和 `sha256sum.txt` 文件检验镜像文件。首先你需要验证 `sha256sum.txt` 文件的正确性。


下面的例子演示了 `sha256sum.txt` 文件的校验 
对于 20210930 图像。   首先，使用 `signify`  ： 

```
$ signify -V -p /etc/signify/void-release-20210930.pub -x sha256sum.sig -m sha256sum.txt
Signature Verified
```

其次，用 `minisign`：

```
$ minisign -V -p /etc/signify/void-release-20210930.pub -x sha256sum.sig -m sha256sum.txt
Signature and comment signature verified
Trusted comment: timestamp:1634597366	file:sha256sum.txt
```
最后，你需要检查镜像文件的校验和，于 `sha256sum.txt` 中的校验和做比较。你可以利用 [sha256(1)](https://man.voidlinux.org/md5.1) 工具，此程序依然来自 `outils` 软件包。下面演示如何验证 20210930 `x86_64` 镜像：

```
$ sha256 -C sha256sum.txt void-live-x86_64-20210930.iso
(SHA256) void-live-x86_64-20210930.iso: OK
```

另外，如果你无法使用 `sha256` 工具，你可以计算 SHA256 哈希，比如用 [  sha256sum(1)  ](https://man.voidlinux.org/sha256sum.1) 计算哈希，然后用 `sha256sum.txt` 中的值比较：

```
$ sha256sum void-live-x86_64-20210930.iso
45b75651eb369484e1e63ba803a34e9fe8a13b24695d0bffaf4dfaac44783294  void-live-x86_64-20210930.iso
$ grep void-live-x86_64-20210930.iso sha256sum.txt
SHA256 (void-live-x86_64-20210930.iso) = 45b75651eb369484e1e63ba803a34e9fe8a13b24695d0bffaf4dfaac44783294
```


如果验证过程没有产生期望中的“OK”状态，不要使用这个镜像！请警告 Void Linux 团队，附上你取得该镜像的地址和你检验镜像的方法，我们会跟进此事。
