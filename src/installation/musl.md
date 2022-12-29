# musl

[musl](https://musl.libc.org/) 是一个致力于轻量、快速、简单、准确的 libc 实现。


Void 官方支持 musl，所有目标平台（除了 i686 的二进制包）都有使用 musl 的版本。另外，所有官方仓库中的兼容软件包不但有 glibc 的版本，还有 musl 链接的二进制文件。


目前，我们提供 musl 的 nonfree 和 debug 子仓库，但不提供 multilib 子仓库。

## 不兼容的软件

musl 对标准的兼容克制而有限，许多常用的平台特定的扩展都没有实现，因此，许多软件需要修改才能编译或正常运行。Void 开发者们会为这些软件打增强可移植性 / 正确性的补丁，希望这些补丁能被软件上游接受。


专有软件往往只支持 glibc 系统，部分专有软件可以通过 [flatpak](../config/external-applications.md#flatpak) 在 musl 系统上运行。具体而言，[NVIDIA 的私有驱动](../config/graphical-session/graphics-drivers/nvidia.md)不支持 musl，评估硬件兼容性时应该考虑到这一点。

### glibc chroot

要求 glibc 的软件可以在 glibc [chroot](../config/containers-and-vms/chroot.md) 中运行。
