# Docker

Docker is a platform of products to build isolated containers for programs using
visualization.

## Getting Started with Docker.

After installing the 'docker' package (and optionally, the `docker-compose`
package), enable the `docker` service:

```
# ln -s /etc/sv/docker /var/service
```

and add your user to the `docker` group:

```
# usermod -aG docker $USER
```

You will know you have properly installed docker if you can run it in the
terminal with the `docker` command. Issuing this command will result in a long
list of text displayed to users about docker and how it can be used. It will
result in text being displayed like the following:

```
$ docker

Usage:  docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
  ...
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Management Commands:
  ...
  trust       Manage trust on Docker images
  volume      Manage volumes

Commands:
  ...
  version     Show the Docker version information
  wait        Block until one or more containers stop, then print their exit codes

Run 'docker COMMAND --help' for more information on a command.
```

Please note the output has been shortened for readability. For more information
about Docker commands, please read the [official
documentation](https://docs.docker.com/). For more information about
docker-compose commands, see the [official
documentation](https://docs.docker.com/compose/).

## Void Linux Docker Images

Void Linux maintains Docker images for use in containers. There is an image for
Void Linux with musl and an image for Void Linux with glibc. All images can be
found on [Dockerhub](https://hub.docker.com/u/voidlinux).

To download the musl-based image run:

```
docker pull voidlinux/voidlinux-musl
```

To download the glib-based image run:

```
docker pull voidlinux/voidlinux
```

You then can issue other docker commands or use the image in a Dockerfile. Note,
the Void Linux images also can be used in a docker-compose file. If you need
clarification, please refer to the documentation. In addition, there are plenty
of guides on working with docker on-line.

## Troubleshooting

### cgroups bug

Docker seems to require systemd cgroups to be mounted on /sys/fs/cgroup/systemd.
You may get the following error while running docker:

```
$ docker: Error response from daemon: cgroups: cannot found cgroup mount destination: unknown.
```

To fix the error, create the directory, and mount systemd cgroups there:

```
# mkdir /sys/fs/cgroup/systemd
# mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
```
