# Sway

## Pre-installation

You need a seat management program as a prerequisite. You can use either
`elogind` or `seatd` by following the instructions
[here](../session-management.md). Also [install a video
driver](./graphics-drivers/index.md) such as `mesa-dri`.

## Installation

Install the `sway` package. You might also want to install `alacritty`, `dmenu`,
`swaylock`, and `swayidle`, as they are programs used in in the default
configuration file.

If you're using `seatd`, you will have to set `XDG_RUNTIME_DIR` manually before
starting Sway:

```````
dr=/run/user/$(id -u)
sudo mkdir -p $dr && sudo chown $USER:$USER $dr && sudo chmod 700 $dr && XDG_RUNTIME_DIR=$dr sway
```````

Note that `swayidle` requires `elogind` to automatically lock the screen before
sleep. If you do not want to use `elogind`, you could instead set up a
key-binding that locks the screen then suspends the system:

`bindsym $mod+Shift+x exec swaylock -c 000000 & sudo zzz`
