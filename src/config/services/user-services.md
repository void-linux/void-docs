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

在这个例子中，[chpst(8)](https://man.voidlinux.org/chpst.8)  被用来以指定的用户身份启动一个新的 [runsvdir(8)](https://man.voidlinux.org/runsvdir.8) 进程。[chpst(8)](https://man.voidlinux.org/chpst.8) 不会自己读取组，而是期望用户列出所有由 `:` 隔的所需组。`id` 和 `tr` 管道被用来以 chpst(8) 理解的方式创建一个所有用户组的列表。注意，我们 export 了 `$USER` 和 `$HOME`，因为有些用户服务没有它们可能无法工作。

然后，用户可以在 `/home/<username>/service` 目录中创建新的服务或它们的符号链接。为了使用 [sv(8)](https://man.voidlinux.org/sv.8) 命令控制服务，用户可以通过路径指定服务，如果 `SVDIR` 环境变量被设置为用户的服务目录，也可以通过名称指定服务。这在下面的例子中显示：
  
```
$ sv status ~/service/*
run: /home/duncan/service/gpg-agent: (pid 901) 33102s
run: /home/duncan/service/ssh-agent: (pid 900) 33102s
$ SVDIR=~/service sv restart gpg-agent
ok: run: gpg-agent: (pid 19818) 0s
```

在你的 shell 配置文件中 export `SVDIR=~/service` 变量可能比较方便。
