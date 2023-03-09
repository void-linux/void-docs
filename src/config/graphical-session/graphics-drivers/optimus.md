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

A summary of the methods supported by Void, which are mutually exclusive:

[PRIME Render Offload](#prime-render-offload)

- available on `nvidia` and `nvidia470`
- allows to switch to the NVIDIA GPU on a per-application basis
- more flexible but power saving capabilities depend on the hardware (pre-Turing
   devices are not shut down completely)

Offloading Graphics Display with RandR 1.4

- available on `nvidia`, `nvidia470`, and `nvidia390`
- allows to choose which GPU to use at the start of the X session
- less flexible, but allows the user to completely shut down the NVIDIA GPU when
   not in use, thus saving power

[Bumblebee](#bumblebee)

- available on `nvidia`, `nvidia470`, and `nvidia390`
- allows to switch to the NVIDIA GPU on a per-application basis
- unofficial method, offers poor performance

[Nouveau PRIME](#nouveau-prime)

- uses the open source driver `nouveau`
- allows to switch to the NVIDIA GPU on a per-application basis
- `nouveau` is a reverse-engineered driver and offers poor performance

You can check the currently used GPU by searching for `renderer string` in the
output of the `glxinfo` command. It is necessary to install the `glxinfo`
package for this. For the first two alternatives below, it is also possible to
verify that a process is using the NVIDIA GPU by checking the output of
`nvidia-smi`.

## PRIME Render Offload

In this method, GPU switching is done by setting environment variables when
executing the application to be rendered on the NVIDIA GPU. The wrapper script
`prime-run` is available from the `nvidia` package, and can be used as shown
below:

```
$ prime-run <application>
```

For more information, see NVIDIA's
[README](https://download.nvidia.com/XFree86/Linux-x86_64/440.44/README/primerenderoffload.html)

## Bumblebee

Enable the `bumblebeed` service and add the user to the `bumblebee` group. This
requires a re-login to take effect.

Run the application to be rendered on the NVIDIA GPU with `optirun`:

```
$ optirun <application>
```

## Nouveau PRIME

This method uses the open source `nouveau` driver. If the NVIDIA drivers are
installed, it is necessary to [configure the system to use
`nouveau`](./nvidia.md#reverting-from-nvidia-to-nouveau).

Set `DRI_PRIME=1` to run an application on the NVIDIA GPU:

```
$ DRI_PRIME=1 <application>
```
