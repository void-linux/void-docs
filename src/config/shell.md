# Shell

## Changing users default shell

The default shell for users can be changed with the
[chsh(1)](https://man.voidlinux.org/chsh.1) tool.

```
$ chsh -s /bin/bash <user name>
```

Make sure to use the same path to the shell as its in `/etc/shells` or listed by
the [chsh(1)](https://man.voidlinux.org/chsh.1) list command.

A list of available installed shells can be retrieved with the
[chsh(1)](https://man.voidlinux.org/chsh.1) list command.

```
$ chsh -l
/bin/sh
/bin/bash
/bin/mksh
/bin/zsh
/bin/rc
/bin/ksh
/bin/loksh
/bin/yash
```

Following packages are available in the package repository and provide usable
shells.

- bash
- dash
- elvish
- es
- fish-shell
- heirloom-sh
- ksh
- mksh
- loksh
- posh
- rc
- tcsh
- yash
- zsh
