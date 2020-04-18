# Intel GPU

## OpenGL

Install the Mesa DRI package, `mesa-dri`.

> Note: This is already included in the `xorg` meta-package, but it is needed
> when installing xorg via `xorg-minimal` or for running a Wayland compositor.

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
