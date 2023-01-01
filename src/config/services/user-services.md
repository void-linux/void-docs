# 每个用户的服务

有时候，拥有针对用户的runit服务是很好的。例如，你可能想以当前用户的身份打开一个ssh隧道，运行一个虚拟机，或者以你的名义运行守护程序。最常见的方法是创建一个系统级服务，以你的用户身份运行[runsvdir(8)](https://man.voidlinux.org/runsvdir.8) 。以便启动和监控个人目录中的服务

例如，你可以创建一个名为 `/etc/sv/runsvdir-<username>` 的服务，其 run` 如下，它应该是可执行的。

```
#!/bin/sh

export USER="<username>"
export HOME="/home/<username>"

groups="$(id -Gn "$USER" | tr ' ' ':')"
svdir="$HOME/service"

exec chpst -u "$USER:$groups" runsvdir "$svdir"
```

In this example [chpst(8)](https://man.voidlinux.org/chpst.8) is used to start a
new [runsvdir(8)](https://man.voidlinux.org/runsvdir.8) process as the specified
user. [chpst(8)](https://man.voidlinux.org/chpst.8) does not read groups on its
own, but expects the user to list all required groups separated by a `:`. The
`id` and `tr` pipe is used to create a list of all the user's groups in a way
[chpst(8)](https://man.voidlinux.org/chpst.8) understands it. Note that we
export `$USER` and `$HOME` because some user services may not work without them.

在这个例子中，[chpst(8)](https://man.voidlinux.org/chpst.8)  被用来以指定的用户身份启动一个新的 [runsvdir(8)](https://man.voidlinux.org/runsvdir.8) 进程。[chpst(8)](https://man.voidlinux.org/chpst.8) 不会自己读取组，而是期望用户列出所有由 `:` 隔的所需组。`id` 和 `tr` 管道被用来以 chpst(8) 理解的方式创建一个所有用户组的列表。注意，我们导出了 `$USER` `$HOME，因为有些用户服务没有它们可能无法工作。

The user can then create new services or symlinks to them in the
`/home/<username>/service` directory. To control the services using the
[sv(8)](https://man.voidlinux.org/sv.8) command, the user can specify the
services by path, or by name if the `SVDIR` environment variable is set to the
user's services directory. This is shown in the following examples:

```
$ sv status ~/service/*
run: /home/duncan/service/gpg-agent: (pid 901) 33102s
run: /home/duncan/service/ssh-agent: (pid 900) 33102s
$ SVDIR=~/service sv restart gpg-agent
ok: run: gpg-agent: (pid 19818) 0s
```

It may be convenient to export the `SVDIR=~/service` variable in your shell
profile.
