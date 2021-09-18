# AppArmor

AppArmor is a mandatory access control mechanism (like SELinux). It can
constrain programs based on pre-defined or generated policy definitions.

Void ships with some default profiles for several services, such as `dhcpcd` and
`wpa_supplicant`. Container runtimes such as LXC and podman integrate with
AppArmor for better security for container payloads.

To use AppArmor on a system, one must:

1. Install the `apparmor` package.
2. Set `apparmor=1 security=apparmor` on the kernel commandline.

To accomplish the second step, consult [the documentation on how to modify the
kernel cmdline](./../kernel.md#cmdline).

The `APPARMOR` variable in `/etc/default/apparmor` controls how profiles will be
loaded at boot, the value is set to `complain` by default and corresponds to
AppArmor modes (`disable`, `complain`, `enforce`).

AppArmor tools [aa-genprof(8)](https://man.voidlinux.org/aa-genprof.8) and
[aa-logprof(8)](https://man.voidlinux.org/aa-logprof.8) require either
configured [syslog](../services/logging.md) or a running
[auditd(8)](https://man.voidlinux.org/auditd.8) service.
