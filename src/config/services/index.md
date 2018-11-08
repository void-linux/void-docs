# Services and daemons

Void uses the [runit](/usage/runit/) supervision suite to run system
services and daemons.

Services are enabled by simply linking them into the `/var/service`
service directory.

```
# ln -s /etc/sv/<service name> /var/service/
```

To disable them again you just remove the link.

```
# rm /var/service/<service name>
```

Activated services can be controlled with the
[sv(8)](https://man.voidlinux.eu/sv.8) command, following commands are
available and can be used like `sv <command> <services...>`.

* `up` to start, `down` to stop and `once` to start services once.  *
`pause`, `cont`, `hup`, `alarm`, `interrupt`, `quit`, `1`, `2`, `term`
and `kill` to send the corresponding signal.  * `start`, `stop`,
`reload` and `restart` for LSB init compatibility.

See the [sv(8)](https://man.voidlinux.eu/sv.8) manual page for further
informations.

The `status` command can be used to retrieve the current status of one
or more services.  It accepts either service names or service
directories, which makes it possible to use shell wildcards to
retrieve the status for all activated services.

```
# sv status dhcpcd
run: /var/service/dhcpcd: (pid 659) 561392s
# sv status /var/service/*
run: /var/service/agetty-tty1: (pid 658) 561392s
run: /var/service/agetty-tty2: (pid 639) 561392s
run: /var/service/agetty-tty3: (pid 662) 561392s
run: /var/service/agetty-ttyS0: (pid 650) 561392s
run: /var/service/dhcpcd: (pid 659) 561392s
run: /var/service/nanoklogd: (pid 666) 561391s
run: /var/service/ntpd: (pid 665) 561391s; run: log: (pid 664) 561391s
run: /var/service/opensmtpd: (pid 661) 561392s
run: /var/service/socklog-unix: (pid 646) 561392s; run: log: (pid 645) 561392s
run: /var/service/sshd: (pid 674) 561391s
run: /var/service/udevd: (pid 660) 561392s
run: /var/service/uuidd: (pid 640) 561392s
```

Extra options can be passed to most services using a `conf` file in
the service directory.

```
$ cat /etc/sv/sshd/run
#!/bin/sh
ssh-keygen -A >/dev/null 2>&1 # Will generate host keys if they don't already exist
[ -r conf ] && . ./conf
exec /usr/bin/sshd -D $OPTS
# echo 'OPTS="-p 2222"' >>/etc/sv/sshd/conf
```

Another example is the `wpa_supplicant` service which has other
available variables.

```
# cat /etv/sv/wpa_supplicant/run
#!/bin/sh
[ -r ./conf ] && . ./conf
exec 2>&1
exec wpa_supplicant -c ${CONF_FILE:=/etc/wpa_supplicant/wpa_supplicant.conf} -i ${WPA_INTERFACE:=wlan0} ${OPTS:=-s}
# echo WPA_INTERFACE=wlp3s0 >>/etc/sv/wpa_supplicant/conf
```
