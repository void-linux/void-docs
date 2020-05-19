# Wicd

> Warning: Wicd sees no active development. The last release occurred in 2016,
> and the program has not been ported to Python3. Use of Wicd is not
> recommended.

Wicd can be used to manage wired and wireless network interfaces, much like
[NetworkManager](./networkmanager.md) or [ConnMan](./connman.md).

Wicd does not require `dhcpcd` or `wpa_supplicant` services managed by runit.
Disable these services before enabling the `wicd` service to avoid conflicts.

Users must be in the `users` group to access the Wicd service.
