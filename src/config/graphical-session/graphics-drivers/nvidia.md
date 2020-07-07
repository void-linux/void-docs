# NVIDIA

## nouveau (Open Source Driver)

This driver is developed mostly by the community, with little input from Nvidia,
and is not as performant as the proprietary driver. It is required in order to
run most Wayland compositors.

Install the `mesa-dri` driver or the `xf86-video-nouveau` driver.

Xorg can make use of either of the above mentioned drivers. The latter is older,
more stable and generally the recommended option. However, for newer devices you
might get better performance by using the `mesa-dri` provided driver.

Note: `xf86-video-nouveau` is already included in the `xorg` meta-package, but
is needed when installing via `xorg-minimal`.

For using Wayland, users should install the `mesa-dri` provided driver.

## nvidia (Proprietary Driver)

The proprietary drivers are available in the [nonfree
repository](../../../xbps/repositories/index.md#nonfree).

Check if your graphics card belongs to the [legacy
branch](https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/). If it does not,
install the `nvidia` package. Otherwise you should install the appropriate
legacy driver, either `nvidia390` or `nvidia340`.

| Brand  | Type        | Model                           | Driver Package |
|--------|-------------|---------------------------------|----------------|
| NVIDIA | Proprietary | 500+                            | `nvidia`       |
| NVIDIA | Proprietary | 300/400 Series                  | `nvidia390`    |
| NVIDIA | Proprietary | GeForce8/9 + 100/200/300 Series | `nvidia340`    |

The proprietary driver integrates in the kernel through
[DKMS](../../kernel.md#dynamic-kernel-module-support-dkms).

This driver offers better performance and power handling, and is recommended
where performance is needed.

## 32-bit program support (glibc only)

In order to run 32-bit programs with driver support, you need to install
additional packages.

If using the `nouveau` driver, install the `mesa-dri-32bit` package.

If using the `nvidia` driver, install the `nvidia<x>-libs-32bit` package. `<x>`
represents the legacy driver version (340 or 390) or can be left empty for the
main driver.

## Reverting from nvidia to nouveau

### Uninstalling nvidia

In order to revert to the `nouveau` driver, install the [`nouveau`
driver](#nouveau-open-source-driver) (if it was not installed already), then
remove the `nvidia`, `nvidia390` or `nvidia340` package, as appropriate.

If you were using the `nvidia340` driver, you will need to install the
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
