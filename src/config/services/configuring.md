# Configuring Services

Most services have `run` files which include options for configuration. These
options can be set via a `conf` file in the service directory. This allows
service customization without modifying the service directory provided by the
relevant package.

Check the service file for how to pass configuration parameters, but services
usually expect `OPTS="--value ..."` as values.

To make more complex customizations than provided by default, edit the service.

## Editing services

To edit a service, first copy its service directory to a different directory
name, otherwise [xbps-install(1)](https://man.voidlinux.org/xbps-install.1) will
overwrite the service directory. Then, edit the new service file as needed.
Finally, the old service should be stopped, and the new one should be started.
