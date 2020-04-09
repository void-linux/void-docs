# Configuring Services

Most services have `run` files which include options for configuration. These
options can be set via a `conf` file in the service directory. This allows
service customization without modifying the service directory provided by the
relevant package.

To make more complex customizations than provided by default, edit the service.

## Editing services

To edit a service, first duplicate its service directory under a different name:

```
# cp -aR /etc/sv/service_name /etc/sv/service_name_edited
```

The contents of the duplicated directory can then be edited as needed, for
example, by using `vi(1)`:

```
# vi /etc/sv/service_name_edited
```

After editing, the old service should then be stopped, disabled and replaced
with the new one:

```
# sv down service_name
# rm /var/service/service_name
# ln -s /etc/sv/service_name_edited /var/service/
```
