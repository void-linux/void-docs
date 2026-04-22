# NVIDIA

## nouveau (Kernel-Provided Driver)

This is a reverse engineered driver largely developed by the community, with
some documentation provided by Nvidia. It tends to perform well on older
hardware, and is required to use a large portion of the available Wayland
compositors.

### OpenGL

The accelerated OpenGL driver is provided by `mesa-dri`. This is a dependency of
the `xorg` metapackage, but must be manually installed when using `xorg-minimal`
or a Wayland compositor.

### Vulkan

Cards starting with Kepler (GTX 6xx) are supported by the Vulkan nouveau driver.
Install `vulkan-loader` and `mesa-vulkan-nouveau`. Older cards may perform
poorly or unreliably with Vulkan.

### Xorg

The `xorg` metapackage pulls in the `xf86-video-nouveau` video driver. This will
need to be manually installed when `xorg-minimal` is installed instead. You can
also use the universal `modesetting` driver bundled with Xorg (this is the only
option on Tegra-based ARM boards). When in doubt, it's a good idea to try
`xf86-video-nouveau` first. This driver will likely perform better.

### Video Acceleration

For VA-API, install `mesa-vaapi`. To ensure the nouveau VA-API driver is used,
set the environment variable `LIBVA_DRIVER_NAME` to `nouveau`.

For VDPAU, install `libvdpau-va-gl`. Set the environment variable `VDPAU_DRIVER`
to `va_gl`.

### Reclocking

Only first generation Maxwell, Kepler, and some Tesla cards support manual
reclocking. Cards past Turing (GTX 16xx) support automatic reclocking. Graphics
cards starting with second generation Maxwell (GTX 9xx) do not support
reclocking because the `linux-firmware` collection is missing signed firmware
blobs needed to reclock these cards past their boot frequencies.

## nvidia (Nvidia-Provided Driver)

The drivers provided by Nvidia offer better performance and power handling, and
are recommended where performance is needed.

They are available in the [nonfree
repository](../../../xbps/repositories/index.md#nonfree) and integrate in the
kernel through [DKMS](../../kernel.md#dynamic-kernel-module-support-dkms).

To determine the correct driver package to install, first find the family of
your card by running

```
$ lspci -k -d ::03xx
```

and matching the reported model to the [list of Nvidia GPU
codenames](https://nouveau.freedesktop.org/CodeNames.html).

| Family                           | Type        | Driver Package                             |
|----------------------------------|-------------|--------------------------------------------|
| Turing (NV160) and newer         | Open        | `nvidia`                                   |
| Maxwell (NV110) to Volta (NV140) | Proprietary | `nvidia580`                                |
| Kepler (NVE0)                    | Proprietary | `nvidia470`                                |
| Fermi (NVC0)                     | Proprietary | `nvidia390`                                |
| Tesla (NV50) and older           | Unsupported | use [nouveau](#nouveau-open-source-driver) |

## 32-bit program support (glibc only)

In order to run 32-bit programs with driver support, you need to install
additional packages.

If using the `nouveau` driver, install the `mesa-dri-32bit` package.

If using the `nvidia` driver, install the `nvidia<x>-libs-32bit` package. `<x>`
represents the legacy driver version (`580`, `470`, or `390`) or can be left
empty for the main driver.

## Reverting from nvidia to nouveau

### Uninstalling nvidia

In order to revert to the `nouveau` driver, install the [`nouveau`
driver](#nouveau-open-source-driver) (if it was not installed already), then
remove the `nvidia`, `nvidia580`, `nvidia470`, or `nvidia390` package, as
appropriate.

If you were using the obsolete `nvidia340` driver, you might need to install the
`libglvnd` package after removing the `nvidia340` package.

### Keeping both drivers

It is possible to use the `nouveau` driver while still having the `nvidia`
driver installed. To do so, remove the blacklisting of `nouveau` in
`/etc/modprobe.d/nouveau_blacklist.conf`, `/usr/lib/modprobe.d/nvidia.conf`, or
`/usr/lib/modprobe.d/nvidia-dkms.conf` by commenting it out:

```
#blacklist nouveau
```

For Xorg, specify that it should load the `nouveau` driver rather than the
`nvidia` driver by creating the file `/etc/X11/xorg.conf.d/20-nouveau.conf` with
the following content:

```
Section "Device"
    Identifier "Nvidia card"
    Driver "nouveau"
EndSection
```

You may need to reboot your system for these changes to take effect.
