# Bluetooth

Ensure the Bluetooth controller is not blocked. Use `rfkill` to check whether
there are any blocks and to remove soft blocks. If there is a hard block, there
is likely either a physical hardware switch or an option in the BIOS to enable
the Bluetooth controller.

```
$ rfkill
ID TYPE     DEVICE      SOFT      HARD
0 wlan      phy0   unblocked unblocked
1 bluetooth hci0     blocked unblocked

# rfkill unblock bluetooth
```

## Installation

Install the `bluez` package and enable the `bluetoothd` and `dbus` services.
Then, add your user to the `bluetooth` group and restart the `dbus` service, or
simply reboot the system. Note that restarting the `dbus` service may kill
processes making use of it.

> Note: To use an audio device such as a wireless speaker or headset, ALSA users
> need to install the `bluez-alsa` package, while
> [PulseAudio](./media/pulseaudio.md) users do not need any additional software.

## Usage

Manage Bluetooth connections and controllers using `bluetoothctl`, which
provides a command line interface and also accepts commands on standard input.

Consult the [Arch Wiki](https://wiki.archlinux.org/index.php/Bluetooth#Pairing)
for an example of how to pair a device.

## Configuration

The main configuration file is `/etc/bluetooth/main.conf`.
