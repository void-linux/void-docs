# Podman

**Podman** is a daemonless engine for developing, managing, and running pods,
containers, and container images.

## Installation

Install the `podman` package.

## Checking installation

To check your installation of podman, run the following command:

`$ podman run -dt -p 8080:8080/tcp registry.fedoraproject.org/f29/httpd`

Then, open a Internet browser and navigate to `0.0.0.0:8080` in the address bar.
If you see a message about a test page and apache server running, podman is
running correctly.

To see more podman commands, and walk through basic tutorials, see the [getting
started](https://podman.io/getting-started/) page.

## Troubleshooting

### OCI runtime error

You may receive the following message when you issue a podman command:

```
Error: container_linux.go:349: starting container process caused "process_linux.go:449: container init caused \"process_linux.go:378: setting rlimits for ready process caused \\\"error setting rlimit type 7: invalid argument\\\"\"": OCI runtime error
```

If this occurs, rerun the command with `sudo` privileges.
