# AMD or ATI

AMD GPU支持需要 `linux-firmware-amd` 软件包。如果你已经安装了 `linux` 或 `linux-lts` 软件包，它将作为一个依赖项被安装。如果你安装了一个特定版本的内核包（例如 `linux5.4`），可能需要手动安装 `linux-firmware-amd` 。

## OpenGL

安装 Mesa DRI 软件包，`mesa-dri`。这已经包含在 `xorg` 元包中了，但在通过 `xorg-minimal` 安装 Xorg 或运行 Wayland 合成器时需要它。

## Vulkan

安装 `vulkan-loader`。然后安装Mesa AMD Vulkan驱动，`mesa-vulkan-radeon` ；或者 GPUOpen AMD Vulkan 驱动，`amdvlk`。

## Xorg

Installing the `xorg` meta-package will pull in both `xf86-video-amdgpu` and,
for older hardware, `xf86-video-ati`. If you install `xorg-minimal`, choose one
of these Xorg driver packages to match your hardware. The `amdgpu` driver should
support cards built on AMD's "Graphics Core Next 1.2" architecture, introduced
circa 2012.


安装 `xorg` 元包将安装`xf86-video-amdgpu` ，对于较旧的硬件，安装 `xf86-video-ati`。如果你安装了 `xorg-minimal` ，选择这些Xorg驱动包中的一个来匹配你的硬件。`amdgpu` 驱动应该支持AMD的 "Graphics Core Next 1.2 "架构的显卡，大约在2012年推出。

## 视频加速

请安装 `mesa-vaapi` 和 `mesa-vdpau` 软件包.
