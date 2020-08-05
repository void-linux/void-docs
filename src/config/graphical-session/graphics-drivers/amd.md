# AMD or ATI

AMD GPU support requires the `linux-firmware-amd` package. If you have installed
the `linux` or `linux-lts` packages, it will be installed as a dependency. If
you installed a version-specific kernel package (e.g., `linux5.4`), it may be
necessary to manually install `linux-firmware-amd`.

## OpenGL

Install the Mesa DRI package, `mesa-dri`. This is already included in the `xorg`
meta-package, but it is needed when installing Xorg via `xorg-minimal` or for
running a Wayland compositor.

## Vulkan

Install `vulkan-loader`, the Khronos Vulkan Loader. Then install one or both of
the Mesa AMD Vulkan driver, `mesa-vulkan-radeon`; or the GPUOpen AMD Vulkan
driver, `amdvlk`.

## Xorg

Installing the `xorg` meta-package will pull in both `xf86-video-amdgpu` and,
for older hardware, `xf86-video-ati`. If you install `xorg-minimal`, choose one
of these Xorg driver packages to match your hardware. The `amdgpu` driver should
support cards built on AMD's "Graphics Core Next 1.2" architecture, introduced
circa 2012.

## Video acceleration

Install the `mesa-vaapi` and `mesa-vdpau` packages.
