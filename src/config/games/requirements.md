In order to prepare Void Linux for games, first you need to check your video
card. To do this, run the following command:

```
$ lspci | grep Graphic
```

According to the result,
[install](https://docs.voidlinux.org/config/graphical-session/xorg.html#video-drivers)
the correct driver for your card.

Games only work through a graphics server. Choose between
[Xorg](./src/config/graphical-session/xorg.md) or
[Wayland](./src/config/graphical-session/wayland.md) for this.

After performing these steps, increase the performance of your games by
installing support for
[Vulkan](https://docs.voidlinux.org/config/graphical-session/graphics-drivers/intel.html#vulkan).
If you have difficulty finding a specific package, enable support for the
multilib repository. Click [here](./src/xbps/repositories/official/multilib.md)
to learn more.

Finally, install graphics acceleration support. Add the correct value for the
LIBVA_DRIVER_NAME variable in the `/etc/environment` file. See
[here](https://docs.voidlinux.org/config/graphical-session/graphics-drivers/intel.html#video-acceleration)
for more details.
