# Macbookpro 12,1 (early 2015) 

Everything is well supported on this laptop and install will work without problems. Post-installation, after having booted to your newly installed system, there is however a few points that need a little bit of work.

## keymap are wrong
This is a problem inherited by a few distros, including archlinux.
tty keymaps for the macbooks (mac-fr, mac-us, mac-de) are completely broken and *you should not attempt to use them*, or it will result in an unusable keyboard and you will be forced to do a hard reset on your system. as a workaround generic keymaps
work well (fr, us, de ..) you can use those for starter. later on you can find working ones and install/use them. here i've found a working one for the french macbook keyboards: [forums.archlinux.fr](https://forums.archlinux.fr/viewtopic.php?t=8679)

```
cd /usr/share/kbd/keymaps/mac/all
wget ftp://ftp.linux-france.org/pub/macintosh/mac-fr-ext_new.map.gz
localectl set-keymap mac-fr-ext_new
```

if that works for you you can add it to the `/etc/rc.conf` modify that line accordingly:

```
# Keymap to load, see loadkeys(8).
KEYMAP=mac-fr-ext_new
```

## fonts are too small
on macbookpro the hidpi screen makes the font really small and hard to read. the default resolution is 2560x1600. you need to install the `terminus-font` package, then use it like shown below:

```
sudo xbps-install -Su terminus-font
setfont ter-u32b
```

if that works well for you add it to the `/etc/rc.conf` file:

```
# Console font to load, see setfont(8).
FONT="ter-u32b"
```

## mouse pointer only move up and down
after having Xorg installed, the first time you will start it you will noticed your pointer only moves up and down when using the touchpad. this is because the usbmouse module is getting loaded and used instead of the bcm5974 device (the touchpad). as a workaround you can do this:

```
echo "blacklist usbmouse" | sudo tee /etc/modprobe.d/usbmouse.conf
sudo dracut --force --add-drivers bcm5974 --omit-drivers usbmouse
```

then reboot and try to start xorg again. if that works well for you, you can make that permanent like so:

```
echo 'omit_drivers+="usbmouse"' | sudo tee /etc/dracut.conf.d/disable-usbmouse.conf
echo 'drivers+="bcm5974"' | sudo tee /etc/dracut.conf.d/bcm5974.conf
```

so when you get your kernel updated you won't have to run `sudo dracut --force --add-drivers bcm5974 --omit-drivers usbmouse` each time.
