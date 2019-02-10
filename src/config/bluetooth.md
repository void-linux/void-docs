# Bluetooth

Ensure the bluetooth controller is not blocked. Use `rfkill` to check whether
there are any blocks and to remove soft blocks. If there is a hard block, there
is likely either a physical hardware switch or an option in the BIOS to enable
the bluetooth controller.

```
$ rfkill
ID TYPE     DEVICE      SOFT      HARD
0 wlan      phy0   unblocked unblocked
1 bluetooth hci0     blocked unblocked

# rfkill unblock bluetooth
```

## Installation

Install the `bluez` package.

```
# xbps-install -S bluez
```

Enable the `bluetoothd` and `dbus` services.

```
# ln -s /etc/sv/dbus /var/service
# ln -s /etc/sv/bluetoothd /var/service
```

Add your user to the `bluetooth` group and restart the `dbus` service, or simply
reboot the system. Note that restarting the `dbus` service may kill processes
making use of it.

```
# usermod -a -G bluetooth $USER
# sv restart dbus
```

> Note: To use an audio device such as a wireless speaker or headset, ALSA users
> need to install the `bluez-alsa` package, while
> [PulseAudio](./media/pulseaudio.md) users do not need any additional software.

## Usage

Manage bluetooth connections and controllers using `bluetoothctl`. It uses a
command line interface; to find out what commands are available, enter `help`.
To exit, enter `exit` or `quit`.

```
$ bluetoothctl

[bluetooth]# help
Menu main:
Available commands:
-------------------
advertise             Advertise Options Submenu
scan                  Scan Options Submenu
gatt                  Generic Attribute Submenu
list                  List available controllers
show [ctrl]           Controller information
select <ctrl>         Select default controller
devices               List available devices
paired-devices        List paired devices
...
```

Consult the [Arch Wiki](https://wiki.archlinux.org/index.php/Bluetooth#Pairing)
page for an example on how to pair a device.

`bluetoothctl` also accepts taking commands from stdin.

```
$ echo "devices" | bluetoothctl
Agent registered
[bluetooth]# devices
Device XX:XX:XX:XX:XX:XX Mouse
Device XX:XX:XX:XX:XX:XX Keyboard
Device XX:XX:XX:XX:XX:XX Speaker
Device XX:XX:XX:XX:XX:XX Headset
```

## Configuration

The main configuration file is `/etc/bluetooth/main.conf`.
