# AppArmor

AppArmor is a mandatory access control mechanism (like SELinux). It can
constrain programs based on pre-defined or generated policy definitions.

Void ships with some default profiles for several services, such as `dhcpcd` and
`wpa_supplicant`. Container runtimes such as LXC and podman integrate with
AppArmor for better security for container payloads.

To use AppArmor on a system, one must:

1. Install the `apparmor` package.
2. Set the `APPARMOR` variable in `/etc/default/apparmor` to `enforce` or
   `complain`.
3. Set `apparmor=1 security=apparmor` on the kernel commandline.

To accomplish the third step, consult [the documentation on how to modify the
kernel cmdline](./../kernel.md#cmdline).
