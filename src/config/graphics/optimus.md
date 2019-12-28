# NVIDIA Optimus

NVIDIA Optimus refers to a dual graphics configuration found on laptops
consisting of an Intel integrated GPU and a discrete NVIDIA GPU.

There are different methods to take advantage of the NVIDIA GPU, which depend on
the driver version supported by your hardware.

In order to determine the correct driver to install, it is not enough to look at
the "Supported Products" list on NVIDIA's website, because they are not
guaranteed to work in an Optimus configuration. So the only way is to try
installing the latest `nvidia`, rebooting, and looking at the kernel log. If
your device is not supported, you will see a message like this:

```
NVRM: The NVIDIA GPU xxxx:xx:xx.x (PCI ID: xxxx:xxxx)
NVRM: installed in this system is not supported by the xxx.xx
NVRM: NVIDIA Linux driver release.  Please see 'Appendix
NVRM: A - Supported NVIDIA GPU Products' in this release's
NVRM: README, available on the Linux driver download page
NVRM: at www.nvidia.com.
```

which means you have to uninstall `nvidia` and install the legacy `nvidia390`.

A summary of the methods supported by Void:

[PRIME Render Offload](#prime-render-offload)

- only available on `nvidia`
- allows to switch to the NVIDIA GPU on a per-application basis
- more flexible but power saving capabilities depend on the hardware (pre-Turing
   devices are not shut down completely)

Offloading Graphics Display with RandR 1.4

- available on `nvidia` and `nvidia390`
- allows to choose which GPU to use at the start of the X session
- less flexible but allows to shut down completely the NVIDIA GPU when not in
   use, thus saving power

Nouveau PRIME

- uses the open source driver `nouveau`
- allows to switch to the NVIDIA GPU on a per-application basis
- `nouveau` is a reverse-engineered driver and offers poor performance

## PRIME Render Offload

In this method, GPU switching is done via setting environment variables when
executing the application to be renderered on the NVIDIA GPU. Thus one can
easily write a small wrapper script `prime-run` with the following contents:

```
#!/bin/sh
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only "$@"
```

To verify that the variables are honored, check for the vendor returned by the
following command (install the package `glxinfo`):

```
$ prime-run glxinfo | grep "renderer string"
```

and compare it with:

```
$ glxinfo | grep "renderer string"
```

For more information, see NVIDIA's
[README](https://download.nvidia.com/XFree86/Linux-x86_64/440.44/README/primerenderoffload.html)
