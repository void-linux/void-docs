# Intel

Intel GPU support requires the `linux-firmware-intel` package. If you have
installed the `linux` or `linux-lts` packages, it will be installed as a
dependency. If you installed a version-specific kernel package (e.g.,
`linux5.4`), it may be necessary to manually install `linux-firmware-intel`.

## OpenGL

OpenGL requires the Mesa DRI package, `mesa-dri`. This is provided by the `xorg`
meta-package, but will need to be installed manually when using the
`xorg-minimal` package or running a Wayland compositor.

## Vulkan

Install the Khronos Vulkan Loader and the Mesa Intel Vulkan driver packages,
respectively `vulkan-loader` and `mesa-vulkan-intel`.

## Video acceleration

Install the `intel-video-accel` meta-package:

This will install all the Intel VA-API drivers. `intel-media-driver` will be
used by default, but this choice can be overridden at runtime via the
environment variable `LIBVA_DRIVER_NAME`:

| Driver Package       | Supported GPU Gen | Explicit selection       |
|----------------------|-------------------|--------------------------|
| `libva-intel-driver` | up to Coffee Lake | `LIBVA_DRIVER_NAME=i965` |
| `intel-media-driver` | from Broadwell    | `LIBVA_DRIVER_NAME=iHD`  |

## Troubleshooting

The kernels packaged by Void are configured with
`CONFIG_INTEL_IOMMU_DEFAULT_ON=y`, which can lead to issues with their graphics
drivers, as reported by the [kernel
documentation](https://www.kernel.org/doc/html/latest/x86/iommu.html#graphics-problems).
To fix this, it is necessary to disable IOMMU for the integrated GPU. This can
be done by adding `intel_iommu=igfx_off` to your [kernel
cmdline](../../kernel.md#cmdline). This problem is expected to happen on the
Broadwell generation of internal GPUs. If you have another internal GPU and your
issues are fixed by this kernel option, you should file a bug reporting the
problem to kernel developers.

For newer Intel chipsets, the [DDX](../xorg.md#ddx) drivers may interfere with
correct operation. This is characterized by graphical acceleration not working
and general graphical instability. If this is the case, try removing all
`xf86-video-*` packages.
