# Console

## Disabling default ttys

Void Linux enables [agetty(8)](https://man.voidlinux.org/agetty.8) services for
the ttys 1 to 6 by default.

To disable agetty services remove the service symlink and create a `down` file
in the agetty service directory to avoid that updates of the `runit-void`
package re-enable the service.

```
# rm /var/service/agetty-tty6
# touch /etc/sv/agetty-tty6/down
```

