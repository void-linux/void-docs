# Services and Daemons

Void uses the [runit(8)](https://man.voidlinux.org/runit.8) supervision suite to
run system services and daemons.

Some advantages of using runit include:

- a small code base, making it easier to audit for bugs and security issues.
- each service is given a clean process state, regardless of how the service was
   started or restarted: it will be started with the same environment, resource
   limits, open file descriptors, and controlling terminals.
- a reliable logging facility for services, where the log service stays up as
   long as the relevant service is running and possibly writing to the log.

## Service directories

Each service managed by runit has an associated *service directory*.

A service directory requires only one file: an executable named `run`, which is
expected to exec a process in the foreground.

Optionally, a service directory may contain:

- an executable named `check`, which will be run to check whether the service is
   up and available; it's considered available if `check` exits with 0.
- an executable named `finish`, which will be run on shutdown/process stop.
- a `conf` file; this can contain environment variables to be sourced and
   referenced in `run`.
- a directory named `log`; a pipe will be opened from the output of the `run`
   process in the service directory to the input of the `run` process in the
   `log` directory.

When a new service is created, a `supervise` folder will be automatically
created on the first run.
