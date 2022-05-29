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
documentation](https://www.kernel.org/doc/html/latest/x86/intel-iommu.html#graphics-problems).
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

On chromium based browsers, even with flags `--enable-features=VaapiVideoDecoder
--disable-features=UseChromeOSDirectVideoDecoder`, and hardware acceleration
reported to be enabled in `chrome://gpu` you might be able to see that the
iGPU is not being selected/used with "VDA Error 4" on `chrome://media-internals`
and `VpxVideoDecoder` is being selected instead. In that case, you have to build
the `intel-media-driver` package with `nonfree` option from the
[void-packages](https://github.com/void-linux/void-packages) source repository.
Check the Media panel in the inspector while playing a video on the web
to confirm that hardware decoding is working.

Note that for video with less resolution than 480p on youtube you may not see use of
hardware acceleration and CPU might bump the load instead, to fix this you might
be interested in using
[enhanced-h264ify](https://chrome.google.com/webstore/detail/enhanced-h264ify/omkfmpieigblcllmkgbflkikinpkodlk)
extension, for disabling VPx/AV1 video codecs.
