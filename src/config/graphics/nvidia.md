# Nvidia GPU

## nouveau (Open Source drivers)

Install the Mesa DRI drivers and Xorg Drivers:

```
# xbps-install -S mesa-nouveau-dri xf86-video-nouveau
```

> Note: This is already included in the `xorg` metapackage, but it is needed
> when installing xorg via `xorg-minimal` or for running a Wayland compositor.

In order to run 32-bit programs, install the `mesa-nouveau-dri-32bit` package.

These drivers are developed mostly by the community, with little input from
Nvidia, and are not as performant as the proprietary drivers. They are required
in order to run Wayland compositors based on `wlroots`.

## nvidia (Proprietary drivers)

If your graphics card is fairly new, install the drivers:

```
# xbps-install -S nvidia nvidia-libs
```

If you don't already know what graphics card you have, run:

```
# lspci -k | grep -A 2 -E "(VGA|3D)"
```

Check if your graphics card belongs to the legacy branch. If you find it on 
[this](https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/) list, you should
install either the 390 or 340 <version>:

```
# xbps-install -S nvidia<version> nvidia<version>-libs
```

In order to run 32-bit programs, install the `nvidia-libs-32bit` package,
for your specific version.

While these drivers offer better performance and handling of the GPU, they lack
the fbdev driver responsible with the high-resolution console. They're also
unsupported by the Sway team (and wlroots implicitly).

## Reverting from nvidia to nouveau

In order to revert to nouveau, install the nouveau drivers, then remove the nvidia
ones:

```
# xbps-remove nvidia nvidia-libs
```
